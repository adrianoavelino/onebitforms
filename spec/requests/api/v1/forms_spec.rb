require 'rails_helper'

RSpec.describe "Api::V1::Forms", type: :request do
  describe "GET /forms" do
    context 'With Invalid authentication headers' do
      it_behaves_like :deny_without_authorization, :get, "/api/v1/forms"
    end

    context 'With Valid authentication headers' do
      it 'returns 200' do
        @user = create(:user)
        get '/api/v1/forms', params: {}, headers: header_with_authentication(@user)
        expect_status(200)
      end

      it 'returns Form list with 2 forms' do
        @user = create(:user)
        create(:form)
        create(:form)
        get '/api/v1/forms', params: {}, headers: header_with_authentication(@user)
        expect(json.count).to eql(2)
      end

      it 'returns Forms with right data' do
        @user = create(:user)
        @form1 = create(:form)
        @form2 = create(:form)
        get '/api/v1/forms', params: {}, headers: header_with_authentication(@user)
        expect(json[0]).to eql(JSON.parse(@form1.to_json))
        expect(json[1]).to eql(JSON.parse(@form2.to_json))
      end
    end
  end

  describe 'GET /forms/:friendly_id' do
    before do
      @user = create(:user)
    end

    context 'When form exists' do
      context 'And is enable' do
        before do
          @form = create(:form, user: @user, enable: true)
        end

        it 'returns 200' do
          get "/api/v1/forms/#{@form.friendly_id}", params: {}, headers: header_with_authentication(@user)
          expect_status(200)
        end

        it 'returns Form with right data' do
          get "/api/v1/forms/#{@form.friendly_id}", params: {}, headers: header_with_authentication(@user)
          expect(json).to eql(JSON.parse(@form.to_json))
        end
      end

      context 'And is unable' do
        before do
          @form = create(:form, user: @user, enable: false)
        end

        it "returns 404" do
          get "/api/v1/forms/#{FFaker::Lorem.word}", params: {id: @form.friendly_id}, headers: header_with_authentication(@user)
          expect_status(404)
        end
      end

      context "When form dont exists" do
        it "returns 404" do
          get "/api/v1/forms/#{FFaker::Lorem.word}", params: {}, headers: header_with_authentication(@user)
          expect_status(404)
        end
      end
    end
  end

  describe 'POST /forms' do
    context 'With Invalid authentication headers' do
      it_behaves_like :deny_without_authorization, :post, "/api/v1/forms"
    end

    context 'With valid authentication headers' do
      before do
        @user = create(:user)
      end

      context 'And with valid params' do
        before do
          @form_attributes = attributes_for(:form)
          post "/api/v1/forms", params: {form: @form_attributes}, headers: header_with_authentication(@user)
        end

        it 'returns 200' do
          expect_status(200)
        end

        it "form are created with correct data" do
          @form_attributes.each do |field|
            expect(Form.first[field.first]).to eql(field.last)
          end
        end

        it "Returned data is correct" do
          @form_attributes.each do |field|
            expect(json[field.first.to_s]).to eql(field.last)
          end
        end
      end

      context "And with invalid params" do
        before do
          @other_user = create(:user)
          post "/api/v1/forms", params: {form: {}}, headers: header_with_authentication(@user)
        end

        it "returns 400" do
          expect_status(400)
        end
      end
    end
  end
end
