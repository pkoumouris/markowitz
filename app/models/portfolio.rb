class Portfolio < ApplicationRecord
  belongs_to :user
  has_many :assets, dependent: :destroy
  has_many :executes, dependent: :destroy
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :title, presence: true, length: { maximum: 50 }
  validates :description, presence: true, length: { maximum: 1000 }
end
