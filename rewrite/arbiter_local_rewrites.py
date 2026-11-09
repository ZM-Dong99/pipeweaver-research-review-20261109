"""Guarded development templates for one canonical arbiter; not a general RTL parser."""

MSB_MASKED="mask_next = {PORTS{1'b1}} >> (PORTS - masked_request_index);"
MSB_DIRECT="mask_next = {PORTS{1'b1}} >> (PORTS - request_index);"
RESET_OLD='''    grant_reg <= grant_next;
    grant_valid_reg <= grant_valid_next;
    grant_encoded_reg <= grant_encoded_next;
    mask_reg <= mask_next;

    if (rst) begin
        grant_reg <= 0;
        grant_valid_reg <= 0;
        grant_encoded_reg <= 0;
        mask_reg <= 0;
    end'''
RESET_NEW='''    grant_reg <= rst ? 0 : grant_next;
    grant_valid_reg <= rst ? 0 : grant_valid_next;
    grant_encoded_reg <= rst ? 0 : grant_encoded_next;
    mask_reg <= rst ? 0 : mask_next;'''

def replace_once(source,old,new):
    if source.count(old)!=1:raise ValueError('Template precondition failed; refusing an ambiguous rewrite')
    return source.replace(old,new,1)

def reset_mux(source):return replace_once(source,RESET_OLD,RESET_NEW)

def mask_rewrite(source,kind):
    if kind=='onehot_subtract':
        masked="mask_next = masked_request_mask - 1'b1;"
        direct="mask_next = request_mask - 1'b1;"
    elif kind in ('onehot_prefix','request_prefix'):
        direct_input='request_mask' if kind=='onehot_prefix' else 'request'
        masked_input='masked_request_mask' if kind=='onehot_prefix' else '(request & mask_reg)'
        wires=f'''wire [PORTS-1:0] pw_local_direct_bits = {direct_input};
wire [PORTS-1:0] pw_local_masked_bits = {masked_input};
wire [PORTS-1:0] pw_local_direct_mask;
wire [PORTS-1:0] pw_local_masked_mask;
genvar pw_local_bit;
generate
    for (pw_local_bit = 0; pw_local_bit < PORTS; pw_local_bit = pw_local_bit + 1) begin : pw_local_prefix
        if (pw_local_bit == PORTS-1) begin : upper_bit
            assign pw_local_direct_mask[pw_local_bit] = 1'b0;
            assign pw_local_masked_mask[pw_local_bit] = 1'b0;
        end else begin : remaining_bits
            assign pw_local_direct_mask[pw_local_bit] = |pw_local_direct_bits[PORTS-1:pw_local_bit+1];
            assign pw_local_masked_mask[pw_local_bit] = |pw_local_masked_bits[PORTS-1:pw_local_bit+1];
        end
    end
endgenerate

'''
        source=replace_once(source,'always @* begin',wires+'always @* begin')
        masked='mask_next = pw_local_masked_mask;'
        direct='mask_next = pw_local_direct_mask;'
    else:raise ValueError('Unknown allowed rewrite')
    source=replace_once(source,MSB_MASKED,masked)
    return replace_once(source,MSB_DIRECT,direct)

def candidates(source):
    result=[]
    for kind in ('onehot_subtract','onehot_prefix','request_prefix'):
        rewritten=mask_rewrite(source,kind)
        for reset in (False,True):
            result.append(dict(id=kind+('_reset_mux' if reset else ''),mask_operator=kind,reset_operator=reset,
                rtl=reset_mux(rewritten) if reset else rewritten))
    return result

def control_candidates(source):
    """Reachable-state identities; original/unchanged reset-only cases excluded."""
    result=[]
    for valid,ack,name in [(True,False,'valid_from_grant'),(False,True,'ack_from_index'),(True,True,'valid_and_ack')]:
        rewritten=source
        if valid:rewritten=replace_once(rewritten,'assign grant_valid = grant_valid_reg;','assign grant_valid = |grant_reg;')
        if ack:rewritten=replace_once(rewritten,'grant_valid && !(grant_reg & acknowledge)','grant_valid && !acknowledge[grant_encoded_reg]')
        for reset in (False,True):
            result.append(dict(id=name+('_reset_mux' if reset else ''),valid_from_grant=valid,ack_from_index=ack,reset_operator=reset,
                rtl=reset_mux(rewritten) if reset else rewritten))
    return result
