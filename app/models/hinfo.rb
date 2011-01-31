# = System Information Record (HINFO)
#
# Allows definition of the Hardware type and Operating System (OS) in use at a host. For
# security reasons these records are rarely used on public servers.
#
# @see http://www.zytrax.com/books/dns/ch8/hinfo.html
# @see http://tools.ietf.org/html/rfc1035
class HINFO < ResourceRecord
  validates :name, :hostname => true
  # RFC 1035, section 3.3.2
  validates :rdata, :format => /^\S+ (\"[^\"]*\"|\S+)$/
end
