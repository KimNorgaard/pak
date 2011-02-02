# = IPv4 Address Record (A)
#
# IPv4 Address record. An IPv4 address for a host.
#
# @see http://www.ietf.org/rfc/rfc1035.txt
# @see http://www.zytrax.com/books/dns/ch8/a.html
class A < ResourceRecord
  validates :name, :hostname => { :allow_underscore => true, :allow_wildcard_hostname => true }
  validates :rdata, :ip => { :ip_type => :v4 }
end
