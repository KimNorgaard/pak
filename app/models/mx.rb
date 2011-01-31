# = Mail Exchange Record (MX)
#
# Specifies the name and relative preference of mail servers (mail exchangers in the DNS
# jargon) for the zone.
#
# @see http://www.zytrax.com/books/dns/ch8/mx.html
# @see http://tools.ietf.org/html/rfc1035
class MX < ResourceRecord
  validates :name, :hostname => true
  # RFC 1035
  validates :rdata, :ip => true
  # RFC 1035
  validates :priority,
    :numericality => { :greater_than_or_equal_to => 0 , :less_than_or_equal_to => 65535, :only_integer => true },
    :presence => true
end
