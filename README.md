# indrik-site

Website of Indrik, an independent software studio, with PowerLog as its first
product. Plain HTML and CSS, no build step, no JavaScript. The full
specification is in [docs/spec.md](docs/spec.md).

## Run locally

```shell
python -m http.server --directory public 8000
```

Then open <http://localhost:8000/>.

## Layout

- `public/` is the web root. Only this folder is served.
- `public/assets/` holds the shared stylesheet, logo mark and icons.
- `public/powerlog/` is the PowerLog landing page and privacy policy, with
  their own styles.
- `deploy/nginx/` holds the versioned Nginx config and security headers.

The header and footer are copied into each company page. When you change the
nav or footer, update every page (see the checks in `docs/spec.md` §11).

## Deploy

```shell
ssh <deploy-user>@<vps> 'git -C /var/www/indrik-site pull --ff-only'
```

See `docs/spec.md` §9 for the one-time server setup.
