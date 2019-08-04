require 'rails_helper'

RSpec.describe "Api::V1::Answers", type: :request do
  before do
    @user = create(:user)
  end

  describe 'GET /answers' do
    context 'With Invalid authentication headers' do
      it_behaves_like :deny_without_authorization, :get, '/api/v1/answers'
    end

    context 'With valid authentication headers' do
      before do
        @form = create(:form, user: @user)
        @answer1 = create(:answer, form: @form)
        @answer2 = create(:answer, form: @form)
        get api_v1_answers_path , params: {form_id: @form.id}, headers: header_with_authentication(@user)
      end

      it 'returns 200' do
        expect_status(200)
      end

      it "returns Form list with 2 answers" do
        expect(json.count).to eql(2)
      end

      it "returned Answers have right datas" do
        expect(json[0]).to eql(JSON.parse(@answer1.to_json))
        expect(json[1]).to eql(JSON.parse(@answer2.to_json))
      end
    end
  end
end
