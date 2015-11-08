require 'converter/yaml_helper'

#NOTE This class only supports one network.

class CFNetwork
  def self.set_dns(yaml, new_dns_ip)
    yaml['networks'][0]['subnets'][0]['dns'][0] = new_dns_ip
  end

  def self.replace_ip_block(yaml, old_block, new_block)
    YAMLHelper.change_value_sub_strings yaml, old_block, new_block
  end

  def self.replace_ip_ranges(yaml, ranges)
    ranges.each do |range|
      replace_ip_block yaml, range.old, range.new
    end
  end
end
