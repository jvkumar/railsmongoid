class UserSerializer < UserSimpleSerializer
  attributes :answer

  def answer
    answer_object = serialization_options[:question].answers.where(user_id: object._id).first if serialization_options[:question].is_a?(Question)
    if answer_object.present?
      answer_serializer = AnswerSerializer.new(answer_object)
      answer_serializer.serialization_options = { }
      answer_serializer.serialization_options[:loggedin_user_id] = serialization_options[:loggedin_user_id]
      answer_serializer.attributes
    end
  end
end
