# = Text Record (TXT)
#
# Text information associated with a name.
#
# @see http://www.ietf.org/rfc/rfc1035.txt
# @see http://www.zytrax.com/books/dns/ch8/txt.html
class TXT < ResourceRecord
  validates :name, :hostname => { :allow_underscore => true, :allow_wildcard_hostname => true }
  validates :rdata, :length => { :maximum => 255 }
end
