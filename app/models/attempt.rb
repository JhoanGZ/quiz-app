class Attempt < ApplicationRecord
  belongs_to :user
  belongs_to :quiz

  has_many :answers, dependent: :destroy

  validates :user_id, uniqueness: { scope: :quiz_id }

  validate :quiz_must_be_published, on: :create
  validate :cannot_modify_completed, on: :update

  private

  def quiz_must_be_published
    errors.add(:quiz, "no está disponible") unless quiz&.published?
  end

  def cannot_modify_completed
    errors.add(:base, "Este intento ya fue completado") if completed_at_was.present?
  end
end
