#!/usr/bin/pypy
from __future__ import print_function, division
import numpy as np
import hmac
import hashlib

flag = 'CTF-BR{GNDYd8ySt3_congrats_7qA7TuWBlK}'
key = 'rA0InNdaDJR65H28IBr6yqVHVaJi4lYF'
duration = 72*3600

def hmacSha256(k, msg):
    return hmac.new(k, msg, hashlib.sha256).digest()

def main():
    instants = np.sort(np.random.randint(low=0, high=duration, size=len(flag)))
    instants = np.concatenate(([0], instants, [duration]))
    flagc = [None] + map(ord, flag) + [None]
    k = key
    for i, (inst, c) in enumerate(zip(instants, flagc)):
        if c is None:
            continue
        low  = instants[i-1] + 1
        high = instants[i+1]
        while True:
            k_candidate = hmacSha256(k, str(inst))
            if c == ord(k_candidate[-1]) & 0x7F:
                instants[i] = inst
                k = k_candidate
                break
            inst = np.random.randint(low=low, high=high)
    print(repr(instants[1:-1]))

if __name__ == '__main__':
    main()