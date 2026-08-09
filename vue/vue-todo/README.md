# vue-todo

A tiny todo list app made in Vue :), backed by a tiny Python server.

Setup:

```
nix develop
pnpm i
```

Run the backend (in-memory todo store, listens on `http://127.0.0.1:8000`):

```
cd server
python3 -m todo_server
```

Then, in another terminal, run the frontend. The Vite dev server proxies
`/api/*` requests to the backend, so no CORS setup is needed.

Actions:

- `pnpm dev`
- `pnpm check`
- `pnpm fmt`
- `pnpm lint`
