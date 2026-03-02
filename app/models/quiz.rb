class Quiz < ApplicationRecord
  belongs_to :user
  has_many :questions, dependent: :destroy
  has_many :attempts, dependent: :destroy
  has_one_attached :image

  enum :status, { draft: 0, published: 1 }, default: :draft

  validates :title, presence: true
  validates :passing_score, numericality: { in: 1..100 }
  validate :acceptable_image
  validate :all_questions_have_correct_option, if: :published?

  private

  # Validates all questions have exactly one correct option before publishing
  def all_questions_have_correct_option
    questions.each do |question|
      correct_count = question.options.count(&:correct?)
      if question.options.count < 4
        errors.add(:base, "La pregunta '#{question.body.truncate(40)}' no tiene 4 opciones.")
      elsif correct_count != 1
        errors.add(:base, "La pregunta '#{question.body.truncate(40)}' debe tener exactamente una opción correcta.")
      end
    end
  end

  def acceptable_image
    return unless image.attached?
    unless image.blob.byte_size <= 2.megabytes
      errors.add(:image, "debe pesar menos de 2MB")
    end
    acceptable_types = ["image/jpeg", "image/png", "image/webp"]
    unless acceptable_types.include?(image.content_type)
      errors.add(:image, "debe ser JPEG, PNG o WEBP")
    end
  end
end
