# collectd in docker
This Repo builds collectd in docker and prepares it to be used in K8s.


## Usage
By default `AutoLoadPlugin true` is enabled and `/opt/collectd/etc/collectd.d` is an expected volume to contain plugin configs.

You can use a secret or config map including plugin configs
