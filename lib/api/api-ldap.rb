module API
  class LDAP < Grape::API
    version 'v1', :using => :path

    resource :users do
      get do     
        Backend::User.all
      end

      get "filter/:filter" do     
        Backend::User.all :display_name => params[:filter], :username => params[:filter]
      end

      get ":username" do
        Backend::User.find params[:username]
      end

      get ":username/groups" do
#        Backend::User.find(params[:username]).get_groups
      end
    end

    resource :groups do
      get do     
        Backend::Group.all
      end

      get "filter/:filter" do     
        Backend::Group.all :name => params[:filter]
      end

    end

  end
end
