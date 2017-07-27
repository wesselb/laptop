from __future__ import absolute_import, print_function, division

from core import Parser

with open('config') as f:
    lines = f.read().splitlines()

parser = Parser(lines)
parser.run()



