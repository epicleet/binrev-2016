import asynchttpserver, asyncdispatch
import nimSHA2
import strtabs
import strutils
import re

var serverPort = [0x1d, 0xe6, 0x82, 0x75, 0xde, 0xd9, 0x4c, 0x3d,
                  0x01, 0xf0, 0xc7, 0xce, 0x42, 0x7f, 0x70, 0x7e,
                  0x2a, 0x1a, 0x3a, 0x92, 0x36, 0x27, 0x71, 0xa4,
                  0x3f, 0x9a, 0x93, 0x8c, 0x5d, 0xe5, 0xe9, 0x90 ]
var server = newAsyncHttpServer()
proc cb(req: Request) {.async.} =
        var headers : StringTableRef = nil
        const hdr = "Return"
        if hasKey(req.headers, hdr):
                var val = req.headers[hdr].toLower[0..2]
                if val.allCharsInSet(HexDigits):
                        val = "return Future was not finished" & val
                        var h = computeSHA256(val)
                        var s = ""
                        for i in 0..31:
                                s.add chr(ord(h[i]) xor serverPort[i])
                        headers = newStringTable((hdr, s))
        await req.respond(Http403, "Access Denied", headers)
waitFor server.serve(Port(8080), cb)
