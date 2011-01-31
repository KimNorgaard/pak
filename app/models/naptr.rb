# = Naming Authority Pointer (NAPTR)
#
# NAPTR-records are used to store rules used by DDDS (Dynamic Delegation Discovery System)
# applications.
#
# @see http://tools.ietf.org/html/rfc3403
class NAPTR < ResourceRecord
  validates :name, :hostname => true
  # RFC 3403, section 4.1
  validates :rdata, :format => /^\d{1,3} \d{1,3} [a-zA-Z0-9\"]+ [a-zA-Z0-9\"]+ .+? .+?$/
end
