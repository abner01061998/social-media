class Stock < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :ticker, presence: true, uniqueness: true

  def self.new_lookup(symbol)
    StockQuote::Stock.new(api_key: Rails.application.credentials.iex_cloud[:access_key])
    StockQuote::Stock.quote symbol
  end
end
