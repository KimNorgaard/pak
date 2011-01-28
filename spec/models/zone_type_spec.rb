require 'spec_helper'

describe ZoneType, "that is new" do
  before(:each) do
    @valid_attributes = {
      :name => 'TEST'
    }
  end
  
  it "should create a new instance given valid attributes" do
    ZoneType.create!(@valid_attributes)
  end
  
  it "should not be valid if the zone type already exists" do
    ZoneType.create!(@valid_attributes)
    zone_type = ZoneType.create(@valid_attributes)
    zone_type.should_not be_valid
  end

  it "should not be valid without a name" do
    @valid_attributes[:name] = nil
    zone_type = ZoneType.new(@valid_attributes)
    zone_type.should_not be_valid
    zone_type.should have(1).errors_on(:name)
  end
end
