class YAMLHelper
  def self.change_value_sub_strings(yaml, from, to)
    yaml.each do |key, value|
      if value.respond_to? :key?
        change_value_sub_strings(yaml[key], from, to)
      elsif key.respond_to? :key?
        change_value_sub_strings(key, from, to)
      elsif value.respond_to? :each
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