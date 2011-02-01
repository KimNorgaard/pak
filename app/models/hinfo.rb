# = System Information Record (HINFO)
#
# Host Information - optional text data about a host.
#
# @see http://www.ietf.org/rfc/rfc4034.txt
# @see http://www.zytrax.com/books/dns/ch8/hinfo.html
class HINFO < ResourceRecord
  validates :name, :hostname => { :allow_underscore => true }
  # RFC 1035, section 3.3.2
  validates :rdata, :format => /^\S+ (\"[^\"]*\"|\S+)$/
end
