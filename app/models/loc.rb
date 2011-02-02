# = Location Record (LOC)
#
# Stores GPS data. Experimental - widely used.
#
# @see http://www.ietf.org/rfc/rfc1876.txt
class LOC < ResourceRecord
  validates :name, :hostname => { :allow_underscore => true, :allow_wildcard_hostname => true }
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
