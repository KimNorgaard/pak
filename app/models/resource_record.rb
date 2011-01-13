class ResourceRecord < ActiveRecord::Base
  belongs_to :zone
  belongs_to :resource_record_type
  
end
