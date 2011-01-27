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
  
  # If we are called as one of the resource type sub-classes we only return that subset of resource records
  # e.g. Zone.find_by_id(1).ns_resource_records.find(:all)  # => only the NS resources are returned
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

  def before_validation #:nodoc:
    unless self.class.name == "ResourceRecord"
      # set the resource type from the class name
      self.resource_record_type_id = ResourceRecordType.find(:first, :conditions => { :name => self.class.name }).id
    end

    # get ttl from zone
    unless self.zone.nil?
      append_zone_name!
      self.ttl ||= self.zone.minimum
    end  
  end

private

  # Append the domain name to the +name+ field if missing
  def append_zone_name!
    self[:name] = self.zone.name if self[:name].blank?

    unless (self[:name] =~ /\.#{self.zone.name}$/ or self[:name] == self.zone.name)
      self[:name] << ".#{self.zone.name}"
    end  
  end
end
