module AuthenticationHelpers
  extend ActiveSupport::Concern

  module InstanceMethods

    def current_user
      @user ||= begin
        id, type = session[:user_id], session[:user_type]
        klass = klass_type_mapping[type]
        if id.present? && klass.present?
          klass.find(id)
        end
      end
    end

    def current_user=(type)
      if type.blank?
        @user = nil
        session[:user_id] = nil
        session[:user_type] = nil
      else
        session[:user_id] = type.id
        session[:user_type] = klass_type_mapping.invert[type.class]
        @user = type
      end
    end

    def logged_in?
      current_user.present?
    end
  
    protected

    def klass_type_mapping
      {
        "admin"   => Administrator,
        "carrier" => Carrier
      }
    end

  end

end
