class Stock < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :ticker, presence: true, uniqueness: true
  has_many :user_stocks
  has_many :users, through: :user_stocks

  def self.new_lookup(symbol)
    begin
      StockQuote::Stock.new(api_key: Rails.application.credentials.iex_cloud[:access_key])
      stock = StockQuote::Stock.quote symbol
      new(ticker: symbol, name: stock.company_name, last_price: stock.iex_realtime_price)
    rescue => exception
      nil
    end
  end

  def self.check_db(ticker)
    where(ticker: ticker).first
  end
end
