"""Verify that filler insertion changed no original placement or signal routes."""
import csv
import json
from pathlib import Path
import re
from fill_fcs_layout import ROOT, SOURCE, OUT, sha, save


def section(text,name):
    match=re.search(r'(?ms)^'+name+r'\s+\d+\s*;\s*\n(.*?)^END '+name+r'\s*$',text)
    if not match:
        raise ValueError('Missing DEF section '+name)
    entries={}
    for m in re.finditer(r'(?ms)^\s*-\s+(\S+)(.*?);',match[1]):
        entries[m[1]]=' '.join(m[2].split())
    return entries


def main():
    results={}
    for case in ('baseline','optimized'):
        old=(SOURCE/case/'detailed.def').read_text()
        new=(OUT/case/'detailed.def').read_text()
        a,b=section(old,'COMPONENTS'),section(new,'COMPONENTS')
        added=set(b)-set(a)
        allowed={'sky130_fd_sc_hd__fill_'+str(i) for i in (8,4,2,1)}
        checks=dict(all_original_placements_preserved=set(a)<=set(b) and all(a[n]==b[n] for n in a),
            only_allowed_filler_instances_added=bool(added) and all(b[n].split()[0] in allowed for n in added),
            all_signal_connections_and_route_geometry_identical=section(old,'NETS')==section(new,'NETS'),
            all_top_pin_shapes_and_labels_identical=section(old,'PINS')==section(new,'PINS'))
        with (OUT/case/'physical_cells.tsv').open() as f:
            rows=list(csv.DictReader(f,delimiter='\t'))
        total=sum(float(r['area_um2']) for r in rows)
        filler=sum(float(r['area_um2']) for r in rows if r['master'] in allowed)
        results[case]=dict(passed=all(checks.values()),checks=checks,original_instances=len(a),added_fillers=len(added),
            total_occupied_cell_area_um2=round(total,4),filler_cell_area_um2=round(filler,4),
            nonfiller_cell_area_um2=round(total-filler,4),source_def_sha256=sha(SOURCE/case/'detailed.def'),
            filled_def_sha256=sha(OUT/case/'detailed.def'))
        print(case+' filler preservation '+str(results[case]['passed']),flush=True)
    save(OUT/'PRESERVATION.json',dict(passed=all(r['passed'] for r in results.values()),cases=results,
         scope='Exact original component placement, signal-net connections and route polygons, and top pin DEF entries preserved; newly added objects limited to supply-only fillers',new_model_calls=0))


if __name__=='__main__':
    main()
