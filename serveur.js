const http = require('http');

const port = 3000;
const host = '127.0.0.1';

const server = http.createServer((req, res) => {
    res.writeHead(200, { 'Content-Type': 'text/plain; charset=utf-8' });
    res.end('Serveur en cours d\'exécution sur localhost:3000\n');
});

server.listen(port, host, () => {
    console.log(`Serveur démarré sur http://${host}:${port}`);
});