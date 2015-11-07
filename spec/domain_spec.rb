require 'rspec'
require 'converter/domain'

describe Domain do
  describe 'Domain manipulation' do
    yaml = nil
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
END

    context 'in the cf manifest' do

      before do
        yaml = YAML.load manifest
      end
      it 'should get the current domain' do
        expect(Domain.get_domain yaml).to eql 'cf.haas-02.pez.pivotal.io'
      end

      it 'should change the current domain' do
        Domain.change_domain yaml, 'new.domain.example.com'
        expect(Domain.get_domain yaml).to eql 'new.domain.example.com'
      end
    end
  end
end
