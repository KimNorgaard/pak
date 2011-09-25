class Zone < ActiveRecord::Base
  has_many :resource_records, :dependent => :destroy

  set_inheritance_column "sti_disabled"
  
  cattr_reader :types
  @@types = ['NATIVE', 'MASTER', 'SLAVE', 'SUPERSLAVE']
  
  attr_accessor :strict_validation
  attr_accessor :force_active

  before_validation :set_strict_validation, :if => :active?, :unless => :force_active

  before_save :clear_empty_attrs

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

  with_options :if => :strict_validation do |zone|
    # RFC 1035, 3.3.13: SOA serial that must be a 32 bit unsigned integer
    zone.validates :serial, :numericality => { :greater_than_or_equal_to => 0, :less_than => 2**32}, :allow_blank => true
  
    # RFC 1035, 3.3.13: SOA refresh, retry, expire, minimum must be 32 bit signed integers
    # but we cheat, since negative timings does not make sense
    zone.validates :refresh, :retry, :expire, :numericality => { :greater_than_or_equal_to => 0, :less_than => 2**31 }
  
    # RFC 2308, 5: SOA minimum should be between one and three hours
    zone.validates :minimum, :numericality => { :greater_than_or_equal_to => 3600, :less_than_or_equal_to => 10800 }

    zone.validates_with ZoneValidator, :if => :strict_validation
  end
  
  # RFC 952, RFC 1123, RFC 2181
  # Custom zone validation
  validates :name, :domainname => true, :allow_blank => true
  validates :mname, :hostname => { :allow_underscore => true }, :allow_blank => true
  validates :rname, :fqdn => true, :allow_blank => true


  public

    def active=(state)
      super

      if self[:active] and @force_active == false
        @strict_validation = true
        self[:active] = valid?
      end
    end

    def activate!
      self.active = true
      save! if active?  
    end

    def deactivate!
      self.active = false
      save!
    end

    def slave?
      self.type == "SLAVE"
    end

  private

    def clear_empty_attrs
      self.master = nil if master and master.empty?
      true
    end

    def set_strict_validation
      @strict_validation = active?
      true
    end

end
