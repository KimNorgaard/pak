require 'spec_helper'

describe Zone, "that is new" do
  include SpecHelperMethods
  fixtures :zone_types

  before(:each) do
    @valid_attributes = {
      :name      => 'testdomain.com',
      :mname     => 'ns1.somewhereelse.com',
      :rname     => 'hostmaster.somewhereelse.com',
      :serial    => Time.now.to_i,
      :refresh   => 10800,
      :retry     => 3600,
      :expire    => 604800,
      :minimum   => 3600,
      :active    => 1,
      :zone_type => ZoneType.find_by_name("NATIVE")
    }
  end

  it "should create a new instance given valid attributes" do
    Zone.create!(@valid_attributes)
  end
  
  it "should not be valid if the zone already exists" do
    Zone.create!(@valid_attributes)
    zone = Zone.create(@valid_attributes)
    zone.should_not be_valid
  end
  
  it "should not be valid without a name" do
    @valid_attributes[:name] = nil
    zone = Zone.new(@valid_attributes)
    zone.should_not be_valid
    zone.should have(1).errors_on(:name)
  end

  it "should not be valid without a name server" do
    @valid_attributes[:mname] = nil
    zone = Zone.new(@valid_attributes)
    zone.should_not be_valid
    zone.should have(1).errors_on(:mname)
  end

  it "should not be valid without a mailbox" do
    @valid_attributes[:rname] = nil
    zone = Zone.new(@valid_attributes)
    zone.should_not be_valid
    zone.should have(1).errors_on(:rname)
  end
  
  it "should not be valid if zone type is SLAVE but does not have a master set" do
    @valid_attributes[:master] = nil
    @valid_attributes[:zone_type] = ZoneType.find_by_name("SLAVE")
    zone = Zone.new(@valid_attributes)
    zone.should_not be_valid
    zone.should have(1).errors_on(:master)
  end
  
  it "should not be valid if master is not a valid ip address" do
    @valid_attributes[:master] = "hestetis"
    zone = Zone.new(@valid_attributes)
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
    zone = Zone.new(@valid_attributes)
    zone.name = '*invalid*'
    zone.should_not be_valid
    zone.should have(2).errors_on(:name)
    zone.name = '_host.test.com'
    zone.should_not be_valid
    zone.should have(1).errors_on(:name)
  end
  
  it "should not be valid if the rname is not a fqdn" do
    zone = Zone.new(@valid_attributes)
    zone.rname = 'invalid.toplevel'
    zone.should_not be_valid
    zone.should have(1).errors_on(:rname)
    zone.name = '_host.test.com'
    zone.should_not be_valid
    zone.should have(1).errors_on(:name)
  end

  it "should not be valid if the mname is not a hostname" do
    zone = Zone.new(@valid_attributes)
    zone.mname = '*invalid*'
    zone.should_not be_valid
    zone.should have(1).errors_on(:mname)
    zone.mname = '_ns1.test.com'
    zone.should be_valid
  end  

  pending "should not be valid if mname is the zone name" do
  end
  
  pending "should not be valid if mname is not one of the nameservers defined for the zone" do
  end
  
  pending "should not be valid if it doesn't have atleast two NS-records" do
  end
  
  pending "should not be valid if name server resource records are not unique" do
  end
  
  it "should not be valid if SOA serial is not an unsigned 32 bit integer" do
    check_int_on_obj_attr(Zone, @valid_attributes, 'serial', [-1, 2**32], [1, 2**32-1])
  end

  it "should not be valid if SOA refresh value is not a positive signed 32 bit integer" do
    check_int_on_obj_attr(Zone, @valid_attributes, 'refresh', [-1, 2**31], [1, 2**31-1])
  end

  it "should not be valid if SOA retry value is not positive a signed 32 bit integer" do
    check_int_on_obj_attr(Zone, @valid_attributes, 'retry', [-1, 2**31], [1, 2**31-1])
  end

  it "should not be valid if SOA expire value is not a positive nsigned 32 bit integer" do
    check_int_on_obj_attr(Zone, @valid_attributes, 'expire', [-1, 2**31], [1, 2**31-1])
  end
  
  it "should not be valid if SOA minimum TTL is not an unsigned integer between 3600 and 10800" do
    check_int_on_obj_attr(Zone, @valid_attributes, 'minimum', [3599, 10801], [3600, 7200, 10800])
  end
end

describe Zone, "that exists" do
  fixtures :zones
  fixtures :zone_types
  
  it "should have a collection of zones" do
    Zone.find(:all).should_not be_empty
  end

  it "should have three records" do
    Zone.should have(3).records
  end

  it "should find an existing zone" do
    zone = Zone.find(zones("test.com".to_sym).id)
    zone.should eql(zones("test.com".to_sym))
  end
end

describe Zone, "with Zone Types" do
  fixtures :zone_types
  fixtures :zones
  
  it "should have a zone type" do
    zone = Zone.find(zones("test.com".to_sym).id)
    zone.zone_type.should_not be_nil
  end
end