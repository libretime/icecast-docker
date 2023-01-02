# icecast

This [project](https://github.com/libretime/icecast-docker) provide icecast container images.

While the image is under the LibreTime namespace, anyone can use it! This image will not add any LibreTime specific features, and will not deviate from upstream.

```bash
docker run -d -p 8000:8000 libretime/icecast:2.4.4
docker run -d -p 8000:8000 ghcr.io/libretime/icecast:2.4.4
```

The following icecast tags are supported:

- `2.4.4-YYYYMMDD-debian`, `2.4.4-YYYYMMDD`, `2.4.4-debian`, `2.4.4`, `debian`, `latest`
- `2.4.4-YYYYMMDD-alpine`, `2.4.4-alpine`, `alpine`
- `2.5-beta3-YYYYMMDD-debian`, `2.5-beta3-YYYYMMDD`, `2.5-beta3-debian`, `2.5-beta3`
- `2.5-beta3-YYYYMMDD-alpine`, `2.5-beta3-alpine`

> Tags such as `2.4.4` might get updated with newer images if the system packages or the base images changes. To prevent this we suggest you to use the `2.4.4-YYYYMMDD` tags that include the build date (e.g. `2.4.4-20220919`).

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
    libretime/icecast:2.4.4
```
