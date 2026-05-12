Garuda
======

A fullscreen vertical arcade shooter built as a 9:16 browser game.

Controls:

- Arrow keys, WASD, or IJKL to move.
- Space, X, C, Z, Y, or 0 to fire.
- Q to activate shield.
- E to release bomb.
- R to trigger Killer when charged.
- P or Esc to pause.
- F to toggle fullscreen.

Run locally:

```bash
npm run dev
```

Run as a desktop app:

```bash
npm run app
```

Package desktop builds:

```bash
npm run dist:mac
npm run dist:win
```

Create the static web release for GitHub Pages or any CDN/static host:

```bash
npm run web:release
```

The web release is written to `../garuda_web_release`. It keeps the same visual
result while excluding desktop-only build output and unused source videos.
Online builds register a Service Worker so repeat visits reuse cached assets.

The player-facing macOS build must be made on macOS with Developer ID signing
and Apple notarization enabled. See `MAC_RELEASE.md`.

Build check:

```bash
npm run build
```

The game uses `jsfxr.js` for generated sound effects and local assets from the
`assets` directory.
