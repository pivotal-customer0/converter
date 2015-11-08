require 'converter/yaml_helper'

#NOTE This class only supports one network.

class CFNetwork
  def self.set_dns(yaml, new_dns_ip)
    yaml['networks'][0]['subnets'][0]['dns'][0] = new_dns_ip
  end
end
