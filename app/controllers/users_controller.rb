class UsersController < ApplicationController
  
  #finds user who is object of the action
  before_action :get_user, only: [:show, :edit, :update, :destroy]
  
  #allows only logged users to do action
  before_action :logged_user, only: [:show, :edit, :update, :destroy, :index]
  
  #allows only admin to do action
  before_action :admin_auth, only: [:index]
  
  #allows only owner of the account (and admin) to do action
  before_action :owner_or_admin, only: [:edit, :update, :destroy]
  
  #allows only owner and admins to show profile
  before_action :inactive_account, only: :show
  
  #allows only active current_user to do action
  before_action :active_account, only: [:edit, :update]
  
  #allows only non logged users to do action
  before_action :no_user, only: [:new, :create]
  
  def show
    @title = I18n.t('links.crumbs.user.user', name: @user.short_name)
    @offers = @user.offers.by_show_params(params, current_or_admin?)
  end

  def index
    @title = I18n.t('links.crumbs.user.index')
    @users = User.by_search_params(params)
  end
  
  def new
    @title = I18n.t('links.crumbs.user.new')
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      redirect_to @user, flash: {success: I18n.t('flash.successful.user.creation')}
    else
      render 'new'
    end
  end

  def edit
    @title = I18n.t('links.crumbs.user.edit_user', name: @user.short_name)
  end
  
  def update
    #password change
    if @user.authenticate(params[:old_password]) && current_user?
      password_change = true
      flash[:info] = I18n.t('flash.successful.user.password_change')
    else
      password_change = false
    end
    
    if @user.update(user_params(password_change))
      flash[:success] = I18n.t('flash.successful.user.update')
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  def destroy
    log_out
    @user.destroy
    redirect_to root_path, flash: {info: I18n.t('flash.successful.user.deletion')}
  end
  
  private
  
    def user_params(password_change=true)
      if password_change
        params.require(:user).permit(:name, :region,:password, :password_confirmation)
      else
        params.require(:user).permit(:name, :region)
      end
    end
    
    def get_user
      @user = User.find_by(id: params[:id])
      if !@user
        flash[:danger] = I18n.t('flash.error.user.not_exist')
        redirect_back
      end
    end
    
    def owner_or_admin
      if !current_or_admin? @user
        flash[:danger] = I18n.t('flash.error.user.cant_do_that')
        redirect_back
      end
    end
    
    def inactive_account
      if !@user.active?
        owner_or_admin
      end
    end
  
end
