module API
  class LDAP < Grape::API
    version 'v1', :using => :path
    format :json
    default_format :json

    rescue_from :all do |e|
      Rack::Response.new([ e.message ], 500, { "Content-type" => "text/error" }).finish
    end

    resource :users do
      desc "Returns a list of users from LDAP. List might be truncated if LDAP server limits response size"
      get do     
        filter = { :display_name => params[:filter], :username => params[:filter] } if params[:filter] 
        Backend::User.all filter
      end

      desc "Returns a single user matching specified username"
#      params do
#        requires :username, :type => String, :desc => "username to be fetched"
#      end
      get ":username" do
        Backend::User.find params[:username]
      end

      get ":username/groups" do
        Backend::User.find(params[:username]).groups
      end
    end

    resource :groups do
      desc "Returns a list of groups from LDAP. List might be truncated if LDAP server limits response size"
      get do     
        Backend::Group.all
      end

      desc "Returns a list of groups from LDAP matching specified filter"
#      params do
#        requires :filter, :type => String, :desc => "filter by group name. Wildcard(*) should be used"
#      end
      get "filter/:filter" do     
        Backend::Group.all :name => params[:filter]
      end

    end

  end
end
