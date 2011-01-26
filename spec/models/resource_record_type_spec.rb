require 'spec_helper'

describe ResourceRecordType, "that is new" do
  #fixtures :resource_record_types
  before(:each) do
    @valid_attributes = {
      :name           => 'TEST',
      :needs_priority => 0
    }
  end
  
  it "should create a new instance given valid attributes" do
    ResourceRecordType.create!(@valid_attributes)
  end
  
  it "should not be valid if the resource record type already exists" do
    ResourceRecordType.create!(@valid_attributes)
    resource_record_type = ResourceRecordType.create(@valid_attributes)
    resource_record_type.should_not be_valid
  end

  it "should not be valid without a name" do
    @valid_attributes[:name] = nil
    resource_record_type = ResourceRecordType.new(@valid_attributes)
    resource_record_type.should_not be_valid
    resource_record_type.should have(1).errors_on(:name)
  end

end
