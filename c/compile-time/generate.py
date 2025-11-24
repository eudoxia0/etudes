#!/usr/bin/env python3
import sys

N: int = int(sys.argv[1])

code: str = ""

for i in range(N):
    code += "\n"
    code += f"void foo_{i}() {{\n"
    code += "    return;\n"
    code += "}\n"

code += "\n"
code += "int main() {\n"
code += "    return 0;\n"
code += "}\n"

print(code)
