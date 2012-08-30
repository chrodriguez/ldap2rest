module Ldap2Rest
module API
  class LDAP < Grape::API
    use Garner::Middleware::Cache::Bust
    helpers Garner::Mixins::Grape::Cache

    version 'v1', :using => :path
    format :json
    default_format :json

    #rescue_from :all 

    helpers do
      def build_filter(model, value)
        Settings.ldap.send(model).filter.gsub('%s', value) if value
      end
    end

    resource :users do
      desc "Returns a list of users from LDAP. List might be truncated if LDAP server limits response size"
      get do     
#        cache do
          filter ||= build_filter(:user, params[:filter])
          @users = Ldap2Rest::User.find(:all, :filter => filter)
          present @users, :with => Ldap2Rest::API::User
#        end
      end

      desc "Returns a single user matching specified username"
      get ":username" do
        params do
          requires :username, :type => String, :desc => "username to be fetched"
        end
        #cache do
          @user = Ldap2Rest::User.find(:first, params[:username])
          present @user, :with => Ldap2Rest::API::User
        #end
      end

      get ":username/groups" do
        params do
          requires :username, :type => String, :desc => "username to be fetched"
        end
        #cache do
          @user = Ldap2Rest::User.find(:first, params[:username])
          present @user.groups, :with => Ldap2Rest::API::Group if @user
        #end
      end
    end

    resource :groups do
      desc "Returns a list of groups from LDAP. List might be truncated if LDAP server limits response size"
      get do     
#        cache do
          filter ||= build_filter(:group, params[:filter])
          @groups = Ldap2Rest::Group.find(:all, :filter => filter)
          present @groups, :with => Ldap2Rest::API::Group
#        end
      end

      desc "Returns a list of groups from LDAP matching specified filter"
      get ":name/members" do     
        params do
          requires :filter, :type => String, :desc => "filter by group name. Wildcard(*) should be used"
        end
        #cache do
          @group = Ldap2Rest::Group.find(:first, params[:name])
          present @group.members, :with => Ldap2Rest::API::User
        #end
      end
    end

  end
end
end
