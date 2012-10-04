module Ldap2Rest
module API
  class LDAP < Grape::API
    use Garner::Middleware::Cache::Bust
    helpers Garner::Mixins::Grape::Cache

    version 'v1', :using => :path
    format :json
    default_format :json

    rescue_from :all 

    helpers do
      def build_filter(model, value)
        value = '*' unless value
        Settings.ldap.send(model).filter.gsub('%s', value) if Settings.ldap.send(model).filter
      end
    end

    resource :users do
      desc "Returns a list of users from LDAP. List might be truncated if LDAP server limits response size"
      get do     
        @users = cache do
          filter ||= build_filter(:user, params[:filter])
          Ldap2Rest::User.find(:all, { :filter => filter, :limit => Settings.ldap.limit_results }).collect { |x| x.to_os }
        end
        present @users, :with => Ldap2Rest::API::User 
      end

      desc "Returns a single user matching specified username"
      get ":username" do
        params do
          requires :username, :type => String, :desc => "username to be fetched"
        end
        @user = cache do
          @user = Ldap2Rest::User.find(:first, params[:username])
          @user.to_os if @user
        end
        present @user, :with => Ldap2Rest::API::User
      end

      get ":username/groups" do
        params do
          requires :username, :type => String, :desc => "username to be fetched"
        end
        @groups = cache do
          Ldap2Rest::User.find(:first, params[:username]).groups.collect { |x| x.to_os }
        end
        present @groups, :with => Ldap2Rest::API::Group 
      end
    end

    resource :groups do
      desc "Returns a list of groups from LDAP. List might be truncated if LDAP server limits response size"
      get do     
        @groups = cache do
          filter ||= build_filter(:group, params[:filter])
          Ldap2Rest::Group.find(:all,{ :filter => filter, :limit => Settings.ldap.limit_results }).collect { |x| x.to_os }
        end
        present @groups, :with => Ldap2Rest::API::Group
      end

      desc "Returns a list of groups from LDAP matching specified filter"
      get ":name/members" do
        params do
          requires :filter, :type => String, :desc => "filter by group name. Wildcard(*) should be used"
        end
        @users = cache do
          Ldap2Rest::Group.find(:first, params[:name]).members.collect { |x| x.to_os }
        end
        present @users , :with => Ldap2Rest::API::User 
      end
    end

  end
end
end
