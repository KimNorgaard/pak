module SpecHelperMethods
  def check_int_on_obj_attr(obj, attr_name, bad_values, good_values)
    bad_values.each do |v|
      obj.send(attr_name+"=", v)
      obj.should_not be_valid
      obj.should have(1).errors_on(attr_name.to_sym)
    end
    good_values.each do |v|
      obj.send(attr_name+"=", v)
      obj.should be_valid
    end
  end

  def new_a_record(zone)
    a_rr_type = ResourceRecordType.find(:first, :conditions => { :name => "A" })
    Factory.build(:a, :resource_record_type => a_rr_type, :zone => zone)
  end

  def new_aaaa_record(zone)
    aaaa_rr_type = ResourceRecordType.find(:first, :conditions => { :name => "AAAA" })
    Factory.build(:aaaa, :resource_record_type => aaaa_rr_type, :zone => zone)
  end

  def new_afsdb_record(zone)
    afsdb_rr_type = ResourceRecordType.find(:first, :conditions => { :name => "AFSDB" })
    Factory.build(:afsdb, :resource_record_type => afsdb_rr_type, :zone => zone)
  end

  def new_cname_record(zone)
    cname_rr_type = ResourceRecordType.find(:first, :conditions => { :name => "CNAME" })
    Factory.build(:cname, :resource_record_type => cname_rr_type, :zone => zone)
  end

  def new_dnskey_record(zone)
    dnskey_rr_type = ResourceRecordType.find(:first, :conditions => { :name => "DNSKEY" })
    Factory.build(:dnskey, :resource_record_type => dnskey_rr_type, :zone => zone)
  end

  def new_ds_record(zone)
    ds_rr_type = ResourceRecordType.find(:first, :conditions => { :name => "DS" })
    Factory.build(:ds, :resource_record_type => ds_rr_type, :zone => zone)
  end

  def new_hinfo_record(zone)
    hinfo_rr_type = ResourceRecordType.find(:first, :conditions => { :name => "HINFO" })
    Factory.build(:hinfo, :resource_record_type => hinfo_rr_type, :zone => zone)
  end

  def new_key_record(zone)
    key_rr_type = ResourceRecordType.find(:first, :conditions => { :name => "KEY" })
    Factory.build(:key, :resource_record_type => key_rr_type, :zone => zone)
  end

  def new_loc_record(zone)
    loc_rr_type = ResourceRecordType.find(:first, :conditions => { :name => "LOC" })
    Factory.build(:loc, :resource_record_type => loc_rr_type, :zone => zone)
  end

  def new_mx_record(zone)
    mx_rr_type = ResourceRecordType.find(:first, :conditions => { :name => "MX" })
    Factory.build(:mx, :resource_record_type => mx_rr_type, :zone => zone)
  end

  def new_naptr_record(zone)
    naptr_rr_type = ResourceRecordType.find(:first, :conditions => { :name => "NAPTR" })
    Factory.build(:naptr, :resource_record_type => naptr_rr_type, :zone => zone)
  end


  def new_ns_record(name, rdata)
    ns_rr_type = ResourceRecordType.find(:first, :conditions => { :name => "NS" })
    Factory.build(:ns, :name => "#{name}", :rdata => "#{rdata}", :resource_record_type => ns_rr_type)
  end
  
  def new_valid_zone
    zone=Factory.build(:zone)
    zone.zone_type = ZoneType.find(:first, :conditions => { :name => "NATIVE" })
    zone.save!
    ns1 = new_ns_record(zone.name, "ns1.bar.com")
    ns2 = new_ns_record(zone.name, "ns2.bar.com")
    zone.ns_resource_records << [ns1, ns2]
    zone.strict_validations = true
    zone
  end
end