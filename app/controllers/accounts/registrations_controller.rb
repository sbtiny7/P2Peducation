class Accounts::RegistrationsController < Devise::RegistrationsController
    prepend_before_filter :require_no_authentication, only: [ :new, :create, :cancel ]
    prepend_before_filter :authenticate_scope!, only: [:edit, :update, :destroy]


    private

    def set_layout
        if ["edit", "update"].include? action_name
            return 'accounts'
        else
          return 'devise'
        end
    end
end
