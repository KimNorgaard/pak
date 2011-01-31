# = DNS KEY (DNSKEY)
#
# The DNSKEY RR is part of the DNSSEC (DNSSEC.bis) standard. DNSKEY RRs contain the public
# key (of an asymmetric encryption algorithm) used in zone signing operations. Public keys
# used for other functions are defined using a KEY RR. DNSKEY RRs may be either a Zone
# Signing Key (ZSK) or a Key Signing Key (KSK). 
#
# @see http://www.zytrax.com/books/dns/ch8/dnskey.html
# @see http://tools.ietf.org/html/rfc4034#section-2.1
class DNSKEY < ResourceRecord
  validates :name, :hostname => true
  # RFC 4034, section 2.1
  validates :rdata, :format => /\d{1,5} 3 \d{1,3} [\wA-Za-z0-9+\/=]+$/
end