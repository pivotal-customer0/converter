require 'converter/yaml_helper'
class CFDomain
  def self.get_domain(yaml)
    cc = get_cloud_controller_job yaml
    unless cc.nil?
      return cc['properties']['domain']
    end
    YAMLHelper.find yaml, 'api_url' do |api_url|
      return api_url['api_url'].gsub 'https://api.', ''
    end
  end

  def self.change_domain(yaml, new_domain)
    YAMLHelper.change_value_sub_strings yaml, get_domain(yaml), new_domain
  end

  def self.get_cloud_controller_job(yaml)
    yaml['jobs'].each do | job |
      if job['name'].include? 'cloud_controller-partition'
        return job
      end
    end
    return nil
  end
end
