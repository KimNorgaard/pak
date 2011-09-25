class Zone < ActiveRecord::Base
  has_many :resource_records, :dependent => :destroy

  set_inheritance_column "sti_disabled"
  
  cattr_reader  :zone_types
  @@zone_types = ['NATIVE', 'MASTER', 'SLAVE', 'SUPERSLAVE']
  
  attr_accessor :strict_validation
  attr_accessor :force_active

  before_validation :set_strict_validation_if_active

  before_save :clear_empty_attrs


  validates_associated :resource_records
  ResourceRecord.types.each do |rr_type|
    has_many "#{rr_type.downcase}_resource_records".to_sym,
      :class_name => rr_type,
      :conditions => "type = \"#{rr_type}\""
    validates_associated "#{rr_type.downcase}_resource_records".to_sym
  end
    
  validates :name,      :presence => true, :uniqueness => true
  validates :mname,     :presence => true
  validates :rname,     :presence => true
  validates :serial,    :presence => true
  validates :refresh,   :presence => true
  validates :retry,     :presence => true
  validates :expire,    :presence => true
  validates :minimum,   :presence => true
  validates :type,      :presence => true
  validates :master,    :presence => true, :if => :slave?

  validates :master,    :ip => true,
                        :unless => :slave?,
                        :allow_nil => true

  validates_inclusion_of :type,
                         :in => @@zone_types,
                         :message => "Unknown zone type"

  
  # RFC 1035, 3.3.13:
  # SOA serial that must be a 32 bit unsigned integer
  validates_numericality_of :serial,
                            :greater_than_or_equal_to => 0,
                            :less_than => 2**32,
                            :if => :strict_validation,
                            :allow_blank => true
  
  # RFC 1035, 3.3.13:
  # SOA refresh, retry, expire, minimum must be 32 bit signed integers
  # but we cheat, since negative timings does not make sense
  validates :refresh, :retry, :expire, :numericality => {
    :greater_than_or_equal_to => 0,
    :less_than => 2**31,
    :if => :strict_validation
  }
  
  # RFC 2308, 5:
  # SOA minimum should be between one and three hours
  validates :minimum, :numericality => {
    :greater_than_or_equal_to => 3600,
    :less_than_or_equal_to    => 10800,
    :if => :strict_validation
  }

  # RFC 952, RFC 1123, RFC 2181
  # Custom zone validation
  validates :name,
            :domainname => true,
            :allow_blank => true

  validates :mname,
            :hostname => { :allow_underscore => true },
            :allow_blank => true

  validates :rname,
            :fqdn => true,
            :allow_blank => true

  validates_with ZoneValidator, :if => :strict_validation


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

    def set_strict_validation_if_active
      @strict_validation = active? if active? and @force_active == false
      true
    end

end
