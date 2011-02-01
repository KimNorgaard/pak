# = Signed RRset (RRSIG)
#
# DNSSEC.bis. Signed RRset.
#
# @see http://www.ietf.org/rfc/rfc4034.txt
# @see http://www.zytrax.com/books/dns/ch8/rrsig.html
class RRSIG < ResourceRecord
  validates :name, :hostname => { :allow_underscore => true }
  # RFC 4034, section 3.1
  validates :rdata, :format => /[a-zA-Z] \d+ \d+ \d+ \d+ \d+ \d+ [A-Za-z0-9\-_.]+ [\wA-Za-z0-9+\/=]+$/
end
