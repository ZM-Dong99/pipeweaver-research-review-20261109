"""Exact-source mux_large rewrites distilled from measured model proposals.

Only the public10x8 native module is qualified. No generic AST matching,
parameter inference, input assumptions or four-state equivalence claim.
"""
import hashlib
import re
SOURCE_SHA256 = '4559cc484e66258f2a4d477231e3159ef80117eb2acff1bb1855074f38835611'
BASE_RTL = """module mux_large (
    input [7:0] block_a, block_b, block_c, block_d, block_e,
    input [7:0] block_f, block_g, block_h, block_i, block_j,
    input [3:0] sel,
    output reg [7:0] block_out
);
    wire select_a;
    wire select_b, select_c, select_d, select_e;
    wire select_f, select_g, select_h, select_i, select_j;

    assign select_a = (~sel[3] & ~sel[2] & ~sel[1] & ~sel[0])
                    | (sel[3] & (sel[2] | sel[1]));
    assign select_b = (sel == 4'd1);
    assign select_c = (sel == 4'd2);
    assign select_d = (sel == 4'd3);
    assign select_e = (sel == 4'd4);
    assign select_f = (sel == 4'd5);
    assign select_g = (sel == 4'd6);
    assign select_h = (sel == 4'd7);
    assign select_i = (sel == 4'd8);
    assign select_j = (sel == 4'd9);

    always @(*) begin
        block_out = ({8{select_a}} & block_a)
                  | ({8{select_b}} & block_b)
                  | ({8{select_c}} & block_c)
                  | ({8{select_d}} & block_d)
                  | ({8{select_e}} & block_e)
                  | ({8{select_f}} & block_f)
                  | ({8{select_g}} & block_g)
                  | ({8{select_h}} & block_h)
                  | ({8{select_i}} & block_i)
                  | ({8{select_j}} & block_j);
    end
endmodule
"""

def actions():
    return [dict(operator='masked_mux_default', encoding=e) for e in
            ['minimal', 'range', 'complement', 'shared']]

def materialize(source, spec):
    if type(spec) is not dict or set(spec) != {'operator','encoding'}:
        raise ValueError('Exact mux action fields required')
    if spec['operator'] != 'masked_mux_default' or spec['encoding'] not in ['minimal','range','complement','shared']:
        raise ValueError('Unknown mux rewrite action')
    source=source.replace('\r\n','\n')
    if hashlib.sha256(source.encode('utf-8')).hexdigest() != SOURCE_SHA256:
        raise ValueError('Exact qualified mux_large source required')
    rtl=BASE_RTL
    if spec['encoding'] in ['range','complement']:
        rhs = "(sel == 4'd0) | (sel >= 4'd10)" if spec['encoding']=='range' else '~(select_b | select_c | select_d | select_e | select_f | select_g | select_h | select_i | select_j)'
        rtl, count=re.subn(r'assign select_a\s*=.*?;',f'assign select_a = {rhs};',rtl,count=1,flags=re.S)
        if count!=1:raise ValueError('Default template changed')
    if spec['encoding']=='shared':
        declarations=[]
        for i in range(4):
            declarations.append(f'wire low_{i} = '+('sel[1]' if i&2 else '~sel[1]')+' & '+('sel[0]' if i&1 else '~sel[0]')+';')
        for i in range(3):
            declarations.append(f'wire high_{i} = '+('sel[3]' if i&2 else '~sel[3]')+' & '+('sel[2]' if i&1 else '~sel[2]')+';')
        rtl=rtl.replace('    assign select_a =','    '+'\n    '.join(declarations)+'\n    assign select_a =',1)
        for i,c in enumerate('bcdefghij',1):
            old=f"assign select_{c} = (sel == 4'd{i});"
            if rtl.count(old)!=1:raise ValueError('Shared template changed')
            rtl=rtl.replace(old,f'assign select_{c} = high_{i//4} & low_{i%4};',1)
    return rtl
