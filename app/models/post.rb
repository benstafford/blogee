class Post < ActiveRecord::Base
  has_many :comments
  belongs_to :user

  mount_uploader :asset, AssetUploader

  validates :title, :presence => true
  validates :content, :presence => true
end
