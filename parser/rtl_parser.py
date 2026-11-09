from pyverilog.vparser.parser import parse

ast, directives = parse([
    r"D:\verilog_lab\PipeWeaver\benchmark\adder.v"
])

print("Parse Success!")
ast.show()