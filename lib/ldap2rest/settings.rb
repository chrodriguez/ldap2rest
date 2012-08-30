module Ldap2Rest

  module LdapSettings

    def self.setup(path="./config/config.yml")
      RailsConfig.load_and_set_settings path
      ActiveLdap::Base.setup_connection Settings.ldap.connection.to_hash
      require "./lib/ldap2rest/active_ldap" 
      require "./lib/ldap2rest/api/entities" 
    end
    
  end
end
