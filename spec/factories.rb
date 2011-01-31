Factory.define :a, :class => "A" do |rr|
  rr.sequence(:name) {|n| "a-test#{n}"}
  rr.rdata "192.168.0.1"
  rr.ttl 3600
end

Factory.define :aaaa, :class => "AAAA" do |rr|
  rr.sequence(:name) {|n| "aaaa-test#{n}"}
  rr.rdata "3ffe:1900:4545:3:200:f8ff:fe21:67cf"
  rr.ttl 3600
end

Factory.define :afsdb, :class => "AFSDB" do |rr|
  rr.sequence(:name) {|n| "afsdb-test#{n}"}
  rr.sequence(:rdata) {|n| "#{n} test#{n}.foo.com"}
  rr.ttl 3600
end

Factory.define :cname, :class => "CNAME" do |rr|
  rr.sequence(:name) {|n| "cname-test#{n}"}
  rr.rdata "www.foo.com"
  rr.ttl 3600
end

Factory.define :dnskey, :class => "DNSKEY" do |rr|
  rr.sequence(:name) {|n| "dnskey-test#{n}"}
  rr.rdata "256 3 5 AQPSKmynfzW4=="
  rr.ttl 3600
end

Factory.define :ds, :class => "DS" do |rr|
  rr.sequence(:name) {|n| "ds-test#{n}"}
  rr.rdata "256 3 5 AQPSKmynfzW4=="
  rr.ttl 3600
end

Factory.define :hinfo, :class => "HINFO" do |rr|
  rr.sequence(:name) {|n| "hinfo-test#{n}"}
  rr.rdata "i386 Linux"
  rr.ttl 3600
end

Factory.define :key, :class => "KEY" do |rr|
  rr.sequence(:name) {|n| "key-test#{n}"}
  rr.rdata "256 3 5 AQPSKmynfzW4=="
  rr.ttl 3600
end

Factory.define :loc, :class => "LOC" do |rr|
  rr.sequence(:name) {|n| "loc-test#{n}"}
  rr.rdata "52 14 05 N 00 08 50 E 10m"
  rr.ttl 3600
end

Factory.define :mx, :class => "MX" do |rr|
  rr.sequence(:name) {|n| "mx-test#{n}"}
  rr.rdata "192.168.0.1"
  rr.priority 10
  rr.ttl 3600
end

Factory.define :naptr, :class => "NAPTR" do |rr|
  rr.sequence(:name) {|n| "naptr-test#{n}"}
  rr.rdata '100 10 "09" "a9" "!^urn:cid:.+@([^\.]+\.)(.*)$!\2!i" .'
  rr.ttl 3600
end

Factory.define :ns, :class =>"NS" do |rr|
  rr.ttl 3600
end

Factory.define :zone do |z|
  z.sequence(:name) { |n| "test#{n}.com" }
  z.mname "ns1.bar.com"
  z.rname "hostmaster.foo.com"
  z.serial 1
end
