#!/usr/bin/env bash -x
bundle exec converter --name cf --swap-ip-ranges 10.65.170:10.65.172,10.65.171:10.65.173 \
    --domain cf.haas-04.pez.pivotal.io \
    --manifest spec/test_manifests/cf-bbcf8d2283fbc851a79e.yml --dns 10.65.164.2

if [[ $? -ne 0 ]] ; then
  echo "FAILED"
  exit 1;
fi

diff -bwy cf-photon.yml spec/test_manifests/cf-photon.yml --suppress-common-lines
