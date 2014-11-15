class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  rescue_from ActiveRecord::RecordNotFound, :with => :redirect_to_not_found
  protect_from_forgery with: :null_session

  before_action :authenticate_user_from_token!
  before_action :configure_permitted_parameters, if: :devise_controller?
  after_action :clean_notice

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :username
  end

  def check_admin
    if current_user and current_user.has_role?(:admin)
    else
      redirect_to root_path
    end
  end

  def check_teacher
    logger.info current_user.inspect
    if current_user and current_user.is_teacher?
    elsif current_user
      redirect_to accounts_root_path
    else
      redirect_to root_path
    end
  end

  def clean_notice
    flash[:notice] = nil
  end

  def check_token
    if session[:__token__] == params[:__token__]
      session[:__token__] = nil
      # session.update
      return true
    end
    false
  end

  private
  def redirect_to_not_found
    render text: '没有找到数据', status: 400
  end
  def authenticate_user_from_token!
      user_token = params[:user_token].presence
      user       = user_token && User.find_by_authentication_token(user_token.to_s)
      if user
          # Notice we are passing store false, so the user is not
          # actually stored in the session and a token is needed
          # for every request. If you want the token to work as a
          # sign in token, you can simply remove store: false.
          sign_in user, store: false
      else
          Rails.logger.info "Token Auth faile"
      end
  end

end
