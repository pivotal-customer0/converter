require 'converter/flavor_maker'
require 'yaml'

describe FlavorMaker do

  describe '.photon_vm_from_ram_size' do

    context 'given one cpu and ' do
      one_cpu = 1
      context 'given 512 mb of ram' do
        it 'returns a core-100 vm' do
          expect(FlavorMaker.get_best_fitting_photon_vm_flavor(512, one_cpu)).to eql('core-100')
        end
      end

      context 'given one gig of ram' do
        it 'returns a core-100 vm' do
          expect(FlavorMaker.get_best_fitting_photon_vm_flavor(1024, one_cpu)).to eql('core-100')
        end
      end

      context 'given two gigs of ram' do
        it 'returns a core-100 vm' do
          expect(FlavorMaker.get_best_fitting_photon_vm_flavor(2048, one_cpu)).to eql('core-100')
        end
      end

      context 'given four gigs of ram' do
        it 'returns a core-110 vm' do
          expect(FlavorMaker.get_best_fitting_photon_vm_flavor(4096, one_cpu)).to eql('core-110')
        end
      end

      context 'given eight gigs of ram' do
        it 'returns a core-220 vm' do
          expect(FlavorMaker.get_best_fitting_photon_vm_flavor(8192, one_cpu)).to eql('core-220')
        end
      end

      context 'given sixteen gigs of ram' do
        it 'returns a core-240 vm' do
          expect(FlavorMaker.get_best_fitting_photon_vm_flavor(16384, one_cpu)).to eql('core-240')
        end
      end
    end

    context 'given two cpu' do
      two_cpu = 2
      context 'given one gb ram' do
        it 'returns a core-200 vm' do
          expect(FlavorMaker.get_best_fitting_photon_vm_flavor(1024, two_cpu)).to eql('core-200')
        end
      end

      context 'given eight gb ram' do
        it 'returns a core-220 vm' do
          expect(FlavorMaker.get_best_fitting_photon_vm_flavor(8192, two_cpu)).to eql('core-220')
        end
      end
    end
  end

  describe '.photon_disk_from_disk_size' do
    context 'given 1024 mb' do
      it 'returns pcf-1' do
        expect(FlavorMaker.get_best_fitting_photon_disk_flavor(1024)).to eql('pcf-1')
      end
    end
    context 'given 2048 mb' do
      it 'returns pcf-2' do
        expect(FlavorMaker.get_best_fitting_photon_disk_flavor(2048)).to eql('pcf-2')
      end
    end

    context 'given 4096 mb' do
      it 'returns pcf-4' do
        expect(FlavorMaker.get_best_fitting_photon_disk_flavor(4096)).to eql('pcf-4')
      end
    end

    context 'given 20480 mb' do
      it 'returns pcf-20' do
        expect(FlavorMaker.get_best_fitting_photon_disk_flavor(20480)).to eql('pcf-20')
      end
    end

    context 'given 30000 mb' do
      it 'returns pcf-32' do
        expect(FlavorMaker.get_best_fitting_photon_disk_flavor(30000)).to eql('pcf-32')
      end
    end

    context 'given 32768 mb' do
      it 'returns pcf-32' do
        expect(FlavorMaker.get_best_fitting_photon_disk_flavor(32768)).to eql('pcf-32')
      end
    end

    context 'given 65536 mb' do
      it 'returns pcf-64' do
        expect(FlavorMaker.get_best_fitting_photon_disk_flavor(65536)).to eql('pcf-64')
      end
    end

    context 'given 100000 mb' do
      it 'returns pcf-100' do
        expect(FlavorMaker.get_best_fitting_photon_disk_flavor(100000)).to eql('pcf-100')
      end
    end
    context 'given 102400 mb' do
      it 'returns pcf-100' do
        expect(FlavorMaker.get_best_fitting_photon_disk_flavor(102400)).to eql('pcf-100')
      end
    end
  end

  describe '.convert_vsphere_cloud_props_to_photon' do
    cloud_properties = nil

    context 'given a consul resource_pool' do
      manifest = <<-END
