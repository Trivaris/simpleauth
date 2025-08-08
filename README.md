# simpleauth

A minimal [SvelteKit](https://kit.svelte.dev/) application using the **Node adapter**, packaged with [Nix](https://nixos.org/) for fully reproducible builds.

This project uses:

- **Node.js 20** (via Nix)
- **npm** for dependency management
- **SvelteKit + adapter-node** for server-side rendering
- A `flake.nix` that provides:
  - a development shell (`nix develop`) with Node, npm, Prettier, and TypeScript LSP
  - a fully nixified build (`nix build`) that runs without network access
  - a runnable app (`nix run`) that launches the Node server

<br>
<br>

## 📦 Project Structure

```
.
├── app/               # SvelteKit project root
│   ├── package.json   # npm dependencies
│   ├── package-lock.json
│   ├── svelte.config.js
│   ├── src/           # Routes, components, and server logic
│   └── ...            # Other app files
├── default.nix        # Nix derivation that builds the app
├── flake.nix          # Nix flake with dev shell, build, and run targets
└── README.md

```

<br>
<br>


## 🔨 Building

Build the app with all dependencies fetched by Nix (no `node_modules` or `npm install` at build time):

```bash
nix build
```

* The build output is stored in the Nix store and symlinked to `./result/`.
* The output contains the `adapter-node` build: `index.js`, `handler.js`, `server/`, etc.

<br>
<br>


## 🚀 Running the built app

To run the server from the build output:

```bash
nix run .
```

Environment variables:

* `HOST` – Bind address (default: `0.0.0.0`)
* `PORT` – Port to listen on (default: `3000`)
* `NODE_ENV` – Should be `production` in production environments

Example:

```bash
PORT=8080 HOST=127.0.0.1 nix run .
```

<br>
<br>


## 📋 Notes

* You do **not** need Node/npm installed globally — the `nix develop` shell provides them.
* To update dependencies, edit `app/package.json` and run:

  ```bash
  npm --prefix app install
  ```

  Then commit the updated `package-lock.json`.