require 'rails_helper'

RSpec.describe "Api::V1::Forms", type: :request do
  describe "GET /forms" do
    context 'With Invalid authentication headers' do
      it_behaves_like :deny_without_authorization, :get, "/api/v1/forms"
    end
  end
end
