class Post < ApplicationRecord
  belongs_to :user

  has_one_attached :image

  validates :image, presence: true
  validates :description, presence: true

  def get_image
    image.variant(gravity: :center, resize:"170x170^", crop:"170x170+0+0").processed
  end
end
