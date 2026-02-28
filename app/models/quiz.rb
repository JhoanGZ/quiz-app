class Quiz < ApplicationRecord
  belongs_to :user

  has_many :questions, dependent: :destroy
  has_many :attempts, dependent: :destroy

  has_one_attached :image

  enum :status, { draft: 0, published: 1 }, default: :draft

  validates :title, presence: true
  validates :passing_score, numericality: { in: 1..100 }
  validate :acceptable_image

  private

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
