class Settings < Settingslogic
  source File::expand_path('./config/config.yml')
  namespace ENV["ENV"] || 'production'
  load!
end

