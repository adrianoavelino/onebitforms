class Api::V1::FormsController < ApplicationController
  before_action :authenticate_api_v1_user!

  def index
    @forms = Form.all
    # byebug
    render json: @forms.to_json
  end

  def show
  end

  def update
  end

  def create
  end

  def destroy
  end
end
