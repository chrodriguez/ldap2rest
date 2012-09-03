task :default => [:console]


desc "Open an irb session preloaded with required libraries"
task :console do
  sh "irb -rubygems -r bundler/setup -I lib -r ldap2rest"
end

