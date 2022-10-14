class UsersController < ApplicationController
  layout 'application'
  def my_portfolio
    @stocks = current_user.stocks
  end

  def friends_portfolio
    @stocks = User.find(params[:id]).stocks
    respond_to do |format|
      format.html { render partial: 'user_stocks/list', locals: { user: params[:id] } }
    end
  end

  def show
    @user = User.find(params[:user])
  end
end
