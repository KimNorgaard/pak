class ZoneValidator < ActiveModel::Validator
  def validate(record)
    record.errors.add(:mname, options[:message] || :mname) if mname_is_zone_name(record)
    record.errors.add(:base,  options[:message] || :missing_ns_record) unless has_two_ns_rr(record)
    record.errors.add(:mname, options[:message] || :not_a_defined_nameserver) unless mname_is_a_defined_nameserver(record)
    record.errors.add(:base,  options[:message] || :duplicate_nameservers_found) unless nameservers_are_unique(record)    
  end
  
private
  def mname_is_zone_name(record)
    record.name == record.mname
  end
  
  def has_two_ns_rr(record)
    record.ns_resource_records.length >= 2
  end
  
  def mname_is_a_defined_nameserver(record)
    unless record.mname.blank?
      nameservers = record.ns_resource_records.map(&:rdata)
      nameservers.select {|value| value.downcase == record.mname.downcase}.size > 0
    end
  end
  
  def nameservers_are_unique(record)
    nameserver_data_fields = record.ns_resource_records.map(&:rdata)
    nameserver_data_fields.inject({}) {|h,v| h[v]=h[v].to_i+1; h}.reject{|k,v| v==1}.keys.empty?
  end
end