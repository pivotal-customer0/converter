Convert vSphere manifests to photon manifests
===

OpsMan generates manifests via `yaml` library, which has it's own quirks and I gave up trying to implement in go pretty
quick. You'll need [Ruby](https://www.ruby-lang.org/en/). I use [rvm](http://rvm.io/)

# Usage
You need ruby (sorry).

**If you have certs in your manifests (for CF do) you need to regenerate them. This tool does not do that.**

Here's an example usage for redis for haas-04

```
$ bundle install
$ bundle exec converter --name redis --swap-ip-ranges 10.65.170:10.65.172,10.65.171:10.65.173 --swap-domain haas-02.pez.pivotal.io:haas-04.pez.pivotal.io --sanitize-partition --manifest test_manifests/p-redis-4644ea20704f8ff3556d.yml
```

The `help` is helpful

```
Usage: bundle exec converter [options]
        --manifest MANIFEST          Specifies the manifest to convert
        --name NAME                  release name (e.g. --name redis)
        --password PASSWORD          password to use in new manifest, defaults to "admin"
        --domain NEW_DOMAIN          Replaces domains in the manifest with the new domain
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
        --dns DNS                    Overwrite (no matching) DNS with argument. If not provided we leave whatevers in the
                                     manifest alone.
                                     
        --portgroup PortGroup        Overwrite Donor Network (no matching). If not provided we leave whatevers in the
                                     manifest alone.
```

see the various scripts in [bin](https://github.com/pivotal-customer0/converter/tree/master/bin) for more example usages
# TODO
* WebApp
  * Installing ruby sucks, and is hopeless if you're on Windows.
* Try with something other than redis
* Regen certs

# Bugs
* requiring `name` and `manifest` is silly, get rid of the name argument.
