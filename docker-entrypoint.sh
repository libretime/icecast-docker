#!/bin/sh

xml_edit() {
  tag="$1" && shift
  value="$2" && shift
  sed --in-place -e "s|<${tag}>[^<]*</${tag}>|<${tag}>${value}</${tag}>|g" /etc/icecast.xml
}

if [ -n "$ICECAST_SOURCE_PASSWORD" ]; then
  xml_edit source-password "$ICECAST_SOURCE_PASSWORD"
fi
if [ -n "$ICECAST_RELAY_PASSWORD" ]; then
  xml_edit relay-password "$ICECAST_RELAY_PASSWORD"
fi
if [ -n "$ICECAST_ADMIN_PASSWORD" ]; then
  xml_edit admin-password "$ICECAST_ADMIN_PASSWORD"
fi
if [ -n "$ICECAST_ADMIN_USERNAME" ]; then
  xml_edit admin-user "$ICECAST_ADMIN_USERNAME"
fi
if [ -n "$ICECAST_ADMIN_EMAIL" ]; then
  xml_edit admin "$ICECAST_ADMIN_EMAIL"
fi
if [ -n "$ICECAST_LOCATION" ]; then
  xml_edit location "$ICECAST_LOCATION"
fi
if [ -n "$ICECAST_HOSTNAME" ]; then
  xml_edit hostname "$ICECAST_HOSTNAME"
fi
if [ -n "$ICECAST_MAX_CLIENTS" ]; then
  xml_edit clients "$ICECAST_MAX_CLIENTS"
fi
if [ -n "$ICECAST_MAX_SOURCES" ]; then
  xml_edit sources "$ICECAST_MAX_SOURCES"
fi

exec "$@"
