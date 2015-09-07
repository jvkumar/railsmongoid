class Comment
  include Mongoid::Document
  include Mongoid::Timestamps

  field :text,  type: String
  field :status, type: String, default: "active"
  field :user_id, type: String
  
  validates_presence_of :user_id

  embedded_in :answer
end