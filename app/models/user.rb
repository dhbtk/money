class User < ApplicationRecord
  self.sync_selectors = [
      {joins: nil, where: {id: :x}}
  ]
  validates :email, presence: true, uniqueness: true
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :accounts, -> { order(:name) }
  has_many :billing_accounts, -> { order(:name) }
  has_many :bills, through: :billing_accounts
  has_many :tags, -> { order(:name) }
  has_many :credits, -> { order(date: :desc, created_at: :desc) }, through: :accounts 
  has_many :debits, -> { order(date: :desc, created_at: :desc) }, through: :accounts
  has_many :statements, -> { order(date: :desc, created_at: :desc) }, through: :accounts
  has_many :transfers, -> { order(created_at: :desc) }, through: :credits
end
