class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  rescue_from ActiveRecord::RecordNotFound, :with => :redirect_to_not_found
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
end
