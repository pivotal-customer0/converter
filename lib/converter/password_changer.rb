
class PasswordChanger
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
end