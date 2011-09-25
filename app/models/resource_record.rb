class ResourceRecord < ActiveRecord::Base
  belongs_to :zone

  cattr_reader :types
  @@types = [
    'A',     'AAAA',  'AFSDB', 'CERT',  'CNAME', 'DNSKEY', 'DS',
    'HINFO', 'KEY',   'LOC',   'MX',    'NAPTR', 'NS',     'NSEC',
    'PTR',   'RP',    'RRSIG', 'SPF',   'SSHFP', 'SRV',    'TXT'
  ]

  before_validation do
    set_ttl_from_zone_minimum!
    prepare_name!
  end
  
  validates :name, :rdata, :type, :ttl, :zone, :presence => true
  validates :type, :inclusion => {  :in => @@types, :message => "Unknown RR type" }

  # RFC 2181, 8
  validates :ttl, :numericality => { :greater_than_or_equal_to => 0, :less_than => 2**31 }, :allow_blank => true
  
  public

    def needs_priority?; false; end

    def is_wildcard?
      return false if self.name.nil?
      self.name.split('.').first == '*'
    end


  private

    def append_zone_name!
      self.name << ".#{zone.name}"
    end

    def use_zone_name!
      self.name = zone.name
    end

    def prepare_name!
      return if zone.nil? or zone.name.blank?

      use_zone_name! if name.blank? or name == '@'
      append_zone_name! unless name.index(zone.name)
    end
  
    def set_ttl_from_zone_minimum!
      return if self.zone.nil?
      self.ttl ||= self.zone.minimum
    end

end
