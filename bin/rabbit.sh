#!/usr/bin/env bash -x
bundle exec converter --name rabbit --swap-ip-ranges 10.65.170:10.65.172,10.65.171:10.65.173 \
    --domain cf.haas-04.pez.pivotal.io --sanitize-partition \
    --manifest spec/test_manifests/p-rabbitmq-1a98269c523dd6a1bd64.yml

