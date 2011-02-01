# = Responsible Person (RP)
#
# Information about responsible person. Experimental - special apps only.
#
# @see http://www.ietf.org/rfc/rfc1183.txt
class RP < ResourceRecord
  validates :name, :hostname => { :allow_underscore => true }
  # RFC 1183, section 2.2
  validates :rdata, :format => /^\S+ \S+$/
end