# = Location of AFS servers (AFSDB)
#
# Location of AFS servers. Experimental - special apps only.
#
# @see http://www.ietf.org/rfc/rfc1183.txt
class AFSDB < ResourceRecord
  validates :name, :hostname => { :allow_underscore => true }
  validates :rdata, :format => /^\d+ [\w_.]+$/
end
