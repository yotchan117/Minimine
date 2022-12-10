class Post < ApplicationRecord
  belongs_to :user
  has_many :post_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags

  has_one_attached :image

  validates :image, presence: true
  validates :description, presence: true

  def get_image
    image.variant(gravity: :center, resize:"170x170^", crop:"170x170+0+0").processed
  end

  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

  def save_tags(savepost_tags)
    current_tags = self.tags.pluck(:name) unless self.tags.nil?
    old_tags = current_tags - savepost_tags
    new_tags = savepost_tags - current_tags

    old_tags.each do |old_name|
      self.tags.delete Tag.find_by(name: old_name)
    end

    new_tags.each do |new_name|
      post_tag = Tag.find_or_create_by(name: new_name)
      self.tags << post_tag
    end
  end

  def self.search_for(content)
    Post.where("description LIKE ?", "%" + content + "%")
  end
end
