class ZoneValidator < ActiveModel::Validator
  def validate(record)
    record.errors.add(:mname, options[:message] || :mname) if mname_is_zone_name(record)
    record.errors.add(:base, options[:message] || :missing_ns_record) unless has_two_ns_rr(record)
  end
  
private
  def mname_is_zone_name(record)
    record.name == record.mname
  end
  
  def has_two_ns_rr(record)
    record.ns_resource_records.length >= 2
  end
end