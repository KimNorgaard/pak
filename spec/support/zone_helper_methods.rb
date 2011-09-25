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


  def new_record(rr_type, options = {})
    FactoryGirl.build(rr_type.name.downcase.to_sym, options)
  end
  
  def new_valid_zone
    zone=FactoryGirl.build(:zone)
    zone.strict_validation = false
    zone.save!
    ns1 = new_record(NS, :zone => zone, :name => zone.name, :rdata => "ns1.bar.com")
    ns2 = new_record(NS, :zone => zone, :name => zone.name, :rdata => "ns2.bar.com")
    zone.ns_resource_records << [ns1, ns2]
    zone.strict_validation = true
    zone
  end
end
