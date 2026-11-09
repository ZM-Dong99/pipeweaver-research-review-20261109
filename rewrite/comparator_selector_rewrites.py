"""One guarded output-selector factoring action; not in the old six-action pool."""
import hashlib
from rewrite.comparator_rewrites import CANONICAL_TEXT_SHA256

def factor_selector(source):
    source=source.replace('\r\n','\n')
    if hashlib.sha256(source.encode('utf-8')).hexdigest()!=CANONICAL_TEXT_SHA256:
        raise ValueError('Canonical unsigned comparator source required')
    start=source.index('always @(*) begin');end=source.index('\nendmodule',start)
    # E and G are comparison results for arbitrary defined unsigned operands,
    # so E & G == 0 follows from their definitions; no external assumption.
    # Preserve SEL's eight defined binary cases via shared Boolean expressions.
    replacement='''// Guarded factoring of output selection; no change to comparisons or ports.
always @* begin
    OUT = SEL[2] ? (SEL[1] ^ (cmp_equal | (cmp_greater ^ SEL[0])))
                 : (SEL[0] ^ (SEL[1] & cmp_equal));
end
'''
    return source[:start]+replacement+source[end:]
