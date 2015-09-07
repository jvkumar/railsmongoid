class AnswerSerializer < ActiveModel::Serializer
  attributes :aid, :text, :like_count, :comment_count, :has_liked, :has_commented

  def aid
    object._id.to_s
  end

  def has_liked
    (object.liked_by || []).include?(serialization_options[:loggedin_user_id])
  end

  def has_commented
    object.comments.where(user_id: serialization_options[:loggedin_user_id]).count > 0
  end
end
