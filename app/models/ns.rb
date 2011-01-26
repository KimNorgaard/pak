class NS < ResourceRecord
  validates :name, :hostname => { :allow_underscore => true }
end