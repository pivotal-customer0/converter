require 'rspec'
require 'yaml'
require 'converter/cf_job_name_cleaner'

describe CFJobNameCleaner do
  yaml = nil
  manifest = <<-END
---
resource_pools:
- name: nfs_server-partition-a24ba4e9a226f8bd1d83
jobs:
- name: nfs_server-partition-a24ba4e9a226f8bd1d83
  resource_pool: nfs_server-partition-a24ba4e9a226f8bd1d83
  persistent_disk_pool: nfs_server-partition-a24ba4e9a226f8bd1d83
disk_pools:
- name: nfs_server-partition-a24ba4e9a226f8bd1d83

  END

  before do
    yaml = YAML.load manifest
  end

  describe '.sanitize_partition' do
    it 'should remove the guid from the nfs server' do
      CFJobNameCleaner.remove_guid yaml, 'nfs_server-partition'
      expect(yaml['resource_pools'][0]['name']).to eql 'nfs_server_partition'
      expect(yaml['jobs'][0]['name']).to eql 'nfs_server_partition'
      expect(yaml['jobs'][0]['resource_pool']).to eql 'nfs_server_partition'
      expect(yaml['jobs'][0]['persistent_disk_pool']).to eql 'nfs_server_partition'
      expect(yaml['disk_pools'][0]['name']).to eql 'nfs_server_partition'
    end
  end
end
