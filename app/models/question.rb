class Question < ApplicationRecord
  belongs_to :quiz
  has_many :options, dependent: :destroy
  has_many :answers, dependent: :destroy

  has_one_attached :image

  validates :body, presence: true
  validate :acceptable_image

  private

  def acceptable_image
    return unless image.attached?

    unless image.blob.byte_size <= 2.megabytes
      errors.add(:image, "Debe pesar menos de 2MB.")
    end

    acceptable_types = ["image/jpeg", "image/png", "image/webp"]
    unless acceptable_types.include?(image.content_type)
      errors.add(:image, "debe ser JPEG, PNG o WEBP")
    end
  end
end
