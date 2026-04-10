An overengineered media manager

```text
/opt/stacks
├── core/
│   ├── glances ................ Basically a view of bash's top
│   ├── gluetun ................ VPN client
│   ├── nginx-proxy ............ Reverse proxy
│   ├── ntfy ................... Push notifications
│   └── pihole ................. DNS and adblock
├── ctrl/
│   ├── autoheal ............... Restarts unhealthy containers
│   ├── dozzle ................. Aggregated log viewer
│   ├── komodo-core ............ Container manager
│   └── komodo-db .............. Container manager db
├── dash/
│   └── heimdall ............... Dashboard
├── node/
│   └── lenovo-thinkpad ........ Komodo agent
├── tdar/
│   ├── tdarr .................. Transcoder/remuxer
│   └── tdarr-node ............. Transcoder/remuxer node
├── view/
│   ├── jellyfin ............... Media viewer
│   └── seerr .................. New media discovery
└── xarr/
    ├── bazarr ................. Subtitle downloader
    ├── cleanuparr ............. Unwanted file cleaner
    ├── flaresolverr ........... Beat cloudflare captcha
    ├── prowlarr ............... Index manager
    ├── qbittorrent ............ Torrent client
    ├── radarr ................. Movie download manager
    └── sonarr ................. TV show download manager
