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

Factory.define :nsec, :class => "NSEC" do |rr|
  rr.sequence(:name) {|n| "nsec-test#{n}"}
  rr.rdata 'foo.com. A MX RRSIG NSEC TYPE1234'
  rr.ttl 3600
end

Factory.define :ns, :class =>"NS" do |rr|
  rr.ttl 3600
end

Factory.define :ptr, :class => "PTR" do |rr|
  rr.sequence(:name) {|n| "#{n}"}
  rr.sequence(:rdata) {|n| "www#{n}.foo.com"}
  rr.ttl 3600
end

Factory.define :rp, :class => "RP" do |rr|
  rr.sequence(:name) {|n| "rp-test#{n}"}
  rr.rdata "john.doe.foo.com jd.people.foo.com"
  rr.ttl 3600
end

Factory.define :rrsig, :class => "RRSIG" do |rr|
  rr.sequence(:name) {|n| "rrsig-test#{n}"}
  rr.rdata "A 5 3 86400 20030322173103 20030220173103 2642 example.com. oJB1W6WNGv+="
  rr.ttl 3600
end

Factory.define :spf, :class => "SPF" do |rr|
  rr.sequence(:name) {|n| "spf-test#{n}"}
  rr.rdata "v=spf1 a -all"
  rr.ttl 3600
end

Factory.define :srv, :class => "SRV" do |rr|
  rr.sequence(:name) {|n| "_ldap._tcp.srv-test#{n}"}
  rr.rdata "0 80 ldap.host.com"
  rr.priority 10
  rr.ttl 3600
end

Factory.define :sshfp, :class => "SSHFP" do |rr|
  rr.sequence(:name) {|n| "sshfp-test#{n}"}
  rr.rdata "1 2 123456789abcdef67890123456789abcdef67890"
  rr.ttl 3600
end

Factory.define :txt, :class => "TXT" do |rr|
  rr.sequence(:name) {|n| "txt-test#{n}"}
  rr.rdata "a very pretty text"
  rr.ttl 3600
end

Factory.define :zone do |z|
  z.sequence(:name) { |n| "test#{n}.com" }
  z.mname "ns1.bar.com"
  z.rname "hostmaster.foo.com"
  z.serial 1
end
