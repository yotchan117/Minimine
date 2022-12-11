class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts, dependent: :destroy
  has_many :post_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy

  # 自分がフォローする（与フォロー）側の関係性
  has_many :relationships, class_name: "Relationship", foreign_key: :follower_id, dependent: :destroy
  # 自分がフォローされる（被フォロー）側の関係性
  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: :followed_id, dependent: :destroy

  # 与フォロー関係を通じて参照→自分がフォローしている人
  has_many :followings, through: :relationships, source: :followed
  # 被フォロー関係を通じて参照→自分をフォローしている人
  has_many :followers, through: :reverse_of_relationships, source: :follower

  #　自分が通知を送る側
  has_many :notifications, class_name: "Notification", foreign_key: "visitor_id", dependent: :destroy
  #　自分が通知を送られる側
  has_many :reverse_of_notifications, class_name: "Notification", foreign_key: "visited_id", dependent: :destroy


  has_one_attached :profile_image

  validates :email, presence: true
  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true
  validates :introduction, length: { maximum: 100 }

  def get_profile_image
    unless profile_image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpeg')
      profile_image.attach(io: File.open(file_path), filename: 'default-image.jpeg', content_type: 'image/jpeg')
    end
    profile_image.variant(gravity: :center, resize:"150x150^", crop:"150x150+0+0").processed
  end

  def follow(user)
    relationships.create(followed_id: user.id)
  end

  def unfollow(user)
    relationships.find_by(followed_id: user.id).destroy
  end

  def following?(user)
    followings.include?(user)
  end

  def self.search_for(content)
    User.where("name LIKE ?", "%" + content + "%")
  end

  def self.guest
    find_or_create_by!(name: "guestuser", email: "guest@guest.com") do |user|
      user.password = SecureRandom.urlsafe_base64
      user.name = "guestuser"
    end
  end

  def create_notification_follow!(current_user)
    temp = Notification.where(["visitor_id = ? and visited_id = ? and action = ?", current_user.id, id, "follow"])
    if temp.blank?
      notification = current_user.notifications.new(
        visited_id: id,
        action: "follow"
      )
      notification.save if notification.valid?
    end
  end
end
