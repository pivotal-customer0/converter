require 'rspec'
require 'converter/cf_network'
require 'yaml'

describe CFNetwork do

  describe 'DNS' do
    yaml = nil
    new_dns_ip = '10.10.10.2'
    manifest = <<-END
---
networks:
- name: default
  subnets:
  - range: 10.65.170.0/23
    gateway: 10.65.170.1
    dns:
    - 10.65.162.2
    END

    before do
      yaml = YAML.load manifest
    end

    it 'should change the current dns value' do
      CFNetwork.set_dns(yaml, new_dns_ip)
      expect(yaml['networks'][0]['subnets'][0]['dns'][0]).to eql new_dns_ip
    end
  end
end
