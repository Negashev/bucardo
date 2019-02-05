#!/bin/sh

if [ -e /tmp/bucardo/bucardo.pid ]; then
  bucardo install --piddir=/tmp/bucardo
fi

exec "$@"
