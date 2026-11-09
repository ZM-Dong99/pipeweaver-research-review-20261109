import sys
from pathlib import Path
from pyverilog.vparser.parser import parse
from pyverilog.ast_code_generator.codegen import ASTCodeGenerator

def walk(node, counts):
    counts[type(node).__name__] = counts.get(type(node).__name__, 0) + 1
    for child in node.children():
        walk(child, counts)

def main():
    if len(sys.argv) != 2:
        print("Usage: python parser/analyze_rtl.py <rtl.v>")
        raise SystemExit(1)
    p = Path(sys.argv[1])
    ast, _ = parse([str(p)])
    counts = {}
    walk(ast, counts)
    print("=== RTL AST SUMMARY ===")
    for k in sorted(counts):
        print(f"{k:25s} {counts[k]}")

if __name__ == "__main__":
    main()
