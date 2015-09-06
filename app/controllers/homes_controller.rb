class HomesController < ApplicationController
  
  def index
    
  end

  def data
    filters = {
      loggedin_user_id: params[:loggedin_user_id] || nil, 
      type:             :question,
      asked_to:         params[:user_id] || nil,
      sort_by:          params[:sort_by],
      sort_order:       params[:sort_order],
      asked_by:         params[:asked_by], 
      requested_by:     params[:requested_by], 
      commented_by:     params[:commented_by], 
      liked_by:         params[:liked_by],
      page_number:      params[:page_number] || 1,
      user_status:      params[:user_status] || 'active',
      question_active:  to_bool(params[:question_active]) || true,
      answer_active:    to_bool(params[:answer_active]) || true,
      comment_active:   to_bool(params[:comment_active]) || true,
      page_number:      params[:page_number] || 1,
    }
    s = Sourcer.new filters
    render json: s.getData, loggedin_user_id: filters[:loggedin_user_id], root: false
  end

  private
  def to_bool str
    return false unless str
    str == 'true'
  end

end
