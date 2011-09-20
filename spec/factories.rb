FactoryGirl.define do
  factory :a, :class => "A" do
    sequence(:name) {|n| "a-test#{n}"}
    rdata "192.168.0.1"
    ttl 3600
  end
end

FactoryGirl.define do
  factory :aaaa, :class => "AAAA" do
    sequence(:name) {|n| "aaaa-test#{n}"}
    rdata "3ffe:1900:4545:3:200:f8ff:fe21:67cf"
    ttl 3600
  end
end

FactoryGirl.define do
  factory :afsdb, :class => "AFSDB" do
    sequence(:name) {|n| "afsdb-test#{n}"}
    sequence(:rdata) {|n| "#{n} test#{n}.foo.com"}
    ttl 3600
  end
end

FactoryGirl.define do
  factory :cname, :class => "CNAME" do
    sequence(:name) {|n| "cname-test#{n}"}
    rdata "www.foo.com"
    ttl 3600
  end
end

FactoryGirl.define do
  factory :dnskey, :class => "DNSKEY" do
    sequence(:name) {|n| "dnskey-test#{n}"}
    rdata "256 3 5 AQPSKmynfzW4=="
    ttl 3600
  end
end

FactoryGirl.define do
  factory :ds, :class => "DS" do
    sequence(:name) {|n| "ds-test#{n}"}
    rdata "256 3 5 AQPSKmynfzW4=="
    ttl 3600
  end
end

FactoryGirl.define do
  factory :hinfo, :class => "HINFO" do
    sequence(:name) {|n| "hinfo-test#{n}"}
    rdata "i386 Linux"
    ttl 3600
  end
end

FactoryGirl.define do
  factory :key, :class => "KEY" do
    sequence(:name) {|n| "key-test#{n}"}
    rdata "256 3 5 AQPSKmynfzW4=="
    ttl 3600
  end
end

FactoryGirl.define do
  factory :loc, :class => "LOC" do
    sequence(:name) {|n| "loc-test#{n}"}
    rdata "52 14 05 N 00 08 50 E 10m"
    ttl 3600
  end
end

FactoryGirl.define do
  factory :mx, :class => "MX" do
    sequence(:name) {|n| "mx-test#{n}"}
    rdata "192.168.0.1"
    priority 10
    ttl 3600
  end
end

FactoryGirl.define do
  factory :naptr, :class => "NAPTR" do
    sequence(:name) {|n| "naptr-test#{n}"}
    rdata '100 10 "09" "a9" "!^urn:cid:.+@([^\.]+\.)(.*)$!\2!i" .'
    ttl 3600
  end
end

FactoryGirl.define do
  factory :nsec, :class => "NSEC" do
    sequence(:name) {|n| "nsec-test#{n}"}
    rdata 'foo.com. A MX RRSIG NSEC TYPE1234'
    ttl 3600
  end
end

FactoryGirl.define do
  factory :ns, :class =>"NS" do
    ttl 3600
  end
end

FactoryGirl.define do
  factory :ptr, :class => "PTR" do
    sequence(:name) {|n| "#{n}"}
    sequence(:rdata) {|n| "www#{n}.foo.com"}
    ttl 3600
  end
end

FactoryGirl.define do
  factory :rp, :class => "RP" do
    sequence(:name) {|n| "rp-test#{n}"}
    rdata "john.doe.foo.com jd.people.foo.com"
    ttl 3600
  end
end

FactoryGirl.define do
  factory :rrsig, :class => "RRSIG" do
    sequence(:name) {|n| "rrsig-test#{n}"}
    rdata "A 5 3 86400 20030322173103 20030220173103 2642 example.com. oJB1W6WNGv+="
    ttl 3600
  end
end

FactoryGirl.define do
  factory :spf, :class => "SPF" do
    sequence(:name) {|n| "spf-test#{n}"}
    rdata "v=spf1 a -all"
    ttl 3600
  end
end

FactoryGirl.define do
  factory :srv, :class => "SRV" do
    sequence(:name) {|n| "_ldap._tcp.srv-test#{n}"}
    rdata "0 80 ldap.host.com"
    priority 10
    ttl 3600
  end
end

FactoryGirl.define do
  factory :sshfp, :class => "SSHFP" do
    sequence(:name) {|n| "sshfp-test#{n}"}
    rdata "1 2 123456789abcdef67890123456789abcdef67890"
    ttl 3600
  end
end

FactoryGirl.define do
  factory :txt, :class => "TXT" do
    sequence(:name) {|n| "txt-test#{n}"}
    rdata "a very pretty text"
    ttl 3600
  end
end

FactoryGirl.define do
  factory :zone do
    sequence(:name) {|n| "test#{n}.com"}
    mname "ns1.bar.com"
    rname "hostmaster.foo.com"
    serial 1
  end
end
