#!/usr/bin/env bash
rm tmp/pids/server.pid
rails db_setup_migrate:run
rails s -b 0.0.0.0
