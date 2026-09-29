'use strict';

const http = require('http');
const { greet, add } = require('./utils');

const PORT = process.env.PORT || 3000;

const server = http.createServer((req, res) => {
  if (req.url === '/health') {
    res.writeHead(200, { 'Content-Type': 'application/json' });
    res.end(JSON.stringify({ status: 'ok' }));
    return;
  }

  const name = req.url.slice(1) || 'world';
  res.writeHead(200, { 'Content-Type': 'text/plain' });
  res.end(greet(name));
});

if (require.main === module) {
  server.listen(PORT, () => {
    console.log(`Listening on http://localhost:${PORT}`);
  });
}

module.exports = { server };
