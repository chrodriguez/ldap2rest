require "rubygems"
require "bundler/setup"
Bundler.require(:default)

require "./lib/ldap2rest/settings"
require "./lib/ldap2rest/api"

Ldap2Rest::LdapSettings.setup "./config/config.yml"

Garner::Cache::ObjectIdentity::KEY_STRATEGIES = [
  Garner::Strategies::Keys::RequestPath,
  Garner::Strategies::Keys::RequestGet 
]

Garner.config.expires_in = 1800
