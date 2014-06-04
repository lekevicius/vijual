require('coffee-script/register');
fs = require('fs');

module.exports.socket = require('./server/server');

libraryPath = __dirname + '/../library'

var staticServer = require('node-static');
var files = new staticServer.Server('./public');
module.exports.fileServer = require('http').createServer(function (req, res) {
  req.addListener('end', function() {
    var requestedURL = req.url;
    var libraryFile = requestedURL.substring(8);
    if ((requestedURL.substring(0,8) === '/library') && (fs.existsSync(libraryPath + libraryFile))) {
      files.serveFile('../../library/' + libraryFile, 200, {}, req, res);
      console.log(libraryPath + libraryFile);
    }
    else {
      files.serve(req, res);
    }
  }).resume()
}).listen(9494);
console.log("Node server running");
