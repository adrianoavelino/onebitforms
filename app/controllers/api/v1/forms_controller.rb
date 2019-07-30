class Api::V1::FormsController < Api::V1::ApiController
  before_action :authenticate_api_v1_user!

  def index
    @forms = Form.all
    # byebug
    render json: @forms.to_json
  end

  def show
    @form = Form.friendly.find(params[:id])
    render json: @form
  end

  def update
  end

  def create
  end

  def destroy
  end
end
