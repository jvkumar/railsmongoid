class Sourcer
  include ActiveModel::Model

  attr_accessor :filter 

  # :sort_by - can be one of these: time or popularity - if type is "answer" then "popularity" is defined by popularity_point in question model, but if type is "question", then "popularity" is defined by "requestor_count" in question model
  # :sort_order
  # :asked_by
  # :asked_to
  # :answerd_by
  # :requested_by 
  # :type   --- If type is answer, then return only those questions, which have at least one "status=active" answer doc
  #    --- If type is question, then return all questions, which have no "status=active" answer doc or no answer doc at all
  # :commented_by
  # :liked_by
  # :question_status 
  # :comment_status 
  # :answer_status 
  # :page_number
  # :page_offset
  # :loggedin_user_id
  
  def initialize (f = {})
    @filter = f
    setDefault
  end

  def getData
    # TODO: Write your code to return data in hash, as sample shown below
    if @filter[:type] == :answer
      questions = Question.where('answers.status': :active)
    elsif @filter[:type] == :question
      questions = Question.or( {'answers.status' => { '$ne' => :active } }, { 'answers' => { '$exists' => false } })
    else
      questions = Question.all
    end

    questions = questions.where(status: @filter[:question_status])
    questions = questions.where('answers.comments.status': @filter[:comment_status])
    questions = questions.where('answers.status': @filter[:answer_status])

    questions = questions.where(asked_to: @filter[:asked_to]) if @filter[:asked_to].present?
    questions = questions.where(asked_by_user: @filter[:asked_by]) if @filter[:asked_by].present?
    questions = questions.where(requestors: @filter[:requested_by]) if @filter[:requested_by].present?

    questions = questions.where('answers.user_id': @filter[:answerd_by]) if @filter[:answerd_by].present?
    questions = questions.where('answers.comments.user_id': @filter[:commented_by]) if @filter[:commented_by].present?
    questions = questions.where('answers.liked_by': @filter[:liked_by]) if @filter[:liked_by].present?

    if @filter[:sort_by] == :time
      questions = questions.order_by(created_at: @filter[:sort_order])
    elsif @filter[:sort_by] == :popularity
      if @filter[:type] == :answer
        questions = questions.order_by(popularity_point: @filter[:sort_order])
      elsif @filter[:type] == :question
        questions = questions.order_by(requestor_count: @filter[:sort_order])
      end
    end

    questions = questions.page(@filter[:page_number]).per(@filter[:page_offset])

    questions.map do |question|
      question_serializer = QuestionSerializer.new(question)
      question_serializer.serialization_options = {}
      question_serializer.serialization_options[:loggedin_user_id] = @filter[:loggedin_user_id]
      question_serializer.attributes
    end

    # [
    #   {
    #     "qid": "55ea003e4102135d9d000002",
    #     "has_any_answer": true,
    #     "text": "What is your name?",
    #     "asked_by_user": {
    #       "uid": "rtertertertererterer",
    #       "name": "Jennifer lookui",
    #       "username": "jcool",
    #       "avatar_image": "https://media.mongodb.org/logo-her8oer-header.png"
    #     },
    #     "is_answerer": true, # loggedin_user_id is one of the "asked_to"?
    #     "is_asker": false, # loggedin_user_id == asked_by_user ?
    #     "requested_answer": true, # loggedin_user_id is one of the "requestors"?
    #     "requestor_count": 4, 
    #     "asked_to": [
    #       {
    #         "uid": "55e7668c4102132ea8000065", # 
    #         "name": "Sophia tokan",
    #         "username": "stokan",
    #         "avatar_image": "https://media.mongodb.org/logo-mongodb-header.png",
    #         "answer": {
    #           "aid": "q424wter45345ersuhwiuwfdsfg",
    #           "text": "My name is sophia",
    #           "like_count": 21,
    #           "comment_count": 0,
    #           "has_liked": true, # loggedin_user_id liked this answer?
    #           "has_commented": false # loggedin_user_id commented on this answer?
    #         }
    #       },
    #       {
    #         "uid": "kg3435323fuwe7ir345yukwhjerl",  
    #         "name": "Laura Nanop",
    #         "username": "lnop",
    #         "avatar_image": "https://media.mongodb.org/ldfsdfr.png",
    #         "answer": {
    #           "aid": "7ir8o24uiw9eup0owe",
    #           "text": "My name is Laura",
    #           "like_count": 1,
    #           "comment_count": 0,
    #           "has_liked": false, # loggedin_user_id liked this answer?
    #           "has_commented": false # loggedin_user_id commented on this answer?
    #         }
    #       }
    #     ]
    #   },
    #   {
    #     "qid": "97845398uioruw7589304",
    #     "has_any_answer": false,
    #     "text": "What is your age?",
    #     "asked_by_user": {
    #       "uid": "3453t45645yr45t453r545",
    #       "name": "Sam Mol",
    #       "username": "smolss",
    #       "avatar_image": "https://media.mongodb.org/lrewwerwer-header.png"
    #     },
    #     "asked_to": [
    #       {
    #         "uid": "55e7668c4102132ea8000065",  
    #         "name": "Sophia tokan",
    #         "username": "stokan",
    #         "avatar_image": "https://media.mongodb.org/logo-her8oer-header.png"
    #       }
    #     ],
    #     "is_answerer": false, # loggedin_user_id is one of the "asked_to"?
    #     "is_asker": false, # loggedin_user_id == asked_by_user ?
    #     "requested_answer": false, # loggedin_user_id is one of the "requestors"?
    #     "requestor_count": 4
    #   }
    # ]

  end



  private

  def setDefault
    @filter[:type]                    = sanitize :type
    @filter[:sort_by]                 = sanitize :sort_by
    @filter[:sort_order]              = sanitize :sort_order
    @filter[:question_status]         = sanitize :question_status
    @filter[:comment_status]          = sanitize :comment_status
    @filter[:answer_status]           = sanitize :answer_status
    # @filter[:asked_by_user_status]    = sanitize :asked_by_user_status
    # @filter[:asked_to_user_status]    = sanitize :asked_to_user_status
    # @filter[:answerd_by_user_status]  = sanitize :answerd_by_user_status

    @filter[:page_number]             = @filter[:page_number].present?      ? @filter[:page_number].to_i : 1
    @filter[:page_offset]             = @filter[:page_offset].present?      ? @filter[:page_offset].to_i : 10
    @filter[:asked_to]                = @filter[:asked_to].present?         ? @filter[:asked_to] : nil
    @filter[:asked_by]                = @filter[:asked_by].present?         ? @filter[:asked_by] : nil
    @filter[:answerd_by]              = @filter[:answerd_by].present?       ? @filter[:answerd_by] : nil
    @filter[:requested_by]            = @filter[:requested_by].present?     ? @filter[:requested_by] : nil
    @filter[:commented_by]            = @filter[:commented_by].present?     ? @filter[:commented_by] : nil
    @filter[:liked_by]                = @filter[:liked_by].present?         ? @filter[:liked_by] : nil

    @filter[:loggedin_user_id] = @filter[:loggedin_user_id]
  end

  def sanitize key
    case key
    when :type
      ([:answer, :question].include? @filter[key]) ? @filter[key] : :answer
    when :sort_by
      ([:time, :popularity].include? @filter[key]) ? @filter[key] : :time
    when :sort_order
      ([:asc, :desc].include? @filter[key]) ? @filter[key] : :desc
    # when :asked_by_user_status, :asked_to_user_status, :answerd_by_user_status
    #   ([:active, :inactive].include? @filter[key]) ? @filter[key] : :active
    when :question_status, :comment_status, :answer_status
      (["active", "inactive", "deleted"].include? @filter[key]) ? @filter[key] : "active"
    end
  end

end
