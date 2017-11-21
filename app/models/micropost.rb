class Micropost < ApplicationRecord
  belongs_to :user

  #時間降順に並ぶように
  default_scope -> {order(created_at: :desc)}

  #アップローダを紐付け
  mount_uploader :picture, PictureUploader

  validates :user_id, presence:true
  validates :content, presence:true, length:{maximum: 140}
end
