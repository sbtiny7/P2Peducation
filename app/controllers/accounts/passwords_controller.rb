class Accounts::PasswordsController < Devise::PasswordsController
  prepend_before_filter :require_no_authentication
  append_before_filter :assert_reset_token_passed, only: :edit
end