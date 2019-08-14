class Api::V1::AnswersController < Api::V1::ApiController
  before_action :authenticate_api_v1_user!
  before_action :set_answer, only: [:show]
  before_action :set_form

  def index
    @answers = @form.answers
    render json: @answers.to_json, include: 'questions_answers'
  end

  def show
    render json: @answer, include: 'questions_answers'
  end

  def create
  end

  def destroy
  end

  private
  def set_answer
    @answer = Answer.find(params[:id])
  end

  def set_form
    @form = (@answer) ? @answer.form : Form.find(params[:form_id])
  end
end
