require 'rspec'
require 'yaml'
require 'converter/cf_network'
require 'converter/replacement_pair'

describe CFNetwork do
  yaml, subnet = nil

  #Tied to the value in the manifest below so tests know where to start validating IP's from
  first_static_ip_offset = 102
  manifest = <<-END
networks:
- name: default
  subnets:
  - range: 10.65.170.0/23
    gateway: 10.65.170.1
    dns:
    - 10.65.162.2
    static:
    - 10.65.170.102
    - 10.65.170.103
    - 10.65.170.104
    - 10.65.170.105
    - 10.65.170.106
    - 10.65.170.107
    - 10.65.170.108
    - 10.65.170.109
    - 10.65.170.110
    - 10.65.170.111
    - 10.65.170.112
    - 10.65.170.113
    - 10.65.170.114
    reserved:
    - 10.65.170.2-10.65.170.101
    - 10.65.170.161-10.65.171.254
END

  before do
    yaml = YAML.load manifest
    subnet = yaml['networks'][0]['subnets'][0]
  end

  describe '.set_dns' do
    new_dns_ip = '10.10.10.2'

    it 'should change the current dns value' do
      CFNetwork.set_dns(yaml, new_dns_ip)
      expect(subnet['dns'][0]).to eql new_dns_ip
    end
  end

  describe '.replace_ip_block' do
    before do
      CFNetwork.replace_ip_block yaml, '10.65.170', '8.8.8'
    end

    it 'should change the reserved range, but not change more than we asked' do
      expect(subnet['reserved'][0]).to eql '8.8.8.2-8.8.8.101'
      expect(subnet['reserved'][1]).to eql '8.8.8.161-10.65.171.254'
    end

    it 'should change the static ips' do
      subnet['static'].each_with_index do |value, index |
        expect(value).to eql '8.8.8.' + (index + first_static_ip_offset) .to_s
      end
    end

  end

  describe '.replace_ip_ranges' do
    it 'should change multiple ranges' do
      ranges = [ ReplacementPair.new('10.65.170', '8.8.8'), ReplacementPair.new('10.65.171', '8.8.9')]
      CFNetwork.replace_ip_ranges yaml, ranges
      expect(subnet['reserved'][0]).to eql '8.8.8.2-8.8.8.101'
      expect(subnet['reserved'][1]).to eql '8.8.8.161-8.8.9.254'
    end
  end
end
