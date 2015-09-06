class UserSerializer < UserSimpleSerializer
  attributes :answer

  def answer
    serialization_options[:question].answers.where(user_id: object._id).first if serialization_options[:question].is_a?(Question)
  end
end
