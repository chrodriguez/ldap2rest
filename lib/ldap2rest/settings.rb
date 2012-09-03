module Ldap2Rest

  module LdapSettings

    def self.setup(path="./config/config.yml")
      RailsConfig.load_and_set_settings path
      settings = Settings.ldap.connection.to_hash
      settings[:logger] = Logger.new(STDERR)
      settings[:logger].level = Logger::DEBUG
      settings[:allow_anonymous]= false unless settings.has_key? :allow_anonymous
      ActiveLdap::Base.setup_connection settings
      require "./lib/ldap2rest/active_ldap" 
      require "./lib/ldap2rest/api/entities" 
    end
    
  end
end
