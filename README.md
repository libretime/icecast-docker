# [icecast](https://github.com/libretime/icecast-docker)

This [project](https://github.com/libretime/icecast-docker) provide icecast container images.

While the image is under the LibreTime namespace, anyone can use it! This image will not add any LibreTime specific features, and will not deviate from upstream.

```bash
docker run -d -p 8000:8000 libretime/icecast:2.4.4
docker run -d -p 8000:8000 ghcr.io/libretime/icecast:2.4.4
```

The following icecast tags are supported:

- `2.4.4-debian`, `2.4.4`, `debian`, `latest`
- `2.4.4-alpine`, `alpine`

The following icecast tags are **not supported** anymore:

- `2.5-beta3-debian`, `2.5-beta3` (since 2025/09/17)
- `2.5-beta3-alpine` (since 2025/09/17)

> If the underlying system packages or the base images are updated, a newer docker image will be build. The tags will always point to the newer images. To prevent unexpected images updates, we suggest you to pin the image by adding its sha256 digest, for example `2.4.4@sha256:56e6f265675f07a80c4164f48b2ed6f3d371aed78a334c666dd2eda0d97afc5e`.
>
> You can use the following command to get an image sha256 digest:
>
> ```bash
> docker inspect --format='{{index .RepoDigests 0}}' ghcr.io/libretime/icecast:2.4.4
> ```

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
