# = Delegated Signer (DS)
#
# The Delegated Signer RR is part of the DNSSEC (DNSSEC.bis) standard. It appears at the
# point of delegation in the parent zone and contains a digest of the DNSKEY RR used as
# either a Zone Signing Key (ZSK) or a Key Signing Key (KSK). It is used to authenticate
# the chain of trust from the parent to the child zone. 
#
# @see http://www.zytrax.com/books/dns/ch8/ds.html
# @see http://tools.ietf.org/html/rfc4034#section-5.1
class DS < ResourceRecord
  validates :name, :hostname => true
  # RFC 4034, section 5.1
  validates :rdata, :format => /\d{1,5} 3 \d{1,3} [\wA-Za-z0-9+\/=]+$/
end
