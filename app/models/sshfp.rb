# = SSH Public Key Fingerprint (SSHFP)
#
# Resource record for publishing SSH public host key fingerprints in the DNS System,
# in order to aid in verifying the authenticity of the host.
#
# @see http://tools.ietf.org/rfc/rfc4255.txt
class SSHFP < ResourceRecord
  validates :name, :hostname => { :allow_underscore => true, :allow_wildcard_hostname => true }
  # RFC 4255, section 3.1
  validates :rdata, :format => /^\d+ \d+ \S+$/
end
