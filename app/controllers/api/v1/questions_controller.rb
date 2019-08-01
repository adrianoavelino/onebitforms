class Api::V1::QuestionsController < Api::V1::ApiController
  before_action :authenticate_api_v1_user!
  before_action :set_form

  def create
    @question = Question.new(question_params.merge(form: @form))
    if @question.save
      render json: @question
    end
  end

  def update
  end

  def destroy
  end

  private
  def set_form
    @form = (@question)? @question.form : Form.find(params[:form_id])
  end

  def question_params
    params.require(:question).permit(:title, :kind)
  end
end
