class Zone < ActiveRecord::Base
  has_many :resource_records, :dependent => :destroy

  attr_accessor :strict_validations
  attr_accessor :force_active

  before_save do
    set_strict_validation_if_active
    clear_empty_attrs
  end
  
  validates_associated :resource_records

  ResourceRecord.resource_record_types.each do |rr_type|
    has_many "#{rr_type.downcase}_resource_records".to_sym,
      :class_name => rr_type,
      :conditions => "resource_record_type = \"#{rr_type}\""
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
  validates :zone_type, :presence => true
  validates :master,    :presence => true,
                        :if => 'zone_type && zone_type == "SLAVE"'

  validates :master,    :ip => true,
                        :unless => 'zone_type && zone_type == "SLAVE"',
                        :allow_nil => true

  validates_inclusion_of :zone_type,
                         :in => %w(NATIVE MASTER SLAVE SUPERSLAVE),
                         :message => "Unknown zone type"

  
  # RFC 1035, 3.3.13:
  # SOA serial that must be a 32 bit unsigned integer
  validates_numericality_of :serial,
                            :greater_than_or_equal_to => 0,
                            :less_than => 2**32,
                            :if => :strict_validations,
                            :allow_blank => true
  
  # RFC 1035, 3.3.13:
  # SOA refresh, retry, expire, minimum must be 32 bit signed integers
  # but we cheat, since negative timings does not make sense
  validates :refresh, :retry, :expire, :numericality => {
    :greater_than_or_equal_to => 0,
    :less_than => 2**31,
    :if => :strict_validations
  }
  
  # RFC 2308, 5:
  # SOA minimum should be between one and three hours
  validates :minimum, :numericality => {
    :greater_than_or_equal_to => 3600,
    :less_than_or_equal_to    => 10800,
    :if => :strict_validations
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

  validates_with ZoneValidator, :if => :strict_validations


  public

    def active=(state)
      self.active = state

      if self.active? and !self.force_active
        self.strict_validations = true
        self.active = self.valid?
      end
    end

    def activate!
      self.active = true
      save! if self.active?  
    end

    def deactivate!
      self.active = false
      save!
    end


  private

    def clear_empty_attrs
      self.master = nil if self.master and self.master.empty?
    end

    def set_strict_validation_if_active
      @strict_validations = active?
    end

end
