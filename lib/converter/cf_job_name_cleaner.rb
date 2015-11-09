class CFJobNameCleaner
  # This method assumes it's given the YAML root of a manifest, and will replace all
  # occurrences in the document.
  def self.remove_guid(manifest)
    manifest.each do |key, value|
      if 'name' == key and value.match /partition-\w+/
        new_value = value.sub(/partition.*/, 'partition')
        YAMLHelper.change_value_sub_strings(manifest, value, new_value)
        manifest[key] = new_value
      end
      if value.is_a? Array
        value.each do |v|
          unless v.is_a? String
            remove_guid(v)
          end
        end
      elsif value.is_a? Hash
        remove_guid(value)
      end
  end
  end
end
