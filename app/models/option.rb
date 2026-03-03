class Option < ApplicationRecord
  belongs_to :question
  
  has_many :answers, dependent: :destroy

  validates :body, presence: true
  validate :only_one_correct_per_question

  private

  # Prevents adding a second correct option to the same question
  def only_one_correct_per_question
    return unless correct?
    existing = question.options.where(correct: true).where.not(id: id)
    if existing.exists?
      errors.add(:base, "Ya existe una opción correcta para esta pregunta.")
    end
  end
end
