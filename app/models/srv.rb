# = Services Record (SRV)
#
# Defines services available in the zone, for example, ldap, http etc..
#
# @see http://www.ietf.org/rfc/rfc2872.txt
# @see http://www.zytrax.com/books/dns/ch8/srv.html
class SRV < ResourceRecord
  validates :name, :hostname => { :allow_underscore => true, :allow_wildcard_hostname => true }
  validates :rdata, :format => /^\d+ \d+ [A-Za-z0-9\-_.]+$/
  # RFC 2872
  validates :priority,
    :numericality => { :greater_than_or_equal_to => 0 , :less_than_or_equal_to => 65535, :only_integer => true },
    :presence => true

  def needs_priority?; false; end
end
