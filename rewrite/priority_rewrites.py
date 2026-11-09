"""Guarded grouped-winner templates extracted from a validated model proposal.

Exact upstream source only. MSB-priority fast path; original fallback preserves
LSB behavior and non-default derived-parameter semantics. Not a generic parser.
"""
import hashlib
SOURCE_SHA256='df28220d95b47df349a72803a9751aad331eb8e1435416e8686d00572a974dd5'
def actions():
    return [dict(operator='grouped_priority',group_bits=g,encoding=e) for e in ['group_factored','global_onehot'] for g in [8,16,32]]
def materialize(source,spec):
    if type(spec) is not dict or set(spec)!={'operator','group_bits','encoding'}:raise ValueError('Exact action fields required')
    if spec['operator']!='grouped_priority' or type(spec['group_bits']) is not int or spec['group_bits'] not in [8,16,32] or spec['encoding'] not in ['group_factored','global_onehot']:
        raise ValueError('Unknown priority rewrite action')
    source=source.replace('\r\n','\n')
    if hashlib.sha256(source.encode('utf-8')).hexdigest()!=SOURCE_SHA256:raise ValueError('Qualified upstream priority encoder required')
    start=source.index('// pad input to even power of two');end=source.index('\nendmodule',start)
    fallback=source[start:end]
    if fallback.count('\ngenerate\n')!=1 or fallback.count('\nendgenerate\n')!=1:raise ValueError('Fallback template changed')
    fallback=fallback.replace('\ngenerate\n','\n',1).replace('\nendgenerate\n','\n',1)
    g=spec['group_bits']
    body=f'''generate
if (WIDTH >= 2 && LSB_HIGH_PRIORITY == 0 && LEVELS == ((WIDTH > 2) ? $clog2(WIDTH) : 1) && W == 2**LEVELS) begin : pw_grouped
    localparam integer GB = {g};
    localparam integer GROUPS = (WIDTH+GB-1)/GB;
    localparam integer PAD = GROUPS*GB;
    localparam integer LOW_BITS = $clog2(GB);
    wire [PAD-1:0] padded = {{{{(PAD-WIDTH){{1'b0}}}},input_unencoded}};
    wire [GROUPS-1:0] group_valid,group_enable,group_winner;
    wire [PAD-1:0] local_winner,global_winner;
    genvar pg,pj,pb,pe,pk;
    for (pg=0; pg<GROUPS; pg=pg+1) begin : groups
        assign group_valid[pg] = |padded[pg*GB +: GB];
        if (pg==GROUPS-1) begin : top
            assign group_enable[pg] = 1'b1;
        end else begin : remaining
            assign group_enable[pg] = ~(|group_valid[GROUPS-1:pg+1]);
        end
        assign group_winner[pg] = group_valid[pg] & group_enable[pg];
        for (pj=0; pj<GB; pj=pj+1) begin : bits_in_group
            if (pj==GB-1) begin : top
                assign local_winner[pg*GB+pj] = padded[pg*GB+pj];
            end else begin : remaining
                assign local_winner[pg*GB+pj] = padded[pg*GB+pj] & ~(|padded[pg*GB+GB-1:pg*GB+pj+1]);
            end
            assign global_winner[pg*GB+pj] = group_enable[pg] & local_winner[pg*GB+pj];
            if (pg*GB+pj<WIDTH) begin : real_output
                if (pg==0 && pj==0) begin : empty_input_default
                    assign output_unencoded[0] = group_enable[0] & ~(|padded[GB-1:1]);
                end else begin : ordinary
                    assign output_unencoded[pg*GB+pj] = global_winner[pg*GB+pj];
                end
            end
        end
    end
    assign output_valid = |group_valid;
'''
    if spec['encoding']=='group_factored':
        body+='''    for (pb=0; pb<$clog2(WIDTH); pb=pb+1) begin : encoded_bits
        wire [GROUPS-1:0] terms;
        for (pe=0; pe<GROUPS; pe=pe+1) begin : group_terms
            if (pb<LOW_BITS) begin : local_index
                wire [GB-1:0] masked;
                for (pk=0; pk<GB; pk=pk+1) begin : mask_bits
                    assign masked[pk] = ((pk >> pb)&1) ? local_winner[pe*GB+pk] : 1'b0;
                end
                assign terms[pe] = group_enable[pe] & (|masked);
            end else begin : group_index
                assign terms[pe] = ((pe >> (pb-LOW_BITS))&1) ? group_winner[pe] : 1'b0;
            end
        end
        assign output_encoded[pb] = |terms;
    end
'''
    else:
        body+='''    for (pb=0; pb<$clog2(WIDTH); pb=pb+1) begin : encoded_bits
        wire [PAD-1:0] terms;
        for (pk=0; pk<PAD; pk=pk+1) begin : mask_bits
            assign terms[pk] = ((pk >> pb)&1) ? global_winner[pk] : 1'b0;
        end
        assign output_encoded[pb] = |terms;
    end
'''
    body+='end else begin : pw_original\n'+fallback+'\nend\nendgenerate\n'
    return source[:start]+body+source[end:]
