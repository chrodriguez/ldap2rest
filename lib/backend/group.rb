module Backend
class Group < Backend::Ldap
  add_backend_methods 

  def self.from_entry(entry)
    instance = super(entry)
    unless instance.send(get_class_settings.members_attribute).is_a? Array 
      instance.send get_class_settings.members_attribute+'=', [ instance.send(get_class_settings.members_attribute) ] 
    end
    instance
  end


  def users
    self.send(self.class.get_class_settings.members_attribute).collect { |x| User.from_dn x }
  end

  def to_hash
    h=super
    h[self.class.get_class_settings.members_attribute] = users
    h
  end
end
end

