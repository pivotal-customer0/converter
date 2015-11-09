#!/bin/bash -x 
#This script assumes directory structures that exist on josh's laptop. Beware.
bundle exec converter --name cf --sanitize-partition --manifest ~/git/photon-tests/pcf-photon-manifests/cf-manifests/cf-bbcf8d2283fbc851a79e.yml --output-path ~/git/photon-tests/pcf-photon-manifests/cf-manifests/cf-photon-env-01.yml --password admin
bundle exec converter --name redis --sanitize-partition --manifest ~/git/photon-tests/pcf-photon-manifests/redis-manifests/p-redis-4644ea20704f8ff3556d.yml --output-path ~/git/photon-tests/pcf-photon-manifests/redis-manifests/redis-photon-env-01.yml --password admin
bundle exec converter --name mysql --sanitize-partition --manifest ~/git/photon-tests/pcf-photon-manifests/mysql-manifests/p-mysql-3b2d164149ecabfc7560.yml --output-path ~/git/photon-tests/pcf-photon-manifests/mysql-manifests/mysql-photon-env-01.yml --password admin
bundle exec converter --name rabbit --sanitize-partition --manifest ~/git/photon-tests/pcf-photon-manifests/rabbit-manifests/p-rabbitmq-1a98269c523dd6a1bd64.yml --output-path ~/git/photon-tests/pcf-photon-manifests/rabbit-manifests/rabbit-photon-env-01.yml --password admin