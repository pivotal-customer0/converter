#!/usr/bin/env bash -x
bundle exec converter --name cf --swap-ip-ranges 10.65.170:10.65.172,10.65.171:10.65.173 \
    --swap-domain haas-02.pez.pivotal.io:haas-04.pez.pivotal.io \
    --manifest spec/test_manifests/cf-bbcf8d2283fbc851a79e.yml --dns 10.65.164.2

diff -bwy cf-photon.yml spec/test_manifests/cf-photon.yml --suppress-common-lines
