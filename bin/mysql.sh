#!/usr/bin/env bash -x
bundle exec converter --name mysql --swap-ip-ranges 10.65.170:10.65.172,10.65.171:10.65.173 \
    --swap-domain cf.haas-02.pez.pivotal.io:cf.haas-04.pez.pivotal.io --sanitize-partition \
    --manifest spec/test_manifests/p-mysql-3b2d164149ecabfc7560.yml

