class User
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name,  type: String
  field :user_name,  type: String
  field :status,   type: String, default: "active""avtar_image"
  field :avatar_image,   type: String

  validates_presence_of :user_name

  has_many :questions
end
