# = Public Key Record (KEY)
#
# The KEY RR contains the public key (of an asymmetric encryption algorithm) used for all
# non-DNSSEC operations such as securing DDNS transactions. Public keys used for DNSSEC
# functions such as zone signing are defined using a DNSKEY RR. 
#
# @see http://www.zytrax.com/books/dns/ch8/key.html
# @see http://tools.ietf.org/html/rfc2535#section-3.1
class KEY < ResourceRecord
  validates :name, :hostname => true
  # RFC 2535, section 3.1
  validates :rdata, :format => /^\d{1,5} \d{1,3} \d{1,3} .+$/
end
