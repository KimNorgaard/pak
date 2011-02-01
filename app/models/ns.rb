# = Name Server Record (NS)
#
# Name Server. Defines the authoritative name server(s) for the domain (defined by the
# SOA record) or the subdomain.
#
# @see http://www.ietf.org/rfc/rfc1035.txt
# @see http://www.zytrax.com/books/dns/ch8/
class NS < ResourceRecord
  validates :name, :hostname => { :allow_underscore => true }
  validates :rdata, :fqdn => true
end