# icecast

This project provide a icecast container image.

```bash
docker run -d -p 8000:8000 ghcr.io/jooola/icecast:2.4.4
```

The following icecast versions are supported:

| Version     | Tags                                       |
| ----------- | ------------------------------------------ |
| `2.4.4`     | `2.4.4-YYYYMMDD`, `2.4.4`, `2.4`, `latest` |
| `2.5-beta3` | `2.5b3-YYYYMMDD`,`2.5b3`                   |

> The `2.5b3` tag might change in the future in order to match the icecast version format.

The default configuration file (`/etc/icecast.xml`) was updated with following changes:

- `/icecast/logging/errorlog=-` print logs to stdout instead of log file.

You can tweak the configuration using the following environment variables:

- `ICECAST_SOURCE_PASSWORD`
- `ICECAST_RELAY_PASSWORD`
- `ICECAST_ADMIN_PASSWORD`
- `ICECAST_ADMIN_USERNAME`
- `ICECAST_ADMIN_EMAIL`
- `ICECAST_LOCATION`
- `ICECAST_HOSTNAME`
- `ICECAST_MAX_CLIENTS`
- `ICECAST_MAX_SOURCES`

Or you can mount your own configuration file in the container:

```bash
docker run -d \
    -p 8000:8000 \
    -v ./icecast.xml:/etc/icecast.xml \
    ghcr.io/jooola/icecast:2.4.4
```
