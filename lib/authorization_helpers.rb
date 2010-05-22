module AuthorizationHelpers
  extend ActiveSupport::Concern

  included do
    helper_method :carrier?, :admin?, :user_type?
  end

  module ClassMethods

    def ensure_user_type!(*args)
      options = args.extract_options!
      before_filter(options) do |controller|
        controller.send(:ensure_user_type!, *args)
      end
    end

  end

  module InstanceMethods
    
    def ensure_user_type!(*args)
      if !user_type?(*args)
        flash[:error] = "You are currently not logged in as a valid user type."
        redirect_to :"#{args.first}_login"
        return false
      end
    end

    def user_type?(*args)
      logged_in? && args.map { |m| current_user.try(:"#{m}?") }.any?
    end

    def admin?
      user_type? :admin
    end

    def carrier?
      user_type? :carrier
    end

  end

end
