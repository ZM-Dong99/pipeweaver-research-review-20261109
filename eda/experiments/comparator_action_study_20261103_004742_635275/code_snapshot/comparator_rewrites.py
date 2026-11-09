"""Whitelisted structural actions for one canonical unsigned comparator template.

This is deliberately not a general RTL parser. Unknown source bytes (after LF
normalization), extra action keys, unsupported actions and widths fail closed.
N is a positive elaboration-time parameter; each experiment still requires
source and actual mapped-netlist equivalence against the unchanged original.
"""
import argparse
import hashlib
import json
from pathlib import Path

CANONICAL_TEXT_SHA256='f17e486f9af6526abe22b0ae2ff2a8873febc28883e945db680bfabc22208526'
OPERATOR='unsigned_chunk_compare'
CHUNK_BITS=(2,4,8)
TOPOLOGIES=('balanced','linear')

def materialize(source,spec):
    if type(spec) is not dict or set(spec)!={'operator','chunk_bits','topology'}:
        raise ValueError('Action must contain exactly operator, chunk_bits, topology')
    if spec['operator']!=OPERATOR or type(spec['chunk_bits']) is not int or spec['chunk_bits'] not in CHUNK_BITS or spec['topology'] not in TOPOLOGIES:
        raise ValueError('Unsupported whitelisted action')
    source=source.replace('\r\n','\n')
    if hashlib.sha256(source.encode('utf-8')).hexdigest()!=CANONICAL_TEXT_SHA256:
        raise ValueError('Source is not the qualified canonical unsigned template')
    old='wire cmp_equal = (value1 == value2);\nwire cmp_greater = (value1 > value2);'
    if source.count(old)!=1:raise ValueError('Unique replacement region not found')
    k=spec['chunk_bits']
    logic=f'''// PipeWeaver whitelisted action: {spec['topology']}, chunk_bits={k}.
localparam integer PW_GROUP_BITS = {k};
localparam integer PW_GROUPS = (N + PW_GROUP_BITS - 1) / PW_GROUP_BITS;
wire [PW_GROUPS-1:0] pw_chunk_eq, pw_chunk_gt;
genvar pw_chunk;
generate
    for (pw_chunk=0; pw_chunk<PW_GROUPS; pw_chunk=pw_chunk+1) begin : pw_compare_chunks
        localparam integer LO = pw_chunk*PW_GROUP_BITS;
        localparam integer HI = (LO+PW_GROUP_BITS > N) ? N-1 : LO+PW_GROUP_BITS-1;
        assign pw_chunk_eq[pw_chunk] = value1[HI:LO] == value2[HI:LO];
        assign pw_chunk_gt[pw_chunk] = value1[HI:LO] > value2[HI:LO];
    end
endgenerate
'''
    if spec['topology']=='balanced':
        logic+='''localparam integer PW_LEAVES = 1 << $clog2(PW_GROUPS);
wire [2*PW_LEAVES-1:1] pw_eq_tree, pw_gt_tree;
genvar pw_leaf, pw_node;
generate
    for (pw_leaf=0; pw_leaf<PW_LEAVES; pw_leaf=pw_leaf+1) begin : pw_tree_leaves
        if (pw_leaf<PW_GROUPS) begin : real_chunk
            assign pw_eq_tree[PW_LEAVES+pw_leaf] = pw_chunk_eq[pw_leaf];
            assign pw_gt_tree[PW_LEAVES+pw_leaf] = pw_chunk_gt[pw_leaf];
        end else begin : neutral_padding
            assign pw_eq_tree[PW_LEAVES+pw_leaf] = 1'b1;
            assign pw_gt_tree[PW_LEAVES+pw_leaf] = 1'b0;
        end
    end
    for (pw_node=1; pw_node<PW_LEAVES; pw_node=pw_node+1) begin : pw_tree_nodes
        assign pw_eq_tree[pw_node] = pw_eq_tree[2*pw_node+1] & pw_eq_tree[2*pw_node];
        assign pw_gt_tree[pw_node] = pw_gt_tree[2*pw_node+1] | (pw_eq_tree[2*pw_node+1] & pw_gt_tree[2*pw_node]);
    end
endgenerate
wire cmp_equal = pw_eq_tree[1];
wire cmp_greater = pw_gt_tree[1];'''
    else:
        logic+='''wire [PW_GROUPS:0] pw_eq_chain, pw_gt_chain;
assign pw_eq_chain[0] = 1'b1;
assign pw_gt_chain[0] = 1'b0;
genvar pw_stage;
generate
    for (pw_stage=0; pw_stage<PW_GROUPS; pw_stage=pw_stage+1) begin : pw_chain_nodes
        assign pw_eq_chain[pw_stage+1] = pw_chunk_eq[pw_stage] & pw_eq_chain[pw_stage];
        assign pw_gt_chain[pw_stage+1] = pw_chunk_gt[pw_stage] | (pw_chunk_eq[pw_stage] & pw_gt_chain[pw_stage]);
    end
endgenerate
wire cmp_equal = pw_eq_chain[PW_GROUPS];
wire cmp_greater = pw_gt_chain[PW_GROUPS];'''
    return source.replace(old,logic,1)

def actions():
    return [dict(operator=OPERATOR,chunk_bits=k,topology=t) for t in TOPOLOGIES for k in CHUNK_BITS]

def main():
    ap=argparse.ArgumentParser(description=__doc__);ap.add_argument('--source',required=True,type=Path);ap.add_argument('--spec',required=True,type=Path);ap.add_argument('--out',required=True,type=Path)
    a=ap.parse_args();rtl=materialize(a.source.read_text(encoding='utf-8'),json.loads(a.spec.read_text(encoding='utf-8')))
    with a.out.open('x',encoding='utf-8') as f:f.write(rtl)
if __name__=='__main__':main()
