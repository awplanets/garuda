import { createServer } from 'node:http';
import { extname, join, normalize, resolve, sep } from 'node:path';
import { readFile } from 'node:fs/promises';

const root = resolve(process.argv[2] || '.');
const port = Number(process.env.PORT || 4188);
const types = {
  '.html': 'text/html; charset=utf-8',
  '.css': 'text/css; charset=utf-8',
  '.js': 'text/javascript; charset=utf-8',
  '.json': 'application/json; charset=utf-8',
  '.jpg': 'image/jpeg',
  '.jpeg': 'image/jpeg',
  '.gif': 'image/gif',
  '.mp3': 'audio/mpeg',
  '.wav': 'audio/wav',
  '.png': 'image/png',
  '.mp4': 'video/mp4',
  '.webp': 'image/webp',
};

createServer(async (req, res) => {
  try {
    const url = new URL(req.url || '/', `http://${req.headers.host || '127.0.0.1'}`);
    const pathname = decodeURIComponent(url.pathname === '/' ? '/index.html' : url.pathname);
    const relativePath = normalize(pathname.replace(/^[/\\]+/, ''));
    const file = resolve(join(root, relativePath));

    if (file !== root && !file.startsWith(root + sep)) {
      res.writeHead(403);
      res.end('Forbidden');
      return;
    }

    const body = await readFile(file);
    res.writeHead(200, {
      'Content-Type': types[extname(file)] || 'application/octet-stream',
      'Cache-Control': 'no-store',
    });
    res.end(body);
  } catch {
    res.writeHead(404);
    res.end('Not found');
  }
}).listen(port, '127.0.0.1', () => {
  console.log(`Garuda: http://127.0.0.1:${port}/`);
});
