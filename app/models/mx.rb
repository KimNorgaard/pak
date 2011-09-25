# = Mail Exchange Record (MX)
#
# Mail Exchanger. A preference value and the host name for a mail server/exchanger that
# will service this zone. RFC 974 defines valid names.
#
# @see http://www.ietf.org/rfc/rfc1035.txt
# @see http://www.zytrax.com/books/dns/ch8/mx.html
class MX < ResourceRecord
  validates :name, :hostname => { :allow_underscore => true, :allow_wildcard_hostname => true }
  # RFC 1035
  validates :rdata, :ip => true
  # RFC 1035
  validates :priority,
    :numericality => { :greater_than_or_equal_to => 0 , :less_than_or_equal_to => 65535, :only_integer => true },
    :presence => true

  public

    def needs_priority?; true; end

end
