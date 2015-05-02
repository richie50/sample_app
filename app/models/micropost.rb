class Micropost < ActiveRecord::Base
  attr_accessible :content
  validates :user_id , presence: true 
  validates :content, presence: true, length: {maximum: 140}
  # Database association
  belongs_to :user
  # ordering of post
  default_scope order: 'microposts.created_at DESC'
end
