class UserStocksController < ApplicationController
  before_action :user_stocks

  def create
    stock = Stock.check_db user_stock_params[:ticker] 
    stock = Stock.new_lookup(user_stock_params[:ticker]) if stock.blank?
    stock.save if stock.blank?

    respond_to do |format|
      if !current_user.stock_already_tracked?(user_stock_params[:ticker])
        UserStock.create user: current_user, stock: stock
        flash.now[:success] = 'Stock added'
      else
        flash.now[:alert] = 'Stock already tracked'
      end
      format.html { render partial: 'list', locals: { user: @user} }
      # render turbo_stream: turbo_stream.replace("post_hidden_fields", partial: "home/update_post_form", locals: {post_type: params[:post_type], url: params[:url]})
    end
  end

  def destroy
    respond_to do |format|
      if UserStock.where(stock_id: params[:id], user_id: current_user.id).delete_all
        flash.now[:notice] = 'Stock deleted'
      else
        flash.now[:notice] = 'Stock can not be deleted'
      end
      format.html { render partial: 'list', locals: { user: @user} }
    end
  end

  private
  def user_stock_params
    params.permit(:user, :ticker)
  end

  def user_stocks
    if params[:user] && current_user.id != params[:user]
      @stocks = User.find(params[:user]).stocks
      @user   = params[:user]
    else
      @stocks = current_user.stocks
      @user   = current_user.id
    end
  end
end
