class BoshDirector
  def self.change_director_id(yaml, new_id)
    yaml['director_uuid'] = new_id
  end

end
