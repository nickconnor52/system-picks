const express = require('express');
const path = require('path');
const serveStatic = require('serve-static');
var history = require('connect-history-api-fallback');
const proxyMiddleware = require('http-proxy-middleware')

const config = require('./config')
if (!process.env.NODE_ENV) {
  process.env.NODE_ENV = JSON.parse(config.dev.env.NODE_ENV)
}

const proxyTable = config.dev.proxyTable


let app = express();
app.use(history());
app.use(serveStatic(__dirname + "/dist"));

// proxy api requests
Object.keys(proxyTable).forEach(function (context) {
  let options = proxyTable[context]
  if (typeof options === 'string') {
    options = { target: options }
  }
  app.use(proxyMiddleware(options.filter || context, options))
})

const port = process.env.PORT || 5000;
app.listen(port, () => {
  console.log('Listening on port ' + port)
});
