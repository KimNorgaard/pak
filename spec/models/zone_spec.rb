require 'spec_helper'
include SpecHelperMethods

describe Zone, "that is new" do
  before(:each) do
  end

  it "should create a new instance given valid attributes" do
    zone=new_valid_zone
    zone.save!
  end
  
  it "should activate a new instance given valid attributes" do
    zone=new_valid_zone
    zone.activate!
    zone.should be_valid
    zone.active?.should be_true
  end
  
  it "should not be valid if the zone already exists" do
    zone=new_valid_zone
    zone.save!
    zone2=zone.clone
    zone2.should_not be_valid
  end
  
  it "should not be valid without a name" do
    zone=new_valid_zone
    zone.name = nil
    zone.should_not be_valid
    zone.should have(1).errors_on(:name)
  end

  it "should not be valid without a nameserver" do
    zone=new_valid_zone
    zone.mname = nil
    zone.should_not be_valid
    zone.should have(2).errors_on(:mname)
  end

  it "should not be valid without a mailbox" do
    zone=new_valid_zone
    zone.rname = nil
    zone.should_not be_valid
    zone.should have(1).errors_on(:rname)
  end
  
  it "should not be valid if zone type is SLAVE but does not have a master set" do
    zone=new_valid_zone
    zone.master = nil
    zone.zone_type = ZoneType.find(:first, :conditions => { :name => "SLAVE"})
    zone.should_not be_valid
    zone.should have(1).errors_on(:master)
  end
  
  it "should not be valid if master is not a valid ip address" do
    zone=new_valid_zone
    zone.master="foo"
    zone.should_not be_valid
    zone.should have(1).errors_on(:master)
    zone.master = '127.0.0.1'
    zone.should be_valid
    zone.master = '127..0.0.1'
    zone.should_not be_valid
    zone.master = '999.999.999.999'
    zone.should_not be_valid
    zone.master = '999'
    zone.should_not be_valid    
    zone.master = '3XXX:1900:4545:3:200:f8ff:fe21:67cf'
    zone.should_not be_valid
    zone.master = '3ffe:1900:4545:3:200:f8ff:fe21:67cf'
    zone.should be_valid
    zone.master = 'fe80:0:0:0:200:f8ff:fe21:67cf'
    zone.should be_valid
    zone.master = 'fe80::200:f8ff:fe21:67cf'
    zone.should be_valid
  end
  
  it "should not be valid if the zone name is not a domain name" do
    zone=new_valid_zone
    zone.name = '*invalid*'
    zone.should_not be_valid
    zone.should have(2).errors_on(:name)
    zone.name = '_host.test.com'
    zone.should_not be_valid
    zone.should have(1).errors_on(:name)
  end
  
  it "should not be valid if the rname is not a fqdn" do
    zone=new_valid_zone
    zone.rname = 'invalid.toplevel'
    zone.should_not be_valid
    zone.should have(1).errors_on(:rname)
    zone.name = '_host.test.com'
    zone.should_not be_valid
    zone.should have(1).errors_on(:name)
  end

  it "should not be valid if the mname is not a hostname" do
    zone=new_valid_zone
    zone.mname = '*invalid*'
    zone.should_not be_valid
    zone.should have(2).errors_on(:mname)
  end  

  it "should not be valid if mname is the zone name" do
    zone=new_valid_zone
    zone.mname = zone.name
    zone.should_not be_valid
    zone.should have(2).errors_on(:mname)
  end
  
  it "should not be valid if it doesn't have atleast two valid NS-records" do
    zone=new_valid_zone
    zone.ns_resource_records.delete_all
    zone.should_not be_valid
    zone.should have(1).errors_on(:base)
    zone.ns_resource_records << new_record("NS", :zone => zone, :name => zone.name, :rdata => "ns1.bar.com")
    zone.should_not be_valid
    zone.should have(1).errors_on(:base)
    zone.ns_resource_records << new_record("NS", :zone => zone, :name => zone.name, :rdata => "ns2.bar.com")
    zone.should be_valid
  end

  it "should not be valid if mname is not one of the nameservers defined for the zone" do
    zone=new_valid_zone
    zone.mname = "ns1.foo.com"
    zone.should_not be_valid
    zone.should have(1).errors_on(:mname)
  end
  
  it "should not be valid if name server resource records are not unique" do
    zone=new_valid_zone
    ns_rr = zone.ns_resource_records.first.dup
    ns_rr.id = nil
    zone.ns_resource_records << ns_rr
    zone.should_not be_valid
    zone.should have(1).errors_on(:base)
  end
  
  it "should not be valid if SOA serial is not an unsigned 32 bit integer" do
    check_int_on_obj_attr(new_valid_zone, 'serial', [-1, 2**32], [1, 2**32-1])
  end

  it "should not be valid if SOA refresh value is not a positive signed 32 bit integer" do
    check_int_on_obj_attr(new_valid_zone, 'refresh', [-1, 2**31], [1, 2**31-1])
  end

  it "should not be valid if SOA retry value is not positive a signed 32 bit integer" do
    check_int_on_obj_attr(new_valid_zone, 'retry', [-1, 2**31], [1, 2**31-1])
  end

  it "should not be valid if SOA expire value is not a positive nsigned 32 bit integer" do
    check_int_on_obj_attr(new_valid_zone, 'expire', [-1, 2**31], [1, 2**31-1])
  end
  
  it "should not be valid if SOA minimum TTL is not an unsigned integer between 3600 and 10800" do
    check_int_on_obj_attr(new_valid_zone, 'minimum', [3599, 10801], [3600, 7200, 10800])
  end
end

describe Zone, "that exists" do
  it "should have a collection of zones" do
    zone=new_valid_zone
    zone.save!
    Zone.find(:all).should_not be_empty
  end

  it "should find an existing zone" do
    zone = new_valid_zone
    zone.save!
    zone2 = Zone.find(zone.id)
    zone2.should eql(zone)
  end
end

describe Zone, "with Zone Types" do
  it "should have a zone type" do
    zone = new_valid_zone
    zone.zone_type.should_not be_nil
  end
end