require 'rspec'
require 'converter/cf_portgroup'

describe CFPortGroup do
  describe 'vSphere/Photon PortGroup manipulation' do
    yaml = nil

    context 'in the cf manifest' do
      manifest = <<-END

---
networks:
- name: default
  subnets:
  - range: 10.65.170.0/23
    cloud_properties:
      name: Photon_PCF

END

     before do
       yaml = YAML.load manifest
     end

     it 'should swap the network' do
        CFPortGroup.set_portgroup yaml, 'a-new-network'
        expect(yaml['networks'][0]['subnets'][0]['cloud_properties']['name']).to eql 'a-new-network'
     end

  end
 end
end
