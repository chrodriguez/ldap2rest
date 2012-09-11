require "rubygems"
require "bundler/setup"
Bundler.require(:default)

require "./lib/ldap2rest/settings"
require "./lib/ldap2rest/api"


begin
Ldap2Rest::LdapSettings.setup "./config/config.yml"
rescue NoMethodError,ArgumentError => e
  puts "\nConfig file error!!! Please read documentation or check with default config file\n\n"
  raise e
end
  

Garner::Cache::ObjectIdentity::KEY_STRATEGIES = [
  Garner::Strategies::Keys::RequestPath,
  Garner::Strategies::Keys::RequestGet 
]

begin
  Garner.config.expires_in = Settings.ldap.cache.ttl 
rescue NoMethodError
  Garner.config.expires_in = 1800
end

