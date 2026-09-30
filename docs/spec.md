# Indrik website — specification

Status: draft · 2026-09-30

This document describes what needs to be built to turn the current PowerLog
landing page (this folder) into the website of **Indrik**, an independent
software studio, with PowerLog as one of its product sections. It is the
single reference for building, hosting, and launching the site. Anything not
yet decided is listed in [Open questions](#12-open-questions) rather than
assumed.

---

## 1. Goals

1. Give Indrik a simple, credible home on the web that presents its products.
2. Host the PowerLog landing page and privacy policy at their **final**
   URLs before the store listings are submitted, so these URLs never change.
3. Mention Platypus (a separate venture) accurately, without suggesting that
   Indrik owns it.
4. Link to the personal brand at `https://klancic.me` (and back from it).
5. Keep it cheap to maintain: plain HTML, no build step, no JavaScript
   required, nothing that goes stale.

## 2. Decisions

| Topic | Decision |
|---|---|
| Primary domain | `indrik.eu` |
| Secondary domains | `indrik.site` → 301 redirect to `indrik.eu` |
| Positioning | Product studio: builds and sells its own apps |
| Language | English only (`<html lang="en">`) |
| Technology | Static HTML + CSS, no build step, no framework |
| Company look | Minimal monochrome plus the logo's red accent, separate from PowerLog |
| PowerLog look | Unchanged: existing Material 3 green theme |
| PowerLog location | Path-based: `indrik.eu/powerlog/` |
| Platypus | Separate venture; short overview page on Indrik linking out |
| Your role in Platypus | Co-founder & CTO |
| News | No news section or carousel; status badges on product cards only |
| Company pages | Home, About, Contact, Legal notice, Platypus, 404 |
| Contact | Personal Gmail (`jernej.klancic@gmail.com`) for now |
| Legal notice (pre-registration) | Name + country only |
| Analytics | None: no cookies, no tracking, no consent banner |
| Repository | New repo (working name `indrik-site`) |
| Hosting | Own VPS running Nginx |
| Deployment | `git pull` on the server |

### Why no news carousel

News comes rarely, so a dated news item quickly makes the site look
abandoned. Carousels also get little engagement after the first slide and
cause accessibility problems (auto-rotation, focus handling). Instead, each
product card carries a **status badge** (e.g. *Coming soon*, *Beta*,
*Available on Google Play*). Badges are undated and change only when the
product's status changes, so they cannot go stale.

## 3. URLs and redirects

### Site map

| URL | Page | Look |
|---|---|---|
| `https://indrik.eu/` | Home | Indrik |
| `https://indrik.eu/about/` | About | Indrik |
| `https://indrik.eu/contact/` | Contact | Indrik |
| `https://indrik.eu/legal/` | Legal notice | Indrik |
| `https://indrik.eu/platypus/` | Platypus overview | Indrik |
| `https://indrik.eu/powerlog/` | PowerLog landing page | PowerLog |
| `https://indrik.eu/powerlog/privacy/` | PowerLog privacy policy | PowerLog |
| any unknown path | 404 page | Indrik |

Every page is a directory with an `index.html`, so URLs are clean and end in
`/`. Nginx automatically redirects `/powerlog/privacy` to
`/powerlog/privacy/`.

**The privacy policy URL submitted to Google Play and App Store Connect is
`https://indrik.eu/powerlog/privacy/`.** It must not change after
submission.

### Redirects (all 301, single hop)

| From | To |
|---|---|
| `http://` any hostname below | `https://indrik.eu` + same path |
| `https://www.indrik.eu/*` | `https://indrik.eu/*` |
| `https://indrik.site/*`, `https://www.indrik.site/*` | `https://indrik.eu/*` |

## 4. Repository layout

The repo contains a `public/` folder, and **only `public/` is the web root.**
This matters because deployment is done with `git pull`: if the repo root
were served, the `.git` folder would be downloadable.

```
indrik-site/
  README.md                     # how to run locally and deploy
  docs/
    spec.md                     # this document, moved here
  deploy/
    nginx/indrik.eu.conf        # versioned copy of the server config
  public/                       # ← Nginx web root
    index.html                  # Home
    404.html
    robots.txt
    sitemap.xml
    favicon.svg                 # Indrik monogram
    assets/
      indrik.css                # shared styles for company pages
    about/index.html
    contact/index.html
    legal/index.html
    platypus/index.html
    powerlog/
      index.html                # from marketing-site/index.html
      privacy/index.html        # from marketing-site/privacy.html
```

- Company pages share `assets/indrik.css`. The PowerLog pages keep their
  inline styles as they are, which keeps the two looks separate.
- The header and footer are copied into each company page (there is no
  templating). With five pages that's manageable; when you change the nav or
  footer, update every page (see the checklist in §11).
- Local preview: `python -m http.server --directory public 8000`.

## 5. Company pages: content

The copy below is a draft to edit, not final text. The site should describe
Indrik in the third person ("Indrik builds…"), which works for a one-person
studio without choosing between "I" and "we".

### 5.1 Shared header and footer (all Indrik pages)

- **Header:** the text wordmark "Indrik" (links to `/`), plus nav links:
  Products (`/#products`), About, Contact. On narrow screens the links stay
  inline (only three short links, so no hamburger menu is needed).
- **Footer:**
  - Contact email (`mailto:` link)
  - Legal notice (`/legal/`)
  - `klancic.me` (external link)
  - `© 2026 Indrik` (the copyright holder is an [open question](#12-open-questions))

### 5.2 Home (`/`)

1. **Hero**
   - H1: *Independent software studio from Slovenia.*
   - Lead: *Indrik builds focused, privacy-respecting apps.*
   - No buttons needed; the products follow directly below.
2. **Products** (`id="products"`)
   - A card per Indrik product. For now there's only PowerLog:
     - PowerLog app icon (in its own colours; product icons are the one
       exception to the monochrome rule)
     - Name: **PowerLog**
     - One-liner: *Offline-first fitness tracker for workouts, nutrition,
       sleep and body measurements.*
     - Status badge: **Coming soon**
     - Link: *Learn more →* `/powerlog/`
3. **Also building** (a separate section, visually secondary to Products)
   - Platypus card:
     - Name: **Platypus**
     - One-liner: *Product development and lifecycle management for
       healthcare and life sciences teams.*
     - Relationship line: *A separate venture. Indrik founder Jernej Klančič
       is co-founder & CTO.*
     - Status badge: (open question)
     - Link: *Learn more →* `/platypus/`
4. Footer.

### 5.3 About (`/about/`)

A short page: two to three sentences about the studio, plus a link to the
personal site. No biography.

> Indrik is an independent software studio from Slovenia, founded by Jernej
> Klančič. It builds small, focused apps that respect their users' time and
> data. PowerLog is its first product.
>
> More about Jernej: [klancic.me](https://klancic.me)

### 5.4 Contact (`/contact/`)

- Email address as a `mailto:` link, displayed in plain text.
- Short routing hint:
  - PowerLog support and general enquiries → the email above.
  - Platypus enquiries → link to `https://platypus-labs.net/landing`.
- No contact form (it would need a third-party service or server code, and
  would add a data processor to the privacy notice).

### 5.5 Legal notice (`/legal/`)

The version to use until the company is registered:

> **Legal notice**
>
> Indrik is a brand name used by Jernej Klančič, Slovenia. Indrik is not yet
> a registered company. Company details (registered name, address,
> registration number and VAT ID) will be published here once it is
> registered.
>
> Contact: jernej.klancic@gmail.com
>
> **Privacy on this website**
>
> This website uses no cookies, no analytics and no third-party services.
> The web server keeps standard access logs (IP address, date, requested
> page, browser) for security and troubleshooting, and deletes them after
> *N* days. Each app has its own privacy policy, e.g. the
> [PowerLog privacy policy](/powerlog/privacy/).

- Nowhere on the site may Indrik be presented as a legal entity (no
  "d.o.o.", "s.p.", or registration numbers) until it is registered.
- After registration, replace the first paragraph with the full company
  details required by Slovenian/EU e-commerce law, and review the copyright
  lines.

### 5.6 Platypus (`/platypus/`)

A one-screen overview that links out. It shouldn't reproduce the full
landing page, so there aren't two copies to keep in sync.

1. H1: **Platypus**
2. Relationship note (directly under the H1): *Platypus is a separate venture
   co-founded by Jernej Klančič, who serves as its CTO.*
3. Description (from the Platypus landing page):
   > Platypus is an integrated product development and lifecycle management
   > tool for healthcare and life sciences teams across the pharmaceutical,
   > nutraceutical, food, and cosmetic industries.
4. **Who it's for:** pharmaceutical · nutraceutical · food · cosmetics.
5. **What it covers** (a compact list or chip row):
   raw material science · early-stage formulation development · regulatory
   and quality compliance · cost and pricing · manufacturing process
   development · documentation management · supply chain · commercial
   manufacturing.
6. Links:
   - Primary: *Visit Platypus →* `https://platypus-labs.net/landing`
   - Secondary: *Open the app →* `https://app.platypus-labs.net/` (whether
     to include it is an open question)
7. Footer.

External links open in the same tab. The page uses the Indrik look, not
Platypus branding (apart from its logo, if permission is given; see open
questions).

### 5.7 404 (`/404.html`)

Header, a short message ("This page doesn't exist."), links to Home and
PowerLog, and the footer. Served with HTTP status 404.

## 6. Indrik design (company pages only)

The look is minimal and monochrome, derived from the logo (charcoal, grey,
off-white) with **one accent: the logo's crimson red**. Typography and
whitespace do the work. Use the accent sparingly: links, focus rings, the
hover state, and nothing else. It is not used for large fills or body text.

### Design tokens (`assets/indrik.css`)

```css
:root {
  color-scheme: light dark;
  --bg: #f6f8f8;           /* logo's cool off-white */
  --surface: #ffffff;      /* cards */
  --text: #141c22;         /* logo charcoal (sampled from the wordmark) */
  --text-muted: #4f565c;   /* logo grey, ~7:1 on --bg */
  --border: #dde3e5;
  --accent: #982028;       /* logo horn red (sampled), ~7:1 on --bg */
  --accent-strong: #701018; /* logo horn shadow red: hover / pressed */
  --badge-bg: #141c22;
  --badge-text: #f6f8f8;
  --logo-plate: transparent;
}
@media (prefers-color-scheme: dark) {
  :root {
    --bg: #0f1418;
    --surface: #171e24;
    --text: #e8ecee;
    --text-muted: #a3acb2; /* ~7.5:1 on --bg */
    --border: #27313a;
    --accent: #e5535d;     /* lightened red for dark mode, ~5:1 on --bg */
    --accent-strong: #ff7a83;
    --badge-bg: #e8ecee;
    --badge-text: #0f1418;
    --logo-plate: #f6f8f8; /* light tile behind the logo mark, see Logo */
  }
}
```

The neutrals are tinted cool (blue-charcoal) rather than pure grey because
the logo's charcoal is `#141c22`, not `#111`. The logo's colours, sampled
from the artwork: charcoal `#141c22`, grey `#535459`, red `#982028`
(shadow `#701018`), off-white background `#f6f8f8`.

Verify the contrast values when implementing; the requirement is **at
least 4.5:1** for all text (a project-wide rule, also in `CLAUDE.md`).

### Typography and layout

- System font stack (same as PowerLog):
  `-apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial,
  sans-serif`. No web fonts, so there are no external requests (Google
  Fonts loaded from Google's servers would send visitor IPs to a third
  party).
- Content width: max 1080px (same as PowerLog), prose max ~68ch.
- Side padding: 20px; must work at 320px width with no horizontal scroll.
- H1 ~40px desktop / ~32px mobile, weight 800, tight letter-spacing, the
  same scale as PowerLog so the two feel related without looking the same.

### Components

- **Logo:** the unicorn mark, shown about 32-40px tall in the header next to
  the text "Indrik" (set in the heading weight). Use the mark only, without
  the "INDRIK / SOFTWARE STUDIO" lettering, which is unreadable at that size.
  The full lockup (mark plus lettering) can be used large on About.
  The mark is a transparent PNG: `assets/indrik-mark-96.png` (header),
  `indrik-mark-480.png` (About, large) and `indrik-mark.png` (full size).
  The mane and legs are near-black, so in dark mode they disappear into
  the page. Solution: in dark mode the mark sits on a light tile
  (`background: var(--logo-plate)`, ~8px padding, 10px radius). In light
  mode the plate is transparent. Do not create a recoloured dark variant
  of the logo.
  The lettering is not in the file. Set "Indrik" (and "Software Studio" on
  About) as live text next to the mark.
- **Favicon:** `favicon.svg`, a simple "I" monogram (the red-slashed "I"
  from the logo) with a `prefers-color-scheme` media query inside the SVG so
  it stays visible on light and dark browser tabs. The full unicorn does not
  read at 16px. Also provide `apple-touch-icon.png` (180 x 180). Both exist
  in `public/assets/`.
- **Product card:** `--surface` background, 16px radius, icon + name +
  one-liner + badge + link. The whole card is clickable (one `<a>` wrapping
  the content, or a stretched link), with a visible focus ring.
- **Status badge:** small pill (`--badge-bg` / `--badge-text`), text only.
  Allowed values: *Coming soon*, *Beta*, *Available*, *Available on
  Google Play*, *Available on the App Store*.
- **Links:** underlined in body text; nav links underline on hover/focus.

## 7. PowerLog pages: changes when moving them

The look and content stay as they are. Needed changes:

1. **Move files:** `marketing-site/index.html` → `public/powerlog/index.html`,
   `marketing-site/privacy.html` → `public/powerlog/privacy/index.html`.
2. **Fix links:**
   - Footer "Privacy Policy" → `/powerlog/privacy/`
   - Privacy page "← Back to PowerLog" → `/powerlog/`
3. **Link to Indrik:** add *"PowerLog is made by [Indrik](/)"* to the
   footer, above the copyright line. The header stays PowerLog-branded.
4. **Copyright line:** currently `© 2026 PowerLog`; update once the
   copyright holder is decided (open question).
5. **Favicon consistency:** the privacy page uses a different favicon
   (an inline SVG) from the landing page (a PNG data URI); use the same one
   on both.
6. **Carry over the open items** from `docs/before-launch-checklist.md`:
   - Replace the "Placeholder — replace…" line on the privacy page with
     "Last updated: <date>".
   - Replace the `href="#"` store links once the listings exist, and update
     the badges/fine print from "Coming soon".
   - Add an App Store icon (the badge's `<span>` is empty).
   - The checklist item about `support@powerlog.app` is out of date (the
     pages already use the Gmail address); update or close it.
   - The checklist suggests GitHub Pages for hosting the privacy policy;
     update it to point to `https://indrik.eu/powerlog/privacy/`.
7. When the PowerLog status changes, update **both** the PowerLog page and
   the badge on the Indrik home page.

## 8. Requirements for every page

- Valid HTML5 (check with the W3C validator), `lang="en"`, UTF-8,
  viewport meta.
- A unique `<title>` and `<meta name="description">` for each page, plus
  `<link rel="canonical">` with the `https://indrik.eu/...` URL.
- Basic Open Graph tags (`og:title`, `og:description`, `og:url`,
  `og:type`). Social preview images are out of scope for launch.
- No external requests: no CDNs, web fonts, analytics, embeds or
  third-party scripts. Everything is served from `indrik.eu`.
- No JavaScript required for anything to work.
- Accessibility: semantic landmarks (`header`, `nav`, `main`, `footer`),
  one H1 per page, logical heading order, visible focus styles, text
  contrast ≥ 4.5:1, works at 200% zoom and with larger text settings,
  decorative images/emoji marked `aria-hidden="true"`.
- Light and dark mode through `prefers-color-scheme` (no manual toggle).
- `robots.txt` allowing everything and pointing to `sitemap.xml`;
  `sitemap.xml` listing the URLs in §3.

## 9. Hosting: VPS with Nginx

### DNS (at Namecheap)

For `indrik.eu`, `www.indrik.eu`, `indrik.site`, `www.indrik.site`:

- `A` record → VPS IPv4
- `AAAA` record → VPS IPv6 (if the VPS has one)

No email is sent from these domains yet, so protect them against spoofing:

- `TXT @ "v=spf1 -all"`
- `TXT _dmarc "v=DMARC1; p=reject"`

Remove or relax these records when domain email is set up later.

### TLS

Certbot with the Nginx plugin, one certificate covering all four hostnames,
with automatic renewal (check with `certbot renew --dry-run`).

### Nginx config (sketch; versioned in `deploy/nginx/indrik.eu.conf`)

```nginx
# HTTP → HTTPS, canonical host
server {
    listen 80;
    listen [::]:80;
    server_name indrik.eu www.indrik.eu indrik.site www.indrik.site;
    return 301 https://indrik.eu$request_uri;
}

# Secondary hostnames → canonical host
server {
    listen 443 ssl;
    listen [::]:443 ssl;
    http2 on;
    server_name www.indrik.eu indrik.site www.indrik.site;
    # ssl_certificate / ssl_certificate_key managed by certbot
    return 301 https://indrik.eu$request_uri;
}

# Canonical site
server {
    listen 443 ssl;
    listen [::]:443 ssl;
    http2 on;
    server_name indrik.eu;
    # ssl_certificate / ssl_certificate_key managed by certbot

    root /var/www/indrik-site/public;
    index index.html;
    error_page 404 /404.html;

    # Defence in depth: never serve dotfiles (.git, .env, …)
    location ~ /\. { deny all; }

    location / {
        try_files $uri $uri/ =404;
    }

    location /assets/ {
        add_header Cache-Control "public, max-age=86400";
        include /etc/nginx/snippets/indrik-security-headers.conf;
    }

    add_header Cache-Control "no-cache";
    include /etc/nginx/snippets/indrik-security-headers.conf;
}
```

`indrik-security-headers.conf`:

```nginx
add_header X-Content-Type-Options "nosniff" always;
add_header Referrer-Policy "strict-origin-when-cross-origin" always;
add_header Content-Security-Policy "default-src 'self'; img-src 'self' data:; style-src 'self' 'unsafe-inline'; base-uri 'none'; form-action 'none'; frame-ancestors 'none'" always;
# Enable only after HTTPS works on every hostname:
# add_header Strict-Transport-Security "max-age=31536000" always;
```

Notes:

- `http2 on;` requires Nginx ≥ 1.25.1. On older versions use
  `listen 443 ssl http2;`.
- In Nginx, `add_header` inside a `location` replaces the server-level
  headers instead of adding to them, which is why the snippet is included in
  both places.
- The CSP allows inline styles and `data:` images because the PowerLog page
  uses inline `<style>` and data-URI icons.
- Access log retention should match what the legal notice says (*N* days,
  via `logrotate`).

### Deployment (`git pull`)

One-time setup on the VPS:

1. Create a non-root deploy user that owns `/var/www/indrik-site`.
2. Add a **read-only deploy key** for the repo to that user.
3. `git clone <repo> /var/www/indrik-site`
4. Make sure Nginx (`www-data`) can read `public/`.

To publish:

```shell
ssh <deploy-user>@<vps> 'git -C /var/www/indrik-site pull --ff-only'
```

No Nginx reload is needed for content changes. Reload only when the config
in `deploy/nginx/` changes (`sudo nginx -t && sudo systemctl reload nginx`).

## 10. Launch order

1. Register `indrik.eu` (it was free on 2026-09-30).
2. Create the `indrik-site` repo with the layout in §4; move the PowerLog
   files in and apply §7.
3. Build the company pages (§5, §6).
4. Set up the VPS: Nginx, deploy user, clone, config (§9).
5. Add DNS records at Namecheap for both domains; issue certificates.
6. Run the checks in §11.
7. Enable HSTS.
8. Enter `https://indrik.eu/powerlog/privacy/` in Google Play Console and
   App Store Connect.
9. Add a link to `https://indrik.eu` on `klancic.me`.
10. Delete `marketing-site/` from the power-log repo (or replace it with a
    pointer to the new repo), and update `docs/implementation-plan.md`
    Milestone 16 and `docs/before-launch-checklist.md`.

## 11. Checks before going live

- [ ] Every URL in §3 returns 200; an unknown path returns the 404 page with
      status 404.
- [ ] Every redirect in §3 is a single 301 hop to the right `https://indrik.eu`
      URL, and keeps the path.
- [ ] `https://indrik.eu/.git/HEAD` and `https://indrik.eu/.git/config` are
      **not** served.
- [ ] Headers from §9 are present (check with `curl -I`) on HTML and
      `/assets/` responses.
- [ ] Browser dev tools show no requests to other domains on any page.
- [ ] All pages look right in light and dark mode, at 320px, 768px and
      desktop widths, and at 200% zoom.
- [ ] Keyboard navigation reaches every link, with a visible focus ring.
- [ ] Header, footer and copyright are identical on all company pages.
- [ ] Status badges on Home match the product pages.
- [ ] No page calls Indrik a company, d.o.o. or s.p. before registration.
- [ ] W3C validator reports no errors.

## 12. Open questions

1. **Legal name spelling:** Jernej Klančič (with diacritics), or Klancic?
   Used on About, Legal notice and Platypus.
2. **Platypus: permission.** Are your co-founders OK with Platypus being
   featured on the Indrik site, with its description and (optionally) its
   logo?
3. **Platypus: status badge.** What is its current status (*Beta*,
   *Available*, invite-only, …)?
4. **Platypus: app link.** Should the page link directly to
   `app.platypus-labs.net`, or only to the landing page?
5. **Copyright holder** before registration: `© 2026 Indrik`,
   `© 2026 Jernej Klančič`, or keep `© 2026 PowerLog` on the PowerLog pages?
6. **Access log retention:** how many days (*N*) should the server keep
   access logs? It must match the legal notice.
7. **`indrik.si`:** register and redirect it too, or skip it?
8. **Name story:** mention on About that Indrik comes from the mythical
   Slavic creature (if that's the origin), or leave it out?
9. **Domain email:** when you move from Gmail to e.g. `hello@indrik.eu`,
   update the contact email on every page and in the PowerLog privacy
   policy, and change the SPF/DMARC records in §9.

## 13. Out of scope (for now)

- News/blog, newsletter, contact form
- Analytics, cookies, consent banner
- Additional languages
- Logo design beyond the text wordmark and monogram favicon
- Social preview images (`og:image`)
- A build step, templating or a static site generator
