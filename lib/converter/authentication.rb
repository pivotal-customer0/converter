require 'converter/yaml_helper'
class Authentication
  def self.set_cf_admin_password(yaml, password)
    old_password = self.get_cf_admin_password yaml
    self.set_uaa_scim_passwords yaml, password
    YAMLHelper.change_value_sub_strings yaml, old_password, password
  end

  #This only changes admin, system_verification and system_services
  def self.set_uaa_scim_passwords(yaml, password)
    if yaml.respond_to?(:key?) && yaml.key?('scim')
      users = yaml['scim']['users']
      users.each_with_index do |user, user_idx|
        split_user = user.split('|')
        next unless %w(admin system_verification system_services).include? split_user[0]
        split_user[1] = password
        joined_admin_user = split_user.join('|')
        users[user_idx] = joined_admin_user
      end
    elsif yaml.respond_to?(:each)
      yaml.find{ |*a| self.set_uaa_scim_passwords(a.last, password) }
    end
  end

  def self.get_cf_admin_password(yaml)
    yaml['jobs'].each do | job |
      if job['name'].include?('uaa-partition')
        job['properties']['uaa']['scim']['users'].each do |user|
          split_user = user.split('|')
          if 'admin' == split_user[0]
            return split_user[1]
          end
        end
      end
    end
  end

  def self.set_cf_admin_password_for_errands(yaml, password)
    yaml['jobs'].each do |job|
      YAMLHelper.find job, 'cf' do |y|
        if y['cf'].key? 'admin_password'
          y['cf']['admin_password'] = password
        end
      end
    end
  end
end
