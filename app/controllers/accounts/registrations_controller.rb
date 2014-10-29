class Accounts::RegistrationsController < Devise::RegistrationsController
    prepend_before_filter :require_no_authentication, only: [ :new, :create, :cancel ]
    prepend_before_filter :authenticate_scope!, only: [:edit, :update, :destroy]

    layout :set_layout

    private

    def set_layout
        if action_name == "edit"
            return 'accounts'
        end
    end
end