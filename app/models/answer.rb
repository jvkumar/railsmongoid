class Answer
  include Mongoid::Document
  include Mongoid::Timestamps

  field :text,  type: String
  field :like_count,  type: Integer
  field :liked_by,  type: Array, default: []
  field :comment_count,  type: Integer
  field :active, default: true
  field :user_id, type: String
  
  validates_presence_of :user_id

  embeds_many :comments
  embedded_in :question
  
  def getQuestionObject
    Question.where('answers._id': id).first rescue nil
  end

end 