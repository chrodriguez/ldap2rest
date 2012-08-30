module Ldap2Rest
module API
  class User < Grape::Entity
    Settings.ldap.user.attributes.to_hash.each do | ldap,service | 
      expose ldap, :as => service
    end
  end
  class Group < Grape::Entity
    Settings.ldap.group.attributes.to_hash.each do | ldap,service | 
      expose ldap, :as => service
    end
  end
end
end
