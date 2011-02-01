# = Record for storing certificates (CERT)
#
# Cryptographic public keys are frequently published, and their authenticity is demonstrated
# by certificates.  A CERT resource record (RR) is defined so that such certificates and
# related certificate revocation lists can be stored in the Domain Name System (DNS).
#
# @see http://www.ietf.org/rfc/rfc4398.txt
class CERT < ResourceRecord
  validates :name, :hostname =>  { :allow_underscore => true }
end
