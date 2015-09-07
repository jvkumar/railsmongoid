class UserSerializer < UserSimpleSerializer
  attributes :answer

  def answer
    answer_object = serialization_options[:question].answers.where(user_id: object._id).first if serialization_options[:question].is_a?(Question)
    if answer_object.present?
      AnswerSerializer.new(answer_object).attributes
    end
  end
end
