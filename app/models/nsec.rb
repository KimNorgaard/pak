# = Next Secure (NSEC)
#
# DNSSEC.bis. Next Secure record. Ssed to provide proof of non-existence of a name.
#
# @see http://www.ietf.org/rfc/rfc4034.txt
# @see http://www.zytrax.com/books/dns/ch8/nsec.html
class NSEC < ResourceRecord
  validates :name, :hostname => { :allow_underscore => true }
  # RFC 4034, section 4.1
  validates :rdata, :format => /[\S]+ .+$/
end