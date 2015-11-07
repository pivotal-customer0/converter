require 'rspec'
require 'converter/password_changer'

describe 'changes the cf admin password' do
  yml = nil
  manifest = <<END
---
jobs:
- name: uaa-partition-a24ba4e9a226f8bd1d83
  properties:
    uaa:
      scim:
        user:
          override: true
        userids_enabled: true
        users:
        - admin|b76b870cddde4ec32159|scim.write,scim.read,openid,cloud_controller.admin,dashboard.user,console.admin,console.support,doppler.firehose,notification_preferences.read,notification_preferences.write,notifications.manage,notification_templates.read,notification_templates.write,emails.write,notifications.write,zones.read,zones.write
END
  before do
    yml = YAML.load manifest
  end

  context 'uaa' do
    it 'should set the uaa password' do
      PasswordChanger.set_admin_password yml, 'new-password'
      admin = yml['jobs'][0]['properties']['uaa']['scim']['users'][0]
      password = admin.split('|')[1]
      expect(password).to eql('new-password')
    end
  end
end