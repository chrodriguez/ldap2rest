require "rubygems"
require "bundler/setup"
Bundler.require(:default)

require "./lib/ldap2rest"

Ldap2Rest::LdapSettings.setup "./config/config.yml"

Garner::Cache::ObjectIdentity::KEY_STRATEGIES = [
  Garner::Strategies::Keys::RequestPath # injects the HTTP request's URL
]
run Ldap2Rest::API::LDAP
