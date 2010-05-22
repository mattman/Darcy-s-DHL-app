module AuthorizationHelpers
  extend ActiveSupport::Concern

  module ClassMethods

    def ensure_user_type!(*args)
      options = args.extract_options!
      before_filter(options) do
        controller.send(:ensure_user_type!, args)
      end
    end

  end

  module InstanceMethods
    
    def ensure_user_type!(*args)
      if user_type?(*args)
      else
        redirect_to :root, :error => "You are currently not logged in as a valid user type."
        return false
      end
    end

    def user_type?(*args)
      logged_in? && args.map { |m| current_user.try(:"#{m}?") }
    end

    def admin?
      user_type? :admin
    end

    def carrier?
      user_type? :carrier
    end

  end

end
