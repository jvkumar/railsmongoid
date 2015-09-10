class QuestionSerializer < ActiveModel::Serializer
  attributes :qid, :has_any_answer, :text, :asked_by_user, :is_answerer, :is_asker, :requested_answer, :requestor_count, :asked_to

  def qid
    object._id.to_s
  end

  def has_any_answer
    object.answers.present?
  end

  def asked_by_user
    user = serialization_options[:users].select{ |v| v._id.to_s == object.asked_by_user.to_s }.first
    UserSimpleSerializer.new(user).attributes if user
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
    serialization_options[:users].select{ |v| (object.asked_to || []).include?(v._id.to_s) }.map do |user|
      user_serializer = UserSerializer.new(user)
      user_serializer.serialization_options = serialization_options
      user_serializer.serialization_options[:question] = object
      user_serializer.attributes
    end
  end
end
