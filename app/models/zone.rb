class Zone < ActiveRecord::Base
  has_many :resource_records, :dependent => :destroy

  nilify_blanks
  
  set_inheritance_column "sti_disabled"
  
  cattr_reader :types
  @@types = ['NATIVE', 'MASTER', 'SLAVE', 'SUPERSLAVE']
  
  # Handle relations and validations for all resource records on this zone
  validates_associated :resource_records
  ResourceRecord.types.each do |rr_type|
    has_many "#{rr_type.downcase}_resource_records".to_sym,
      :class_name => rr_type,
      :conditions => "type = \"#{rr_type}\""
    validates_associated "#{rr_type.downcase}_resource_records".to_sym
  end

  validates :mname, :rname, :serial, :refresh, :retry, :expire, :minimum, :type, :presence => true
  validates :name, :presence => true, :uniqueness => true
  validates :master, :presence => true, :if => :slave?
  validates :master, :ip => true, :unless => :slave?, :allow_nil => true
  validates :type, :inclusion => { :in => @@types, :message => "Unknown zone type" }

  # RFC 952, RFC 1123, RFC 2181
  validates :name, :domainname => true, :allow_blank => true
  validates :mname, :hostname => { :allow_underscore => true }, :allow_blank => true
  validates :rname, :fqdn => true, :allow_blank => true

  # RFC 1035, 3.3.13: SOA serial that must be a 32 bit unsigned integer
  # RFC 1035, 3.3.13: SOA refresh, retry, expire, minimum must be 32 bit signed integers but we cheat, since negative timings does not make sense
  # RFC 2308, 5:      SOA minimum should be between one and three hours
  with_options :if => :strict_validation? do |zone|
    zone.validates :serial, :numericality => { :greater_than_or_equal_to => 0, :less_than => 2**32}, :allow_blank => true
    zone.validates :refresh, :retry, :expire, :numericality => { :greater_than_or_equal_to => 0, :less_than => 2**31 }
    zone.validates :minimum, :numericality => { :greater_than_or_equal_to => 3600, :less_than_or_equal_to => 10800 }
    zone.validates_with ZoneValidator
  end


  public

    def activate!
      self.active = true
      save!
    end

    def deactivate!
      self.active = false
      save!
    end

    def slave?
      self.type == "SLAVE" || self.type == "SUPERSLAVE"
    end

end
