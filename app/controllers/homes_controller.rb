class HomesController < ApplicationController
  
  def index
    
  end

  def data
    filters = {
      loggedin_user_id:         params[:loggedin_user_id] || nil, 
      type:                     :question,
      asked_to:                 params[:user_id] || nil,
      sort_by:                  params[:sort_by],
      sort_order:               params[:sort_order],
      asked_by:                 params[:asked_by], 
      requested_by:             params[:requested_by], 
      commented_by:             params[:commented_by], 
      liked_by:                 params[:liked_by],
      page_number:              params[:page_number] || 1,
      page_offset:              params[:page_offset] || 10,
      # asked_by_user_status:     params[:asked_by_user_status] || 'active',
      # asked_to_user_status:     params[:asked_to_user_status] || 'active',
      # answerd_by_user_status:   params[:answerd_by_user_status] || 'active',
      question_status:          params[:question_active] || 'active',
      answer_status:            params[:answer_active] || 'active',
      comment_status:           params[:comment_active] || 'active',
    }
    
    s = Sourcer.new filters
    render json: s.getData, root: false
  end

  private

end
