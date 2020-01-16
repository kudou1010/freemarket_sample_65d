class MyPageController < ApplicationController
  before_action :authenticate_user!
  def index
    binding.pry
    @items = Item.where(user_id: current_user.id)
  end
  
end
