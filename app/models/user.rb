class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum :role, { player: 0, admin: 1 }, default: :player

  has_many :quizzes, dependent: :destroy
  has_many :attempts, dependent: :destroy

  validates :first_name, presence: true
  validates :last_name, presence: true

end
