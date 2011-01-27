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