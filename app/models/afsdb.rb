# = Location of AFS servers (AFSDB)
#
# The AFSDB DNS resource record is used to specify DCE or AFS DBserver hosts.
#
# @see http://tools.ietf.org/html/rfc1183
class AFSDB < ResourceRecord
  validates :name, :hostname => { :allow_underscore => true }
  validates :rdata, :format => /^\d+ [\w_.]+$/
end
