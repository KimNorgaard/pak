class Zone < ActiveRecord::Base
  belongs_to :zone_type
  has_many :resource_records, :dependent => :destroy
  
  validates_associated :resource_records
  
  ResourceRecordType.find(:all).each do |rr_type|
    has_many "#{rr_type.name.downcase}_resource_records".to_sym,
      :class_name => rr_type.name.upcase,
      :conditions => "resource_record_type_id = #{rr_type.id}"
    validates_associated "#{rr_type.name.downcase}_resource_records".to_sym
  end
    
  # Attributes that are required
  validates :name,      :presence => true,
                        :uniqueness => true
  validates :mname,     :presence => true
  validates :rname,     :presence => true
  validates :serial,    :presence => true
  validates :refresh,   :presence => true
  validates :retry,     :presence => true
  validates :expire,    :presence => true
  validates :minimum,   :presence => true
  validates :zone_type, :presence => true
  validates :master,    :presence => true,
                        :if => 'zone_type && zone_type.name == "SLAVE"'

  # Master must be a valid IP address
  validates :master,    :ip => true,
                        :unless => 'zone_type && zone_type.name == "SLAVE"',
                        :allow_nil => true
  
  # RFC 1035, 3.3.13: SOA serial that must be a 32 bit unsigned integer
  validates_numericality_of :serial,
    :greater_than_or_equal_to => 0,
    :less_than => 2**32,
    :allow_blank => true,
    :if => :strict_validations
  
  # RFC 1035, 3.3.13: SOA refresh, retry, expire, minimum must be 32 bit signed integers
  #                   but we cheat, since negative timings does not make sense
  validates :refresh, :retry, :expire, :numericality => {
    :greater_than_or_equal_to => 0,
    :less_than => 2**31,
    :if => :strict_validations
  }
  
  # RFC 2308, 5: SOA minimum should be between one and three hours
  validates :minimum, :numericality => {
    :greater_than_or_equal_to => 3600,
    :less_than_or_equal_to    => 10800,
    :if => :strict_validations
  }

  # Custom zone validation
  # RFC 952, RFC 1123, RFC 2181
  validates :name,  :domainname => true, :allow_blank => true
  validates :mname, :hostname => { :allow_underscore => true }, :allow_blank => true
  validates :rname, :fqdn => true, :allow_blank => true
  validates_with ZoneValidator, :if => :strict_validations

  # Clear empty attributes before saving
  before_save :clear_empty_attrs

  attr_accessor :strict_validations
  attr_accessor :force_active
  
  def self.active=(state)
    if state
      if self.force_active
        @active = true
      else
        self.strict_validations = true
        @active = self.valid?
      end
    else
      @active = false
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

  def save
    self.strict_validations = self.active?
    super
  end
  
  def save!
    self.strict_validations = self.active?
    super
  end
  
  private
  
  # Set some empty attributes to nil
  def clear_empty_attrs
    if self.master
      self.master = nil if self.master.empty?
    end
  end
end
