# = DNS KEY (DNSKEY)
#
# DNSSEC.bis. DNS public key RR.
#
# @see http://www.ietf.org/rfc/rfc4034.txt
# @see http://www.zytrax.com/books/dns/ch8/dnskey.html
class DNSKEY < ResourceRecord
  validates :name, :hostname => { :allow_underscore => true }
  # RFC 4034, section 2.1
  validates :rdata, :format => /\d{1,5} 3 \d{1,3} [\wA-Za-z0-9+\/=]+$/
end