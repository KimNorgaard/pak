require 'spec_helper'
include SpecHelperMethods

describe ResourceRecord, "that is new" do
  before(:each) do
    zone = new_valid_zone
    @rr = new_a_record(zone)
  end

  it "should create a new instance given valid attributes" do
    @rr.save!
  end

  it "should not be valid without a name" do
    # We have to set zone to nil, otherwise it will automatically get zone.name appended
    # before validation and hence not be nil
    @rr.zone = nil
    @rr.name = nil
    @rr.should_not be_valid
    @rr.should have(2).errors_on(:name)
  end

  it "should not be valid without rdata" do
    @rr.rdata = nil
    @rr.should_not be_valid
    @rr.should have(1).errors_on(:rdata)
  end

  it "should not be valid without a ttl" do
    # We have to set zone to nil, otherwise it will automatically get zone.ttl appended
    # before validation and hence not be nil
    @rr.zone = nil
    @rr.ttl = nil
    @rr.should_not be_valid
    @rr.should have(1).errors_on(:ttl)
  end

  it "should not be valid if ttl is not an unsigned 32 bit integer" do
    check_int_on_obj_attr(@rr, 'ttl', [-1, 2**31], [0, 1, 2**31-1])
  end

end

describe ResourceRecord, "with Resource Record Types" do
  before(:each) do
    zone = new_valid_zone
    @rr = new_a_record(zone)
    zone.a_resource_records << @rr
    zone.save!
    ::Rails.logger.info("TJAP: #{zone.ns_resource_records}")
  end
  
  it "should have a related resource record type" do
    rr2=ResourceRecord.find(@rr.id)
    rr2.resource_record_type.should_not be_nil
    rr2.should be_valid
    rr2.resource_record_type = nil
    rr2.should_not be_valid
  end

  it "should have a related zone" do
    rr2=ResourceRecord.find(@rr.id)
    rr2.zone.should_not be_nil
    rr2.should be_valid
    rr2.zone = nil
    rr2.should_not be_valid
  end
end