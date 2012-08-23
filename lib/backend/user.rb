module Backend
  class User < Backend::Ldap
    add_backend_methods 
    def groups
      Group.all :members => dn
    end
  end
end
