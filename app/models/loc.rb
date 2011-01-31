# = Location Record (LOC)
#
# A LOC record (RFC 1876) is a means for expressing geographic location information for a domain name.
#
# @see http://tools.ietf.org/html/rfc1876
class LOC < ResourceRecord
  validates :name, :hostname => true
  # RFC 1876, section 3
  validates :rdata, :format => /^
    \d{1,2}(?:[ ]\d{1,2}(?:[ ][0-9]*\.?[0-9]+))?[ ](N|S)[ ]
    \d{1,3}(?:[ ]\d{1,2}(?:[ ][0-9]*\.?[0-9]+))?[ ](E|W)[ ]
    [-+]?[0-9]*\.?[0-9]+m
    (?:[ ][0-9]*\.?[0-9]+m
      (?:[ ][0-9]*\.?[0-9]+m
        (?:[ ][0-9]*\.?[0-9]+m)?)?)?
    $/x
end
