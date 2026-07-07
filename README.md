# devImages

Docker images used for local development and CI.

Overview
- Purpose: provide ready-to-build Docker images for various dev tools and services.
- Layout: the `images/` directory contains a subfolder per image:
	- `buf-build/` — Dockerfile + `tag`
	- `dev/` — Dockerfile, `entrypoint.sh`, `tag`
	- `protoc-go/` — Dockerfile + `tag`
	- `remote-util/` — Dockerfile + `tag`
	- `twingate-client/` — Dockerfile + `tag`

Quick start
- Build a single image (from its folder):

```bash
cd images/dev
docker build -t dev:$(cat tag) .
```

- Build all images in `images/` (from repository root):

```bash
for d in images/*/; do 
	tag=$(cat "$d/tag" 2>/dev/null || echo latest)
	name=$(basename "$d")
	docker build -t "$name:$tag" "$d"
done
```

Notes
- Each image folder includes a `tag` file with the recommended image tag.
- Adjust the `docker build -t` name to include your registry (e.g. `ghcr.io/OWNER/IMAGE:TAG`).

Contributing
- Open an issue or PR to add or update images.

License
- See repository LICENSE if provided.

