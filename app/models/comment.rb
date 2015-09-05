class Comment
  include Mongoid::Document
  include Mongoid::Timestamps

  field :text,  type: String
  field :active, default: true
  field :user_id, type: String
  
  validates_presence_of :user_id

  embedded_in :answer
end