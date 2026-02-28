class Quiz < ApplicationRecord
  belongs_to: user

  has_many: questions, dependent: destroy # If the quizz is destroyed, then questions get deleted 
  has_many: attempts, dependent: destroy

  enum :status, { draft: 0, published: 1 }, default: :draft

  validates :title, presence: true
  validates :passing_score, numericality: { in: 1..100 }

end
