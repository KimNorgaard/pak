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
    append_zone_name! unless self.zone.nil?
    set_ttl_from_zone_minimum! unless self.zone.nil?
  end

  # If ResourceRecord is called as one of the resource type children then only return
  # that subset of resource records.
  # Example: NS.find(:all)  # => only the NS resources are returned
  def self.find(*args)
    my_class_name = self.name
    if my_class_name != "ResourceRecord"
      rr_type_id_from_class_name = ResourceRecordType.find(:first, :conditions => { :name => my_class_name }).id
      with_scope(:find => { :conditions => "resource_record_type_id = #{rr_type_id_from_class_name}" }) do
        super(*args)
      end  
    else 
      super(*args)
    end  
  end

private
  # set the resource type from the class name
  def set_resource_record_type_from_class_name! #:nodoc:
    if self.class.name != "ResourceRecord" and self.resource_record_type.nil?
      self.resource_record_type = ResourceRecordType.find(:first, :conditions => { :name => self.class.name })
    end
  end
  
  # set ttl from zone minimum ttl
  def set_ttl_from_zone_minimum! #:nodoc:
    self.ttl ||= self.zone.minimum
  end

  # Append the domain name to the +name+ field if missing
  def append_zone_name! #:nodoc:
    self[:name] = self.zone.name if self[:name].blank?

    unless (self[:name] =~ /\.#{self.zone.name}$/ or self[:name] == self.zone.name)
      self[:name] << ".#{self.zone.name}"
    end  
  end
end
