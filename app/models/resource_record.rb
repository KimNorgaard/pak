class ResourceRecord < ActiveRecord::Base
  belongs_to :zone
  belongs_to :resource_record_type
  
  # Attributes that are required
  validates :name, :presence => true
  validates :rdata, :presence => true
  validates :resource_record_type, :presence => true
  validates :ttl, :presence => true
  validates :zone, :presence => true

  # RFC 2181, 8: It is hereby specified that a TTL value is an unsigned number,
  # with a minimum value of 0, and a maximum value of 2147483647. That is, a
  # maximum of 2^31 - 1.
  validates :ttl, :numericality => {
    :greater_than_or_equal_to => 0,
    :less_than => 2**31
  }, :allow_blank => true

  before_validation do
    set_resource_record_type_from_class_name!
    set_ttl_from_zone_minimum!
    append_zone_name!
  end

  # If ResourceRecord is called as one of the resource type children then only return
  # that subset of resource records.
  # Example: NS.find(:all)  # => only the NS resources are returned
  def self.find(*args)
    if self.name != "ResourceRecord"
      rr_type_id_from_class_name = ResourceRecordType.find(:first, :conditions => { :name => self.name }).id
      with_scope(:find => { :conditions => "resource_record_type_id = #{rr_type_id_from_class_name}" }) do
        super(*args)
      end  
    else 
      super(*args)
    end
  end
  
  # Check if the resource record needs the priority attribute
  # @return [Boolean] True if the resource record needs the priority attribute
  def needs_priority?
    self.resource_record_type.needs_priority if self.resource_record_type  
  end

  # Check if the rr has a wildcard name
  # @return [Boolean] True if the resource record has a wildcard name
  def is_wildcard?
    return false if self.name.nil?
    self.name.split('.').first == '*'
  end

private
  # Set the resource type from the class name
  def set_resource_record_type_from_class_name!
    return if self.class.name == "ResourceRecord"
    self.resource_record_type ||= ResourceRecordType.find(:first, :conditions => { :name => self.class.name })
  end
  
  # Set ttl from zone minimum ttl
  def set_ttl_from_zone_minimum!
    return if self.zone.nil?
    self.ttl ||= self.zone.minimum
  end

  # Append the zone name to the name field if missing
  def append_zone_name!
    return if self.zone.nil?
    self[:name] = self.zone.name if self[:name].blank? or self[:name] == "@"
    unless (self[:name] =~ /\.#{Regexp.escape(self.zone.name || "")}$/ or self[:name] == self.zone.name)
      self[:name] << ".#{self.zone.name}"
    end  
  end
end
