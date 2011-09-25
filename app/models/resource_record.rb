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
  
  validates :name, :rdata, :type, :ttl, :zone,
            :presence => true

  validates_inclusion_of :type,
                         :in => @@types,
                         :message => "Unknown RR type"

  # RFC 2181, 8
  validates :ttl, :numericality => {
    :greater_than_or_equal_to => 0,
    :less_than => 2**31
  }, :allow_blank => true
  
  public

    # @return [Boolean] True for RRs that need the priority attribute
    def needs_priority?; false; end

    # @return [Boolean] True for RRs that have wildcard names
    def is_wildcard?
      return false if self.name.nil?
      self.name.split('.').first == '*'
    end


  private

    def append_origin!
      self[:name] << ".#{self.zone.name}"
    end

    def origin_prepends_name?
      self[:name] =~ /\.#{Regexp.escape(self.zone.name || "")}$/
    end

    def prepare_name!
      return if self.zone.nil?

      if self[:name].blank? or self[:name] == "@"
        use_origin!
      elsif !origin_prepends_name? and self[:name] != self.zone.name
        append_origin!
      end
    end
  
    def set_ttl_from_zone_minimum!
      return if self.zone.nil?
      self.ttl ||= self.zone.minimum
    end

    def use_origin!
      self[:name] = self.zone.name
    end

end
