class ResourceRecordType < ActiveRecord::Base
  has_many :resource_records
  
  # Attributes that are required
  validates :name, :presence => true,
                   :uniqueness => true
end
