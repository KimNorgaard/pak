# = Pointer Record (PTR)
#
# IP address (IPv4 or IPv6) to host. Used in reverse maps
#
# @see http://www.ietf.org/rfc/rfc1035.txt
# @see http://www.zytrax.com/books/dns/ch8/ptr.html
class PTR < ResourceRecord
  validates :name, :domainname => true
  validates :rdata, :fqdn => true
end
