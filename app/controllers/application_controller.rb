class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  include SessionsHelper
  
  def get_current
    @current_user = current_user
  end
  
  def no_user
    if logged_in?
      flash[:danger] = I18n.t('flash.error.logged')
      # temporary redirect should redirect back
      redirect_to root_path
    end
  end
  
  def admin_auth
    if current_user.nil? || !current_user.admin?
      flash[:danger] = I18n.t('flash.error.user_not_admin')
      redirect_to root_path
    end
  end
  
end
