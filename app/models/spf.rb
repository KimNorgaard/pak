# = Sender Policy Framework (SPF)
#
# Defines the servers which are authorized to send mail for a domain. Its primary function
# is to prevent identity theft by spammers.
#
# @see http://www.ietf.org/rfc/rfc4408.txt
# @see http://www.zytrax.com/books/dns/ch9/spf.html
class SPF < ResourceRecord
  validates :name, :hostname => { :allow_underscore => true, :allow_wildcard_hostname => true }
  validates :rdata, :length => { :maximum => 255 }
end
