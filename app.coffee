express = require "express"
http    = require "http"
stitch  = require "stitch"
coffee  = require "coffee-script"
argv    = process.argv.slice(2)

clientPkg = stitch.createPackage(
  paths: [
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
    res.end()

port = argv[0] or process.env.PORT or 4040
console.log "Starting server on port: #{port}"
app.listen port