#!/usr/bin/python
import hashlib

flag = 'CTF-BR{naVcO_you_found_it_PQZ0a}'
key = 'f21'

h = hashlib.sha256('return Future was not finished'+key).digest()
assert len(flag) == len(h)
print(', '.join('0x%02x' % (ord(a)^ord(b)) for a,b in zip(flag,h)))
