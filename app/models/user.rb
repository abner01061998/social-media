class User < ApplicationRecord
  has_many :user_stocks
  has_many :stocks, through: :user_stocks
  has_many :friendships
  has_many :friends, through: :friendships
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def under_stock_limit?
    stocks.count < 10
  end

  def stock_already_tracked?(ticker)
    stock = Stock.check_db(ticker)
    return false unless stock

    stocks.where(id: stock.id).exists?
  end

  def can_track_stock?(ticker)
    under_stock_limit? && !(stock_already_tracked? ticker)
  end

  def can_add_friend?(user_id)
    !friends.where(id: user_id).exists?
  end

  def full_name
    return "#{first_name} #{last_name}" if first_name && last_name
    "Anonymous" 
  end
end
