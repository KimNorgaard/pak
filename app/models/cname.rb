# = Canonical Name Record (CNAME)
#
# Canonical Name. An alias name for a host.
#
# @see http://www.ietf.org/rfc/rfc1035.txt
# @see http://www.zytrax.com/books/dns/ch8/cname.html
class CNAME < ResourceRecord
  validates :name, :hostname =>  { :allow_underscore => true, :allow_wildcard_hostname => true }
  validates :rdata, :hostname => true
end