---
resource_pools:
- name: consul_server-partition-a24ba4e9a226f8bd1d83
  stemcell:
    name: bosh-vsphere-esxi-ubuntu-trusty-go_agent
    version: '3100'
  network: default
  cloud_properties:
    ram: 1024
    disk: 2048
    cpu: 1
    datacenters:
    - clusters:
      - Cluster-Mgmt:
          resource_pool: AZ01
      END

      before do
        yml = YAML.load manifest
        FlavorMaker.convert_vsphere_cloud_props_to_photon(yml)
        cloud_properties = yml['resource_pools'][0]['cloud_properties']
      end

      it 'only has two cloud properties after conversion' do
        expect(cloud_properties.keys.length).to eql(2)
      end

      it 'has a core-100 vm-flavor' do
        expect(cloud_properties['vm_flavor']).to eql 'core-100'
      end

      it 'has a pcf-2 disk_flavor' do
        expect(cloud_properties['disk_flavor']).to eql 'pcf-2'
      end
    end

    context 'given a mysql resource pool' do
      manifest = <<-END
---
resource_pools:
- name: mysql-partition-a24ba4e9a226f8bd1d83
  stemcell:
    name: bosh-vsphere-esxi-ubuntu-trusty-go_agent
    version: '3100'
  network: default
  cloud_properties:
    ram: 8192
    disk: 30000
    cpu: 2
    datacenters:
    - clusters:
      - Cluster-Mgmt:
          resource_pool: AZ01
      END

      before do
        yml = YAML.load manifest
        FlavorMaker.convert_vsphere_cloud_props_to_photon(yml)
        cloud_properties = yml['resource_pools'][0]['cloud_properties']
      end

      it 'has a core-220 vm-flavor' do
        expect(cloud_properties['vm_flavor']).to eql 'core-220'
      end

      it 'has a pcf-32 disk_flavor' do
        expect(cloud_properties['disk_flavor']).to eql 'pcf-32'
      end
    end

    context 'given a diego cell resource pool' do
      manifest = <<-END
---
resource_pools:
- name: diego_cell-partition-a24ba4e9a226f8bd1d83
  stemcell:
    name: bosh-vsphere-esxi-ubuntu-trusty-go_agent
    version: '3100'
  network: default
  cloud_properties:
    ram: 16384
    disk: 65536
    cpu: 2
    datacenters:
    - clusters:
      - Cluster-Mgmt:
          resource_pool: AZ01
      END

      before do
        yml = YAML.load manifest
        FlavorMaker.convert_vsphere_cloud_props_to_photon(yml)
        cloud_properties = yml['resource_pools'][0]['cloud_properties']
      end

      it 'has a core-220 vm-flavor' do
        expect(cloud_properties['vm_flavor']).to eql 'core-240'
      end

      it 'has a pcf-32 disk_flavor' do
        expect(cloud_properties['disk_flavor']).to eql 'pcf-64'
      end
    end
  end

  describe '.convert_vsphere_disk_pools_to_photon' do
    context 'given a consul persistent disk pool' do
      cloud_properties = nil
      disk_pool = nil
      manifest=<<-END
---
disk_pools:
- name: consul_server-partition-a24ba4e9a226f8bd1d83
  disk_size: 1024
      END

      before do
        yml = YAML.load manifest
        FlavorMaker.convert_vsphere_disk_pool_to_photon(yml)
        disk_pool = yml['disk_pools'][0]
        cloud_properties = disk_pool['cloud_properties']
      end

      it 'has a pcf-1 disk_flavor added to cloud props' do
        expect(cloud_properties['disk_flavor']).to eql 'pcf-1'
        expect(disk_pool['disk_size'] = 1024)
      end

    end
  end
end
