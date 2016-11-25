class User < ApplicationRecord
  self.sync_selectors = [
      {joins: nil, where: {id: :x}}
  ]
  validates :email, presence: true, uniqueness: true
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :accounts
  has_many :credits, through: :accounts
  has_many :debits, through: :accounts
  has_many :transfers, through: :credits
end
