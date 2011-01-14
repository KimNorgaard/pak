module SpecHelperMethods
  def check_int_on_obj_attr(obj, attrs, attr_name, bad_values, good_values)
    test_obj = obj.new(attrs)
    bad_values.each do |v|
      test_obj.send(attr_name+"=", v)
      test_obj.should_not be_valid
      test_obj.should have(1).errors_on(attr_name.to_sym)
    end
    good_values.each do |v|
      test_obj.send(attr_name+"=", v)
      test_obj.should be_valid
    end
  end
end