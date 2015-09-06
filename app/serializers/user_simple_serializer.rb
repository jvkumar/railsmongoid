class UserSimpleSerializer < ActiveModel::Serializer
  attributes :uid, :name, :username, :avatar_image

  def uid
    object._id.to_s
  end

  def username
    object.user_name
  end
end
