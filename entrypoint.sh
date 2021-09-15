#!/bin/sh
set -e

if [ -f aws_batch/tmp/pids/server.pid ]; then
  rm -f aws_batch/tmp/pids/server.pid
fi

bundle exec rails db:prepare

exec "$@"