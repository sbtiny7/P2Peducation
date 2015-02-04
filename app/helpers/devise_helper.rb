module DeviseHelper
  def devise_error_messages!
    resource.errors.full_messages.join(", ")
  end
end