# icecast

This project provide a icecast container image.

```
docker run -d -p 8000:8000 ghcr.io/jooola/icecast:2.4.4
```

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

```
docker run -d \
    -p 8000:8000 \
    -v ./icecast.xml:/etc/icecast.xml \
    ghcr.io/jooola/icecast:2.4.4
```
