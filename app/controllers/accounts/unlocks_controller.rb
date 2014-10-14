class Account::UnlocksController < Devise::UnlocksController
    prepend_before_filter :require_no_authentication
end