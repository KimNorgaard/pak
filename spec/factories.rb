Factory.define :ns, :class =>"NS" do |rr|
  rr.sequence(:name) {|n| "ns#{n}.bar.com"}
  rr.rdata "192.168.0.1"
  rr.ttl 3600
end

Factory.define :zone do |z|
  z.sequence(:name) { |n| "test#{n}.com" }
  z.mname "ns1.foo.com"
  z.rname "hostmaster.foo.com"
  z.serial 1
end
