
class Authentication
  def self.set_admin_password(yaml, password)
    if yaml.respond_to?(:key?) && yaml.key?('scim')
      admin_user = yaml['scim']['users'][0]
      split_user = admin_user.split('|')
      split_user[1] = password
      joined_admin_user = split_user.join('|')
      yaml['scim']['users'][0]= joined_admin_user
    elsif yaml.respond_to?(:each)
      yaml.find{ |*a| self.set_admin_password(a.last, password) }
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
end