# = Public Key Record (KEY)
#
# Public key associated with a DNS name.
#
# @see http://www.ietf.org/rfc/rfc2535.txt
# @see http://www.zytrax.com/books/dns/ch8/key.html
class KEY < ResourceRecord
  validates :name, :hostname => { :allow_underscore => true }
  # RFC 2535, section 3.1
  validates :rdata, :format => /^\d{1,5} \d{1,3} \d{1,3} .+$/
end
