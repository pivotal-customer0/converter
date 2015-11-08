require 'rspec'
require 'converter/cf_domain'

describe CFDomain do
  describe 'Domain manipulation' do
    yaml = nil
    new_domain = 'new.domain.example.com'

    context 'in the cf manifest' do
      manifest = <<-END
---
jobs:
- name: cloud_controller-partition-a24ba4e9a226f8bd1d83
  properties:
    domain: cf.haas-02.pez.pivotal.io
    system_domain: cf.haas-02.pez.pivotal.io
    system_domain_organization: system
    app_domains:
    - cf.haas-02.pez.pivotal.io
    support_address: https://support.pivotal.io
    route_registrar:
      routes:
      - name: api
        port: 9022
        uris:
        - api.cf.haas-02.pez.pivotal.io
- name: push-apps-manager
  properties:
    cf:
      api_url: https://api.cf.haas-02.pez.pivotal.io
      system_domain: cf.haas-02.pez.pivotal.io
    services:
      authentication:
        CF_LOGIN_SERVER_URL: https://login.cf.haas-02.pez.pivotal.io
        CF_UAA_SERVER_URL: https://uaa.cf.haas-02.pez.pivotal.io

      END

      before do
        yaml = YAML.load manifest
      end

      it 'should get the current domain' do
        expect(CFDomain.get_domain yaml).to eql 'cf.haas-02.pez.pivotal.io'
      end

      context 'when changing domains' do

        before do
          CFDomain.change_domain yaml, new_domain
        end

        it 'should change the current domain' do
          expect(CFDomain.get_domain yaml).to eql new_domain
        end

        it 'should change the system domain' do
          system_domain = yaml['jobs'][0]['properties']['system_domain']
          expect(system_domain).to eql new_domain
        end

        it 'should change the api endpoint' do
          api_endpoint = yaml['jobs'][0]['properties']['route_registrar']['routes'][0]['uris'][0]
          expect(api_endpoint).to eql "api.#{new_domain}"
        end

        it 'should change the uaa login url' do
          login_endpoint = yaml['jobs'][1]['properties']['services']['authentication']['CF_LOGIN_SERVER_URL']
          expect(login_endpoint).to eql "https://login.#{new_domain}"
        end
      end

    end

    context 'in a redis manifest' do
      yaml = nil
      manifest=<<-END
---
jobs:
- name: broker-registrar
  properties:
    broker:
      host: redis-broker.cf.haas-02.pez.pivotal.io
    cf:
      api_url: https://api.cf.haas-02.pez.pivotal.io
- name: broker-deregistrar
  properties:
    broker:
      host: redis-broker.cf.haas-02.pez.pivotal.io
    cf:
      api_url: https://api.cf.haas-02.pez.pivotal.io
      END

      before do
        yaml = YAML.load manifest
      end

      it 'should_get_the_current_domain' do
        expect(CFDomain.get_domain yaml).to eql('cf.haas-02.pez.pivotal.io')
      end

      context 'when changing domains' do

        before do
          CFDomain.change_domain yaml, new_domain
        end

        it 'should change the api endpoints' do
          api_endpoint = yaml['jobs'][0]['properties']['cf']['api_url']
          api_endpoint = yaml['jobs'][1]['properties']['cf']['api_url']
          expect(api_endpoint).to eql "https://api.#{new_domain}"
        end

        it 'should change the broker endpoints' do
          api_endpoint = yaml['jobs'][0]['properties']['broker']['host']
          api_endpoint = yaml['jobs'][1]['properties']['broker']['host']
          expect(api_endpoint).to eql "redis-broker.#{new_domain}"
        end
      end
    end
  end
end
