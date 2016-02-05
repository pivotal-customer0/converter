require 'rspec'
require 'converter/authentication'
require 'securerandom'

describe 'changes the cf admin password' do
  yaml = nil
  new_password = nil

  before do
    new_password = SecureRandom.base64
  end
  context  'on cf manifests' do
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
        - push_apps_manager|b9e9a7940a6a0e0be9fc|cloud_controller.admin
        - smoke_tests|c0b558800f923b427ec7|cloud_controller.admin
        - system_services|d24a6a13ac10dcea3dc3|cloud_controller.admin
        - system_verification|ecb3ea9651fb57137247|scim.write,scim.read,openid,cloud_controller.admin,dashboard.user,console.admin,console.support
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

      context 'changes passwords' do
        before do
          Authentication.set_cf_admin_password yaml, new_password
        end

        it 'should set the uaa password' do
          admin = yaml['jobs'][0]['properties']['uaa']['scim']['users'][0]
          password = admin.split('|')[1]
          expect(password).to eql(new_password)
        end

        it 'should set dependent jobs with passwords' do
          notifications_admin_password = yaml['jobs'][1]['properties']['notifications']['cf']['admin_password']
          expect(notifications_admin_password).to eq(new_password)
        end

        it 'should set the system_services users password' do
          system_services_user = yaml['jobs'][0]['properties']['uaa']['scim']['users'][3]
          system_services_password = system_services_user.split('|')[1]
          expect(system_services_password).to eq(new_password)
        end

        it 'should set the system_verification users password' do
          system_verification_user = yaml['jobs'][0]['properties']['uaa']['scim']['users'][4]
          system_verification_password = system_verification_user.split('|')[1]
          expect(system_verification_password).to eq(new_password)
        end

      end
    end
  end

  context 'on redis manifests' do
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
      Authentication.set_cf_admin_password_for_errands yaml, new_password
      expect(yaml['jobs'][0]['properties']['cf']['admin_password']).to eql(new_password)
      expect(yaml['jobs'][1]['properties']['cf']['admin_password']).to eql(new_password)
    end
  end

  context 'on rabbit manifests' do
    manifest = <<-END
---
jobs:
- name: broker-registrar
  properties:
    cf:
      api_url: https://api.cf.haas-02.pez.pivotal.io
      admin_username: system_services
      admin_password: d24a6a13ac10dcea3dc3
- name: broker-deregistrar
  properties:
    cf:
      api_url: https://api.cf.haas-02.pez.pivotal.io
      admin_username: system_services
      admin_password: d24a6a13ac10dcea3dc3
END

    it 'should change the admin_password for the system_services user on both jobs' do
      yaml = YAML.load manifest
      Authentication.set_cf_admin_password_for_errands yaml, new_password
      expect(yaml['jobs'][0]['properties']['cf']['admin_password']).to eql(new_password)
      expect(yaml['jobs'][1]['properties']['cf']['admin_password']).to eql(new_password)
    end
  end

  context 'on mysql manifests' do
    manifest = <<-END
---
jobs:
- name: cf-mysql-broker-partition-a24ba4e9a226f8bd1d83
  properties:
    mysql_node:
      host: 10.65.170.192
      admin_password: dd3f5e7b83075792d4af
      persistent_disk: 100000
- name: broker-registrar
  properties:
    cf:
      api_url: https://api.cf.haas-02.pez.pivotal.io
      admin_username: admin
      admin_password: b76b870cddde4ec32159
      skip_ssl_validation: true
- name: broker-deregistrar
  properties:
    cf:
      api_url: https://api.cf.haas-02.pez.pivotal.io
      admin_username: admin
      admin_password: b76b870cddde4ec32159
- name: acceptance-tests
  properties:
    cf:
      api_url: https://api.cf.haas-02.pez.pivotal.io
      admin_username: system_verification
      admin_password: ecb3ea9651fb57137247
END

    before do
      yaml = YAML.load manifest
      Authentication.set_cf_admin_password_for_errands yaml, new_password
    end

    it 'should not change the mysql_node password' do
      expect(yaml['jobs'][0]['properties']['mysql_node']['admin_password']).to eql 'dd3f5e7b83075792d4af'
    end

    it 'should change the broker registrar password' do
      expect(yaml['jobs'][1]['properties']['cf']['admin_password']).to eql new_password
    end

    it 'should change the broker deregistrar password' do
      expect(yaml['jobs'][2]['properties']['cf']['admin_password']).to eql new_password
    end

    it 'should change the acceptance-tests password' do
      expect(yaml['jobs'][3]['properties']['cf']['admin_password']).to eql new_password
    end


  end
end
