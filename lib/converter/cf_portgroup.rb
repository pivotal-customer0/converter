require 'converter/yaml_helper'

#NOTE This class only supports one network.

class CFPortGroup
  def self.set_portgrp(yaml, new_portgrp)
    yaml['networks'][0]['subnets'][0]['cloud_properties']['name'] = new_portgrp
  end
end
