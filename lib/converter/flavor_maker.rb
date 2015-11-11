class FlavorMaker
  def self.get_best_fitting_photon_vm_flavor(ram, cpu_count)
    if cpu_count == 1 && ram <= 4096
      if ram > 2048
        return 'core-110'
      else
        return 'core-100'
      end
    end

    case ram
      when 8192
        return 'core-220'
      when 16384
        return 'core-240'
      else
        return 'core-200'
    end
  end

  def self.get_best_fitting_photon_disk_flavor(disk_size)
    'core-200'
  end

  def self.convert_vsphere_cloud_props_to_photon(yaml)
    #find a cloud properties inside a resource pool.
    YAMLHelper.find(yaml, 'cloud_properties') do |resource_pool|
      ram = resource_pool['cloud_properties']['ram']
      cpu = resource_pool['cloud_properties']['cpu']
      disk = resource_pool['cloud_properties']['disk']
      vm_flavor = self.get_best_fitting_photon_vm_flavor(ram, cpu)
      disk_flavor = self.get_best_fitting_photon_disk_flavor(disk)
      vm_attached_disk_size_gb = (disk / 1024.to_f).ceil
      resource_pool['cloud_properties']={ 'vm_flavor' => vm_flavor, 'disk_flavor' => disk_flavor,
        'vm_attached_disk_size_gb' => vm_attached_disk_size_gb}
    end
  end

  def self.convert_vsphere_disk_pool_to_photon(yaml)
    YAMLHelper.find(yaml, 'disk_size') do |disk_pool|
      disk_pool['cloud_properties']={ 'disk_flavor' => 'core-200'}
    end
  end

end
