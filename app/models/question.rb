class Question
  include Mongoid::Document
  include Mongoid::Timestamps

  field :text,  type: String
  field :asked_to,  type: Array, default: [] # Id of the asker who asked this question
  field :requestor_count,  type: Integer # How many people have requested answer of this question, apart from asker
  field :requestors,  type: Array, default: [] # Ids of users who also want answer of this question, apart from asker
  field :active, default: true

  belongs_to :user, foreign_key: :asked_by_user 

  validates_presence_of :text
  validates_presence_of :asked_by_user
  validates_presence_of :asked_to

  embeds_many :answers

end


# Sample Question Document

# { 
#   "_id" : ObjectId( "55ea003e4102135d9d000002" ),
#   "asked_to" : [ 
#     "55e7668c4102132ea8000065", 
#     "55e7668c4102132ea8000066", 
#     "55e7668c4102132ea8000067" ],
#   "requestor_count" : 2,
#   "requestors" : ["55e7668c4102132ea800wewr", "khfguw7iyruehfgweiry7263"],
#   "active" : true,
#   "asked_by_user" : ObjectId( "55e766b14102132ea8000097" ),
#   "text" : "What is your name?",
#   "updated_at" : Date( 1441398846696 ),
#   "created_at" : Date( 1441398846696 ),
#   "answers" : [ 
#     { "_id" : ObjectId( "55ea06b54102135d9d000003" ),
#       "text" : "My name is John",
#       "like_count" : 1,
#       "comment_count" : 0,
#       "popularity_point": 1,
#       "liked_by" : ["duhfi87238993jhfukhdhfu"],
#       "active" : true,
#       "user_id" : "55e7668c4102132ea8000065",
#       "updated_at" : Date( 1441400501867 ),
#       "created_at" : Date( 1441400501867 )
#     }, 
#     { "_id" : ObjectId( "55ea06b54102135d9d000004" ),
#       "text" : "My name is Lisa",
#       "like_count" : 0,
#       "comment_count" : 2,
#       "popularity_point": 2,
#       "liked_by" : [],
#       "active" : false,
#       "user_id" : "55e7668c4102132ea8000066",
#       "updated_at" : Date( 1441400501867 ),
#       "created_at" : Date( 1441400501867 ),
#       "comments" : [ 
#         { "_id" : ObjectId( "7y87773789587uy783345" ),
#           "text" : "I like your name",
#           "active" : true,
#           "user_id" : "877478hj9828h87286987",
#           "updated_at" : Date( 1441400501867 ),
#           "created_at" : Date( 1441400501867 )
#         },
#         { "_id" : ObjectId( "65879829029745y78yiu8" ),
#           "text" : "Your name is so cool",
#           "active" : true,
#           "user_id" : "f8734yiw673y49389wr27987",
#           "updated_at" : Date( 1441400501867 ),
#           "created_at" : Date( 1441400501867 )
#         }
#       ]
#     } 
#   ] 
# }



# Sample User Document

# { 
#   "_id" : ObjectId( "55e7668c4102132ea8000065" ),
#   "name": "Tomy hilson",
#   "username" : "coolkat",
#   "avatar_image": "http://xyz.com/myimage.jpg",
#   "active" : true,
#   "updated_at" : Date( 1441400501867 ),
#   "created_at" : Date( 1441400501867 )
# }
