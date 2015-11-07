class YAMLHelper
  def self.change_value_sub_strings(yaml, from, to)
    yaml.each do |key, value|
      if value.is_a? Hash
        change_value_sub_strings(yaml[key], from, to)
      elsif key.is_a? Hash
        change_value_sub_strings(key, from, to)
      elsif value.is_a? Array
        value.each_with_index do | v,i |
          if v.is_a? Hash
            change_value_sub_strings(yaml[key], from, to)
          elsif v.is_a? String
            yaml[key][i] = v.gsub(from,to)
          end
        end
      elsif value.is_a? String
        yaml[key] = value.gsub(from, to)
      end
    end
  end
end