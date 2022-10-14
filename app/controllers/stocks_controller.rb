class StocksController < ApplicationController
  include ActionView::RecordIdentifier
  protect_from_forgery except: :search_stock

  def search_stock
    if params[:stock].present?
      @stock = Stock.new_lookup params[:stock]
      if @stock
        respond_to do |format|
          format.html {render partial: 'stocks/details' }
        end
      else
        respond_to do |format|
          flash.now[:alert] = 'Please enter a valid symbol'
          format.html {render partial: 'stocks/details' }
        end
      end
    else
      respond_to do |format|
        flash.now[:alert] = 'Please enter a symbol'
        format.html {render partial: 'stocks/details' }
      end
    end
  end
end
