# NixOS Server Config
NixOS config to provision a personal server.

## Services
- Wireguard Proxy
- Adguard (`dns.himmelsbach.dev`)
- Kavita (`read.himmelsbach.dev`)
- Navidrome (`music.himmelsbach.dev`)
- Searx (`search.himmelsbach.dev`)
- Calibre
- Firefly 3 (`firefly.himmelsbach.dev`)
- FreshRSS (`freshrss.himmelsbach.dev`)
- Paperless (`paperless.himmelsbach.dev`)
- Jellyfin (`watch.himmelsbach.dev`)
- SABnzbd (`sabnzbd.himmelsbach.dev`)
- Audiobookshelf (`listen.himmelsbach.dev`)

## Setup

### Secrets
- If a new system is being provisioned, append its SSH key in `secrets/secrets.nix` and add it to all managed secrets
  - Regenerate secrets:
```bash
nix run github:ryantm/agenix -- -e coturn-static-auth-secret.age hetzner-api-key.age hetzner-s3-secret.age kavita-token-key.age searx-environment.age wireguard-private-key.age firefly-iii-app-key.age
```

### Migrating data
- Nearly all application data is stored in `/var/lib` and can be synced to the new system
- For some services, a manual DB backup has to be restored. All relevant DBs are defined in the config

## Plans
- Dashboard
- Fossil VCS
- Firefox Sync Server
- Personal Website
- Backups

## Considerations
The second level domain is currently hardcoded to `himmelsbach.dev` for all services.
Certificates are generated using the Hetzner API.
