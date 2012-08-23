module Backend
  module ClassMethods
    def add_backend_methods
      attributes = get_class_settings.attributes
      attributes.each do | ldap_attribute, object_method |
        define_method object_method.to_s+'=' do |val|
          instance_variable_set("@#{object_method}".to_s, val)
        end
        define_method object_method do
          instance_variable_get("@#{object_method}".to_s)
        end
      end
    end    
    def backend_attribute_name(val)
      name = get_class_settings.attributes.select { |ldap_attribute, object_method|  val.to_s == object_method }.keys.first
      raise ArgumentError, "#{val} is not a valid object field for class #{to_s}" if name.nil?
      name
    end
  end

  class Ldap
    attr_reader :ldap
    public
      def to_json(options=nil)
        to_hash.to_json(options)
      end

      def self.filter(filter)
        attributes = get_class_settings.attributes
        objects = []
        get_instance.ldap.search :filter => filter, :attributes => attributes.keys do |entry|
            objects << from_entry(entry)
        end
        objects
      end

      def self.all(hash=nil)
        filter = Net::LDAP::Filter.construct get_class_settings.filter
        search_filter = nil
        hash.each do |field, value|
          if search_filter.nil?
            search_filter = Net::LDAP::Filter.eq(backend_attribute_name(field),value)
          else
            search_filter = search_filter | Net::LDAP::Filter.eq(backend_attribute_name(field),value)
          end
        end unless hash.nil?
        filter = filter & search_filter unless search_filter.nil?
        self.filter filter
      end

      def self.find(key)
        filter_base = Net::LDAP::Filter.construct get_class_settings.filter
        filter_key = Net::LDAP::Filter.eq(get_class_settings.key, key)
        filter(filter_base & filter_key).first
      end 

      def self.from_dn(dn)
        get_instance.ldap.search :base => dn, :scope => Net::LDAP::SearchScope_BaseObject, :attributes => get_class_settings.attributes.keys do |entry|
          return from_entry(entry)
        end
        raise ArgumentError, "Specified dn: #{dn} does not match any entry"
      end

    protected 
      def self.get_instance
        Ldap.new 
      end

      def self.get_settings
        Settings.ldap
      end

      def self.get_class_settings
        get_settings.send("#{self.to_s.split('::').last.downcase}") 
      end


      def self.from_entry(entry)
        attributes = get_class_settings.attributes
        instance = self.new
        attributes.each do | entry_attr, user_field | 
            value=entry.send(entry_attr)
            instance.send(user_field+"=", value.size > 1? value : value.first) 
        end
        instance
      end


      #See parameters for Net::Ldap
      def initialize
        @ldap = Net::LDAP.new({
          :host => self.class.get_settings.host, 
          :port => (self.class.get_settings.has_key? :port)? self.class.get_settings.port : 389,
          :base => self.class.get_settings.base,
          :auth => {
              :method => :simple,
              :username   => self.class.get_settings.username,
              :password   => self.class.get_settings.password,
            }
          })
      end

      def to_hash
        data = Hash.new
        self.class.get_class_settings.attributes.each do | ldap, object_method |
          data[object_method] = self.send object_method
        end
        data
      end

  end

  Ldap.extend ClassMethods

end
