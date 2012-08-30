module Ldap2Rest
  class User < ActiveLdap::Base
    ldap_mapping :dn_attribute => Settings.ldap.user.dn_attribute, :classes => Settings.ldap.user.classes
    belongs_to  :groups, 
      :class_name => 'Ldap2Rest::Group', 
      :many => Settings.ldap.group.member_attribute, 
      :primary_key => Settings.ldap.group.user_membership_attribute
  end

  class Group < ActiveLdap::Base
    ldap_mapping :dn_attribute => Settings.ldap.group.dn_attribute, 
      :classes => Settings.ldap.group.classes
    has_many :members, 
      :class_name => 'Ldap2Rest::User', 
      :wrap => Settings.ldap.group.member_attribute,
      :primary_key => Settings.ldap.group.user_membership_attribute
  end

end
