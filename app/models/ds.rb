# = Delegated Signer (DS)
#
# DNSSEC.bis. Delegated Signer RR.
#
# @see http://www.ietf.org/rfc/rfc4034.txt
# @see http://www.zytrax.com/books/dns/ch8/ds.html
class DS < ResourceRecord
  validates :name, :hostname => { :allow_underscore => true, :allow_wildcard_hostname => true }
  # RFC 4034, section 5.1
  validates :rdata, :format => /\d{1,5} 3 \d{1,3} [\wA-Za-z0-9+\/=]+$/
end
