class Api::V1::AnswersController < Api::V1::ApiController
  before_action :authenticate_api_v1_user!
  before_action :set_form

  def index
    @answers = @form.answers
    render json: @answers.to_json, include: 'questions_answers'
  end

  def show
  end

  def create
  end

  def destroy
  end

  private
  def set_form
    @form = (@answer) ? @answer.form : Form.find(params[:form_id])
  end
end
