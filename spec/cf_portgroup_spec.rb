require 'rspec'
require 'converter/cf_portgroup'

describe CFPortGroup do
  describe 'vSphere/Photon PortGroup manipulation' do
    yaml = nil
    context 'in the cf manifest' do
     manifest = <<-END
---
name: cf-3b6ffad4633b52c03f3e
director_uuid: ignore
releases:
- name: cf-mysql
  version: '23'
- name: cf
  version: '222'
- name: diego
  version: 0.1437.0
- name: garden-linux
  version: 0.308.0
- name: etcd
  version: '16'
- name: push-apps-manager-release
  version: '397'
- name: notifications
  version: '19'
- name: notifications-ui
  version: '10'
- name: cf-autoscaling
  version: '28'
networks:
- name: default
  subnets:
  - range: 192.168.200.0/24
    gateway: 192.168.200.1
    dns:
    - 192.168.10.2
    static:
    - 192.168.200.11
    - 192.168.200.12
    - 192.168.200.13
    reserved:
    - 192.168.200.2-192.168.200.10
    - 192.168.200.79-192.168.200.113
    - 192.168.200.115-192.168.200.254
    cloud_properties:
      name: vxw-dvs-38-virtualwire-1-sid-5000-PCF Deployment Network
resource_pools:

END

 before do
     yaml = YAML.load manifest
 end
 
 it 'should get the current network' do
        expect(yaml['networks'][0]['subnets'][0]['cloud_properties']['name']).to eql 'vxw-dvs-38-virtualwire-1-sid-5000-PCF Deployment Network'
      end
      
  end
 end
end