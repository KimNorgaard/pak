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

  def new_ns_record(name, rdata)
    ns_rr_type = ResourceRecordType.find(:first, :conditions => { :name => "NS" })
    Factory.build(:ns, :name => "#{name}", :rdata => "#{rdata}", :resource_record_type => ns_rr_type)
  end
  
  def new_valid_zone
    zone=Factory.build(:zone)
    zone.zone_type = ZoneType.find(:first, :conditions => { :name => "NATIVE" })
    ns1 = new_ns_record("ns1.bar.com", "192.168.0.1")
    ns2 = new_ns_record("ns2.bar.com", "192.168.0.2")
    zone.ns_resource_records << [ns1, ns2]
    zone
  end
end