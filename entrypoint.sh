#!/bin/sh

confd -backend=env -onetime

exec "$@"