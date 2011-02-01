# = Naming Authority Pointer (NAPTR)
#
# Naming Authority Pointer Record. Gross misnomer. General purpose definition of rule set
# to be used by applications e.g. VoIP
#
# @see http://www.ietf.org/rfc/rfc3403.txt
# @see http://www.zytrax.com/books/dns/ch8/naptr.html
class NAPTR < ResourceRecord
  validates :name, :hostname => { :allow_underscore => true }
  # RFC 3403, section 4.1
  validates :rdata, :format => /^\d{1,3} \d{1,3} [a-zA-Z0-9\"]+ [a-zA-Z0-9\"]+ .+? .+?$/
end
