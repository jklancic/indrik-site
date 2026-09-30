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

Deployment is a plain Nginx server on a VPS serving `public/`. There is no
Docker: the site is static, so a container would add nothing.

### Option 1: `git pull` on the server (default)

```shell
ssh <deploy-user>@<vps> 'git -C /var/www/indrik-site pull --ff-only'
```

### Option 2: copy script

`deploy/copy-site.sh` copies `public/` into a target directory:

```shell
deploy/copy-site.sh /var/www/indrik-site/public
deploy/copy-site.sh user@vps:/var/www/indrik-site/public   # remote, needs rsync
deploy/copy-site.sh ./out --delete                         # also remove stale files in the target
```

- With rsync, dotfiles (`.git`, `.env`, ...) are excluded, and `--delete` and
  remote targets work. Without rsync, the script falls back to `cp` and
  supports local targets only.
- It copies whatever is on disk, including uncommitted changes, so the result
  can differ from what is in git.

### One-time server setup

1. Point the DNS `A`/`AAAA` records at the VPS. Certbot needs this first.
2. Clone the repo to `/var/www/indrik-site`, and make sure `www-data` can read
   `public/`.
3. Install the security headers snippet:
   ```shell
   sudo cp deploy/nginx/indrik-security-headers.conf /etc/nginx/snippets/
   ```
4. Install the site config:
   ```shell
   sudo cp deploy/nginx/indrik.eu.conf /etc/nginx/sites-available/indrik.eu
   sudo ln -s /etc/nginx/sites-available/indrik.eu /etc/nginx/sites-enabled/
   ```
5. Get one certificate for all four hostnames. `nginx -t` fails until this is
   done, because the config has no certificate lines yet:
   ```shell
   sudo certbot --nginx -d indrik.eu -d www.indrik.eu -d indrik.site -d www.indrik.site
   ```
   Certbot edits the copy on the server. Copy the `ssl_certificate` lines back
   into `deploy/nginx/indrik.eu.conf` if you want the versioned file to match.
6. Test and reload:
   ```shell
   sudo nginx -t && sudo systemctl reload nginx
   ```
7. Run the checks in `docs/spec.md` §11, then enable HSTS.

`http2 on;` needs Nginx 1.25.1 or newer. On older versions use
`listen 443 ssl http2;`.

See `docs/spec.md` §9 for the full details.
