class QuestionSerializer < ActiveModel::Serializer
  attributes :qid, :has_any_answer, :text, :asked_by_user, :is_answerer, :is_asker, :requested_answer, :requestor_count, :asked_to

  def qid
    object._id.to_s
  end

  def has_any_answer
    object.answers.present?
  end

  def asked_by_user
    UserSimpleSerializer.new(object.user).attributes if object.user
  end

  def is_answerer
    (object.asked_to || []).include?(serialization_options[:loggedin_user_id])
  end

  def is_asker
    object.asked_by_user.to_s == serialization_options[:loggedin_user_id]
  end

  def requested_answer
    (object.requestors || []).include?(serialization_options[:loggedin_user_id])
  end

  def asked_to
    User.where(id: {'$in': (object.asked_to || [])}).map do |user|
      user_serializer = UserSerializer.new(user)
      user_serializer.serialization_options = serialization_options
      user_serializer.serialization_options[:question] = object
      user_serializer.attributes
    end
  end
end
