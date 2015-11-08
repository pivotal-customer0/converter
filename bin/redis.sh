#!/usr/bin/env bash -x
bundle exec converter --name redis --swap-ip-ranges 10.65.170:10.65.172,10.65.171:10.65.173 \
    --swap-domain cf.haas-02.pez.pivotal.io:cf.haas-04.pez.pivotal.io --sanitize-partition \
    --manifest spec/test_manifests/p-redis-4644ea20704f8ff3556d.yml

diff -bwy redis-photon.yml spec/test_manifests/redis-photon.yml --suppress-common-lines
