require 'rspec'
require 'yaml'
require 'converter/bosh_director'

describe 'the director id' do
  manifest = <<-END
---
name: cf-bbcf8d2283fbc851a79e
director_uuid: 5d9c9bb5-4f12-40b7-be33-b94ddad704db
  END

  it 'should be changed to ignore' do
    yaml = YAML.load manifest
    BoshDirector.change_director_id yaml, 'ignore'
    expect(yaml['director_uuid']).to eql 'ignore'
  end
end
