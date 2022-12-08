class Post < ApplicationRecord
  belongs_to :user
  has_many :post_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy

  has_one_attached :image

  validates :image, presence: true
  validates :description, presence: true

  def get_image
    image.variant(gravity: :center, resize:"170x170^", crop:"170x170+0+0").processed
  end

  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

  def self.search_for(content)
    Post.where("description LIKE ?", "%" + content + "%")
  end
end
