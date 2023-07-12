#!/usr/bin/env python

import sys

program_name = sys.argv[0]
hex = ''.join(sys.argv[1:]).lstrip('#')

hex_1 = str(tuple(int(hex[i:i+2],16) for i in (0, 2 ,4,)))
hex_1 = hex_1[0:-1] + ', 0.9)'
print('rgba'+hex_1)
