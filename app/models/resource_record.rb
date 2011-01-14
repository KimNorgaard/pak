class ResourceRecord < ActiveRecord::Base
  belongs_to :zone
  belongs_to :resource_record_type
  
  # Attributes that are required
  validates :name, :presence => true
  validates :rdata, :presence => true
  validates :resource_record_type, :presence => true
  validates :zone, :presence => true  
  validates :ttl, :presence => true
  
  # RFC 2181, 8: It is hereby specified that a TTL value is an unsigned number,
  # with a minimum value of 0, and a maximum value of 2147483647. That is, a
  # maximum of 2^31 - 1.
  validates :ttl, :numericality => {
    :greater_than_or_equal_to => 0,
    :less_than => 2**31
  }, :allow_blank => true
end
