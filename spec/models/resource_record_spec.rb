require 'spec_helper'

describe ResourceRecord, "that is new" do
  include SpecHelperMethods
  fixtures :zones
  fixtures :resource_record_types

  before(:each) do
    @valid_attributes = {
      :name                 => 'www.test.com',
      :resource_record_type => ResourceRecordType.find_by_name("A"),
      :rdata                => '127.0.0.1',
      :ttl                  => 3600,
      :priority             => nil,
      :active               => 1,
      :zone                 => Zone.find_by_name("test.com")
    }
  end

  it "should create a new instance given valid attributes" do
    ResourceRecord.create!(@valid_attributes)
  end

  it "should not be valid without a name" do
    @valid_attributes[:name] = nil
    resource_record = ResourceRecord.new(@valid_attributes)
    resource_record.should_not be_valid
    resource_record.should have(1).errors_on(:name)
  end

  it "should not be valid without rdata" do
    @valid_attributes[:rdata] = nil
    resource_record = ResourceRecord.new(@valid_attributes)
    resource_record.should_not be_valid
    resource_record.should have(1).errors_on(:rdata)
  end

  it "should not be valid without a ttl" do
    @valid_attributes[:ttl] = nil
    resource_record = ResourceRecord.new(@valid_attributes)
    resource_record.should_not be_valid
    resource_record.should have(1).errors_on(:ttl)
  end

  it "should not be valid if ttl is not an unsigned 32 bit integer" do
    check_int_on_obj_attr(ResourceRecord, @valid_attributes, 'ttl', [-1, 2**31], [0, 1, 2**31-1])
  end

end

describe ResourceRecord, "with Resource Record Types" do
  fixtures :resource_records
  
  it "should have a related resource record type" do
    resource_record = ResourceRecord.find(resource_records("www.test.com".to_sym).id)
    resource_record.resource_record_type.should_not be_nil
    resource_record.should be_valid
    resource_record.resource_record_type = nil
    resource_record.should_not be_valid
  end

  it "should have a related zone" do
    resource_record = ResourceRecord.find(resource_records("www.test.com".to_sym).id)
    resource_record.zone.should_not be_nil
    resource_record.should be_valid
    resource_record.zone = nil
    resource_record.should_not be_valid
  end
end