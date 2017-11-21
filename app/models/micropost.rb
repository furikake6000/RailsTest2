class Micropost < ApplicationRecord
  belongs_to :user

  #時間降順に並ぶように
  default_scope -> {order(created_at: :desc)}

  #アップローダを紐付け
  mount_uploader :picture, PictureUploader

  validates :user_id, presence:true
  validates :content, presence:true, length:{maximum: 140}
  validate :picture_size

  private
    def picture_size
      errors.add(:picture, "File is too heavy!") if picture.size > 5.megabytes
    end
end
