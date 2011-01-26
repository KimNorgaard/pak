# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create({{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

zone_types = ZoneType.create([{ :name => 'NATIVE'}, {:name => 'MASTER'}, {:name => 'SLAVE'}, {:name => 'SUPERSLAVE'}])

RR_TYPES = [
  {:name => 'A'},
  {:name => 'AAAA'},
  {:name => 'AFSDB'},
  {:name => 'CERT'},
  {:name => 'CNAME'},
  {:name => 'DNSKEY'},
  {:name => 'DS'},
  {:name => 'HINFO'},
  {:name => 'KEY'},
  {:name => 'LOC'},
  {:name => 'MX', :needs_priority => true},
  {:name => 'NAPTR'},
  {:name => 'NS'},
  {:name => 'NSEC'},
  {:name => 'PTR'},
  {:name => 'RP'},
  {:name => 'RRSIG'},
  {:name => 'SPF'},
  {:name => 'SSHFP'},
  {:name => 'SRV', :needs_priority => true},
  {:name => 'TXT'}
]

ResourceRecordType.create(RR_TYPES)
