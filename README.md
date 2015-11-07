Convert vSphere manifests to photon manifests
===

# DISCLAIMER
I've only tested this with Redis so far, so it's not guaranteed to be perfect. It's crazy inefficient, has no tests
besides diffing against a known working manifest and was built while I was watching a movie starring The Rock. So it
might be a time saver, or a huge time suck.

OpsMan generates manifests via `yaml` library, which has it's own quirks and I gave up trying to implement in go pretty
quick. You'll need [Ruby](https://www.ruby-lang.org/en/). I use [rvm](http://rvm.io/)

# Usage
You need ruby (sorry).

**If you have certs in your manifests (for CF do) you need to regenerate them.
This tool does not do that.**

Here's an example usage for redis for haas-04

```
$ bundle install
$ bundle exec converter.rb --name redis --swap-ip-ranges 10.65.170:10.65.172,10.65.171:10.65.173 --swap-domain haas-02.pez.pivotal.io:haas-04.pez.pivotal.io --sanitize-partition --manifest test_manifests/p-redis-4644ea20704f8ff3556d.yml
```

The `help` is helpful

```
➜  vsphere-photon-manifest-converter git:(master) ./converter.rb --help                                                                                                                                    $
Usage: converter.rb [options]
        --manifest MANIFEST          Specifies the manifest to convert
        --name NAME                  release name (e.g. --name redis)
        --password PASSWORD          password to use in new manifest, defaults to "admin"
        --swap-domain OLD_DOMAIN:NEW_DOMAIN
                                     Replaces domain on the left with domain on the right
                                     e.g. --swap-domain haas-02.pez.pivotal.io:haas-04.pez.pivotal.io
                                     take heed, this is a simple string replace, adding "https://" is probably wrong
        --swap-ip-ranges OLD_RANGE1:NEW_RANGE1,OLD_RANGE2:NEW_RANGE2
                                     Replaces ips on the left with ips on the right and will accept a comma separated list of ranges to swap
                                     Examples:
                                        --swap-ip-ranges 10.65.170:10.65.172
                                        --swap-ip-ranges 10.65.170:10.65.172,10.65.171:10.65.173
                                     take heed, this is a simple string replace
        --output-path PATH           where should we put the new manifest.
                                     Defaults to <name>-photon.yml in the current directory
        --sanitize-partition         The thing opsman does with the guid after the partition makes sense for a machine
                                     but it makes life hard for a human when reading. This flag drops it
```

# TODO
* WebApp
  * Installing ruby sucks, and is hopeless if you're on Windows.
* Try with something other than redis
* Regen certs

# Bugs
* requiring `name` and `manifest` is silly, get rid of the name argument.
