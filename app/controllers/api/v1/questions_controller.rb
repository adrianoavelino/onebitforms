class Api::V1::QuestionsController < Api::V1::ApiController
  before_action :authenticate_api_v1_user!
  before_action :set_question, only: [:update, :destroy]
  before_action :set_form
  before_action :allow_only_owner, only: [:update, :destroy]

  def create
    @question = Question.new(question_params.merge(form: @form))
    if @question.save
      render json: @question
    end
  end

  def update
    if @question.update(question_params)
      render json: @question
    end
  end

  def destroy
    if @question.destroy
      render json: {message: 'ok'}
    end
  end

  private
  def allow_only_owner
    unless current_api_v1_user == @form.user
      render(json: {}, status: :forbidden) and return
    end
  end

  def set_question
    @question = Question.find(params[:id])
  end
  def set_form
    @form = (@question)? @question.form : Form.find(params[:form_id])
  end

  def question_params
    params.require(:question).permit(:title, :kind)
  end
end
