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
    @rr.should have(2).errors_on(:rdata)
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

describe A, "that is new" do
  before(:each) do
    zone = new_valid_zone
    @rr = new_a_record(zone)
  end
  
  it "should not be valid without a valid ipv4 address in rdata" do
    valid_rdata = %w(127.0.0.1 192.168.0.1 8.8.8.8)
    invalid_rdata = %w(invalid 127..0.0.1 999.999.999.999 3ffe:1900:4545:3:200:f8ff:fe21:67cf)
    valid_rdata.each do |e|
      @rr.rdata = e
      @rr.should be_valid
    end
    invalid_rdata.each do |e|
      @rr.rdata = e
      @rr.should_not be_valid
    end
  end
end

describe AAAA, "that is new" do
  before(:each) do
    zone = new_valid_zone
    @rr = new_aaaa_record(zone)
  end
  
  it "should not be valid without a valid ipv6 address in rdata" do
    valid_rdata = %w(3ffe:1900:4545:3:200:f8ff:fe21:67cf fe80:0:0:0:200:f8ff:fe21:67cf fe80::200:f8ff:fe21:67cf)
    invalid_rdata = %w(invalid 127.0.0.1 8.8.8.8 192.168.0.1 999.999.999.999 3XXX:1900:4545:3:200:f8ff:fe21:67cf)
    valid_rdata.each do |e|
      @rr.rdata = e
      @rr.should be_valid
    end
    invalid_rdata.each do |e|
      @rr.rdata = e
      @rr.should_not be_valid
    end
  end
end

describe AFSDB, "that is new" do
  before(:each) do
    zone = new_valid_zone
    @rr = new_afsdb_record(zone)
  end
  
  it "should not be valid without valid rdata" do
    valid_rdata = ["1 foo.com", "2 _foo.com"]
    invalid_rdata = ["foo.com", "x foo.com"]
    valid_rdata.each do |e|
      @rr.rdata = e
      @rr.should be_valid
    end
    invalid_rdata.each do |e|
      @rr.rdata = e
      @rr.should_not be_valid
    end
  end
end

describe CNAME, "that is new" do
  before(:each) do
    zone = new_valid_zone
    @rr = new_cname_record(zone)
  end
  
  it "should not be valid if rdata is not a hostname" do
    @rr.should be_valid
    @rr.rdata = "127.0.0.1"
    @rr.should_not be_valid
  end
  
  pending "must not have other RRs of other types (MX, A, etc) except DNSSEC records (RRSIG, NSEC, etc)" do
  end
end

describe DNSKEY, "that is new" do
  before(:each) do
    zone = new_valid_zone
    @rr = new_dnskey_record(zone)
  end
  
  it "should not be valid if rdata is not a valid dnskey record" do
    @rr.should be_valid
    @rr.rdata = "hest"
    @rr.should_not be_valid
    @rr.rdata = "a b c"
    @rr.should_not be_valid
  end
end

describe DS, "that is new" do
  before(:each) do
    zone = new_valid_zone
    @rr = new_ds_record(zone)
  end
  
  it "should not be valid if rdata is not a valid ds record" do
    @rr.should be_valid
    @rr.rdata = "hest"
    @rr.should_not be_valid
    @rr.rdata = "a b c"
    @rr.should_not be_valid
  end
end

describe HINFO, "that is new" do
  before(:each) do
    zone = new_valid_zone
    @rr = new_hinfo_record(zone)
  end
  
  it "should not be valid if rdata is not a valid hinfo record" do
    @rr.should be_valid
    @rr.rdata = "hest"
    @rr.should_not be_valid
    @rr.rdata = "i386 \"Linux RedHat\""
    @rr.should be_valid
  end
end

describe KEY, "that is new" do
  before(:each) do
    zone = new_valid_zone
    @rr = new_key_record(zone)
  end
  
  it "should not be valid if rdata is not a valid key record" do
    @rr.should be_valid
    @rr.rdata = "hest"
    @rr.should_not be_valid
    @rr.rdata = "a b c"
    @rr.should_not be_valid
  end
end

describe LOC, "that is new" do
  before(:each) do
    zone = new_valid_zone
    @rr = new_loc_record(zone)
  end
  
  it "should not be valid if rdata is not a valid key record" do
    @rr.should be_valid
    @rr.rdata = "hest"
    @rr.should_not be_valid
    @rr.rdata = "a b c"
    @rr.should_not be_valid
    @rr.rdata = "42 21 43.952 N 71 5 6.344 W -24m 1m 200m"
    @rr.should be_valid
  end
end

describe MX, "that is new" do
  before(:each) do
    zone = new_valid_zone
    @rr = new_mx_record(zone)
  end
  
  it "should not be valid if rdata is not a valid ip" do
    @rr.should be_valid
    @rr.rdata = "hest"
    @rr.should_not be_valid
  end
  
  it "should not be valid if rdata is not a valid ip" do
    valid_rdata = %w(
      3ffe:1900:4545:3:200:f8ff:fe21:67cf fe80:0:0:0:200:f8ff:fe21:67cf fe80::200:f8ff:fe21:67cf
      127.0.0.1 8.8.8.8 192.168.0.1
    )
    invalid_rdata = %w(invalid 999.999.999.999 3XXX:1900:4545:3:200:f8ff:fe21:67cf)
    valid_rdata.each do |e|
      @rr.rdata = e
      @rr.should be_valid
    end
    invalid_rdata.each do |e|
      @rr.rdata = e
      @rr.should_not be_valid
    end
  end
  
  it "should not be valid without a priority" do
    @rr.priority = nil
    @rr.should_not be_valid
    @rr.should have(2).errors_on(:priority)
  end
  
  it "should not be valid if priority is not valid" do
    @rr.priority = "invalid"
    @rr.should_not be_valid
    check_int_on_obj_attr(@rr, 'priority', [-1, 2**16], [0, 1, 2**16-1])
  end
end

describe NAPTR, "that is new" do
  before(:each) do
    zone = new_valid_zone
    @rr = new_naptr_record(zone)
  end
  
  it "should not be valid if rdata is not a valid naptr record" do
    @rr.should be_valid
    @rr.rdata = "hest"
    @rr.should_not be_valid
    @rr.rdata = "a b c"
    @rr.should_not be_valid
    @rr.rdata = "100 10 a0 90 test hest"
    @rr.should be_valid
  end
end
