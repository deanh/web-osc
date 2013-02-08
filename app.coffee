express = require "express"
http    = require "http"
stitch  = require "stitch"
coffee  = require "coffee-script"
argv    = process.argv.slice(2)

osc     = require 'osc-min'
dgram   = require "dgram"

udp = dgram.createSocket "udp4"

port    = argv[0] or process.env.PORT    or 4040
outport = argv[1] or process.env.OUTPORT or 8000

clientPkg = stitch.createPackage(
  paths: [
    __dirname + "/src/shared",
    __dirname + "/src/client",
    __dirname + "/node_modules/underscore"
  ]
  dependencies: []
)

app = express()

cnt = 0

app.configure ->
  app.use express.static(__dirname + "/public")
  app.get "/web-osc.js", clientPkg.createServer()
  app.get "/osc", (req, res) ->
    console.dir req.query
    for k, v of req.query
      sendOSCMessage k, v
    res.end()

sendOSCMessage = (address, arg) ->
  buf = osc.toBuffer
    address: "/#{address}"
    args: [arg]

  udp.send buf, 0, buf.length, outport, "localhost"

console.log "Starting server on port: #{port}"
app.listen port