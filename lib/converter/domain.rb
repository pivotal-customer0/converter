require 'converter/yaml_helper'
class Domain
  def self.get_domain(yaml)
    cc = get_cloud_controller_job yaml
    return cc['properties']['domain']
  end

  def self.change_domain(yaml, new_domain)
    cc = get_cloud_controller_job yaml
    cc['properties']['domain'] = new_domain
  end

  def self.get_cloud_controller_job(yaml)
    yaml['jobs'].each do | job |
      if job['name'].include? 'cloud_controller-partition'
        return job
      end
    end
  end
end