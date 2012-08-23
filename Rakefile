task :default => [:console]


desc "Open an irb session preloaded with required libraries"
task :console do
  sh "irb -rubygems -I lib -r grape  -r settingslogic -r net/ldap -r settings -r backend/backend-ldap -r backend/user -r backend/group"
end

