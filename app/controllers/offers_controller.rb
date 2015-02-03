class OffersController < ApplicationController
  
  #finds out who is current and sets to @current_user
  before_action :get_current
  
  #finds offert which is object of the action
  before_action :get_offer, only: [:show, :edit, :update, :destroy, :renew, :close, :accept]
  
  #finds user who is object of the action
  before_action :get_user, only: [:show, :edit, :update, :destroy, :renew, :close, :accept]
  
  #allows only owner of the account and admin to do action
  before_action :owner_user, only: [:edit, :update, :destroy, :close]
  
  #allows only owner to do action
  before_action :only_owner, only: :renew
  
  before_action :logged_user, only: [:new, :create]
  
  #allows only admin to do action
  before_action :admin_auth, only: :accept
  
  def show
    
  end

  def index
    @offers = Offer.by_search_params(params, admin?)
  end

  def new
    @offer = @current_user.offers.new
  end
  
  def create
    @offer = @current_user.offers.new(offer_params)
    @offer.status_id = 0
    if @offer.save
      redirect_to @offer, flash: {success: I18n.t('flash.successful.offer.creation')}
    else
      render 'new'
    end
  end

  def edit
    
  end
  
  def update
    if @offer.update(offer_params)
      @offer.status_id = 0
      redirect_to @offer, flash: {success: I18n.t('flash.successful.offer.edition')}
    else
      render 'edit'
    end
  end
  
  def destroy
    @offer.destroy
    redirect_to @user, flash: {info: I18n.t('flash.successful.offer.deletion')}
  end
  
  def renew
    @offer.make_pending
    redirect_to @offer, flash: {info: I18n.t('flash.successful.offer.renewation')}
  end
  
  def close
    @offer.close
    redirect_to @offer, flash: {info: I18n.t('flash.successful.offer.close')}
  end
  
  def accept
    @offer.accept
    redirect_to @offer, flash: {info: I18n.t('flash.successful.offer.acceptation')}
  end

  
  private
  
    def offer_params
      params.require(:offer).permit(:title, :valid_until, :category_id, :content)
    end
  
    def get_offer
      @offer = Offer.find_by(id: params[:id])
    end
    
    def owner_user
      if !current_or_admin?
        flash[:danger] = I18n.t('flash.error.user.not_owner')
        # temporary redirect should redirect to prev location
        redirect_to root_path
      end
    end
    
    def only_owner
      if !current_user?
        flash[:danger] = I18n.t('flash.error.user.not_owner')
        # temporary redirect should redirect to prev location
        redirect_to root_path
      end
    end
    
    def get_user
      @user = @offer.owner
    end
end