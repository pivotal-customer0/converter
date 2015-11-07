require 'rspec'
require 'converter/authentication'

describe 'changes the cf admin password' do
  context  'on cf manifests' do
    yaml = nil
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
- name: notifications
  properties:
    notifications:
      cf:
        admin_user: admin
        admin_password: b76b870cddde4ec32159

END
    before do
      yaml = YAML.load manifest
    end

    context 'uaa' do
      it 'should get the cf admin password' do
        password = Authentication.get_cf_admin_password yaml
        expect(password).to eql 'b76b870cddde4ec32159'
      end

      it 'should set the uaa password' do
        Authentication.set_cf_admin_password yaml, 'new-password'
        admin = yaml['jobs'][0]['properties']['uaa']['scim']['users'][0]
        password = admin.split('|')[1]
        expect(password).to eql('new-password')
      end

      it 'should set dependent jobs with passwords' do
        Authentication.set_cf_admin_password yaml, 'funky-town'
        notifications_admin_password = yaml['jobs'][1]['properties']['notifications']['cf']['admin_password']
        expect(notifications_admin_password).to eq('funky-town')
      end
    end
  end

  context 'on redis manifests' do
    yaml = nil
    manifest = <<-END
---
jobs:
- name: broker-registrar
  lifecycle: errand
  properties:
    cf:
      api_url: https://api.cf.haas-02.pez.pivotal.io
      admin_username: admin
      admin_password: b76b870cddde4ec32159
- name: broker-deregistrar
  lifecycle: errand
  properties:
    cf:
      api_url: https://api.cf.haas-02.pez.pivotal.io
      admin_username: admin
      admin_password: b76b870cddde4ec32159
END

    before do
      yaml = YAML.load manifest
    end

    it 'should change the cf admin password to funky-town for both jobs' do
      Authentication.set_cf_admin_password_for_errands yaml, 'funky-town'
      expect(yaml['jobs'][0]['properties']['cf']['admin_password']).to eql('funky-town')
      expect(yaml['jobs'][1]['properties']['cf']['admin_password']).to eql('funky-town')
    end
  end



end