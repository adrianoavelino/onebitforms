class Api::V1::FormsController < Api::V1::ApiController
  before_action :authenticate_api_v1_user!
  before_action :set_form, only: [:show, :update, :destroy]
  before_action :allow_only_owner, only: [:update, :destroy]

  def index
    @forms = Form.all
    render json: @forms.to_json
  end

  def show
    render json: @form
  end

  def update
    if @form.update(form_params)
      render json: @form
    end
  end

  def create
    @form = Form.new(form_params)
    if @form.save
      render json: @form
    end
  end

  def destroy
    @form.destroy
    render json: {message: 'ok'}
  end

  private
  def set_form
    @form = Form.friendly.find(params[:id])
  end

  def allow_only_owner
    unless current_api_v1_user == @form.user
      render(json: {}, status: :forbidden) and return
    end
  end

  def form_params
    params.require(:form).permit(:title, :description, :enable, :primary_color).merge(user: current_api_v1_user)
  end
end
