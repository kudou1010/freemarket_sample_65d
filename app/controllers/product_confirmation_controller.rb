class ProductConfirmationController < ApplicationController
  before_action :authenticate_user!
  before_action :set_item, only: :index
  before_action :set_user, only: :index
  before_action :set_card, only: :index
  before_action :check_user, only: :index
  before_action :check_sold_out, only: :index

  def index
  end

  def set_item
    @item = Item.find(params[:item_id])
    @image = Image.find_by(item_id: @item.id)
  end

  def set_user
    @user = User.find(current_user.id)
    @address = Address.find_by(user_id: @user.id)
    @prefecture = Prefecture.find(@address.prefectures)
  end

  def set_card
    @card = Card.find_by(user_id: current_user.id)
    if @card.blank?
      # redirect_to action: "new" 
    else
      Payjp.api_key = Rails.application.credentials.dig(:payjp, :PAYJP_SECRET_KEY)
      customer = Payjp::Customer.retrieve(@card.customer_id)
      @default_card_information = customer.cards.retrieve(@card.card_id)
    end
  end

  def check_user
    if @item.user_id == current_user.id
      redirect_to root_path
    end
  end

  def check_sold_out
    if @item.sale_status == "sold_out"
      redirect_to root_path
    end
  end
  
end
