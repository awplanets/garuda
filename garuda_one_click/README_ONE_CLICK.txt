GARUDA one-click package
GARUDA 一键启动包

Windows:
1. Double-click START_GARUDA.bat.
2. The browser opens automatically.
3. Keep the command window open while playing. Close it to stop the local server.

macOS:
1. Prefer double-clicking Garuda.app.
2. If Garuda.app is blocked, double-click START_GARUDA_MAC.command.
3. The browser opens automatically.
4. Keep the Terminal window open while playing. Close it to stop the local server.
5. If macOS says the command file has no permission, run this once in Terminal inside this folder:
   chmod +x START_GARUDA_MAC.command
   chmod +x Garuda.app/Contents/MacOS/Garuda

Included files:
- index.html
- garuda.js
- jsfxr.js
- server.mjs
- start_server.py
- Garuda.app
- full assets folder

The launcher starts a local server so images, WebP animation frames, videos, BGM, and sound effects load from this folder without missing resources.

If you want a completely dependency-free macOS app, build a separate native macOS package. This folder is a lightweight cross-platform package and uses Node.js or Python 3 on macOS.
