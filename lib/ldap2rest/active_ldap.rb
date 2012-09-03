module Ldap2Rest
  class User < ActiveLdap::Base
    def self.default_prefix
      nil
    end
    ldap_mapping :dn_attribute => Settings.ldap.user.dn_attribute, 
      :classes => Settings.ldap.user.classes, 
      :scope => :sub,
      :prefix => Settings.ldap.user.prefix
    belongs_to  :groups, 
      :class_name => 'Ldap2Rest::Group', 
      :many => Settings.ldap.group.member_attribute, 
      :primary_key => Settings.ldap.group.user_membership_attribute
  end

  class Group < ActiveLdap::Base
    def self.default_prefix
      nil
    end
    ldap_mapping :dn_attribute => Settings.ldap.group.dn_attribute, 
      :classes => Settings.ldap.group.classes, 
      :scope => :sub,
      :prefix => Settings.ldap.group.prefix
    has_many :members, 
      :class_name => 'Ldap2Rest::User', 
      :wrap => Settings.ldap.group.member_attribute,
      :primary_key => Settings.ldap.group.user_membership_attribute
  end

end

class ActiveLdap::Base

  def to_os
    o = OpenStruct.new
    Settings.ldap.send(self.class.name.split('::').last.downcase).attributes.to_hash.each do |att,x|
      value = self.send(att)
      o.send(att.to_s+"=", array_of(value, false))
    end
    o
  end
end
