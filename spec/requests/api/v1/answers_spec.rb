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

  describe 'GET /answers/:id' do
    before do
      @user = create(:user)
    end

    context 'With invalid authentication headers' do
      it_behaves_like :deny_without_authorization, :get, '/api/v1/answers/0'
    end

    context 'With valid authentication headers' do
      context 'When answers exists' do
        before do
          @form = create(:form, user: @user)
          @answer = create(:answer, form: @form)
          @questions_answers_1 = create(:questions_answer, answer: @answer)
          @questions_answers_2 = create(:questions_answer, answer: @answer)
          get "/api/v1/answers/#{@answer.id}", params: {}, headers: header_with_authentication(@user)
        end

        it "returns 200" do
          expect_status(200)
        end

        it "returned Answer with right datas" do
          expect(json.except("questions_answers")).to eql(JSON.parse(@answer.to_json))
        end

        it 'returns Answers with right datas' do
          expect(json['questions_answers'].first).to eql(JSON.parse(@questions_answers_1.to_json))
          expect(json['questions_answers'].last).to eql(JSON.parse(@questions_answers_2.to_json))
        end
      end

      context 'When answer dont exists' do
        it 'returns 404' do
          get "/api/v1/answers/#{FFaker::Lorem.word}", params: {}, headers: header_with_authentication(@user)
          expect_status(404)
        end
      end
    end
  end

  describe 'POST /answers' do
    context 'With invalid authentication headers' do
      it_behaves_like :deny_without_authorization, :post, '/api/v1/answers'
    end

    context 'With valid authentication headers' do
      context 'And with valid form id' do
        before do
          @form = create(:form, user: @user)
          @question = create(:question, form: @form)
          @questions_answers_1_attributes = attributes_for(:questions_answer, question_id: @question.id)
          @questions_answers_2_attributes = attributes_for(:questions_answer, question_id: @question.id)
          post '/api/v1/answers', params: {form_id: @form.id, questions_answers: [@questions_answers_1_attributes, @questions_answers_2_attributes]}, headers: header_with_authentication(@user)
          expect_status(200)
        end

        it 'returns 200' do
        end

        it 'answer are associated with correct form' do
          expect(@form).to eql(Answer.last.form)
        end

        it 'questions answers are assocated' do
          expect(json["id"]).to eql(QuestionsAnswer.first.answer.id)
          expect(json["id"]).to eql(QuestionsAnswer.last.answer.id)
        end
      end
    end

    context 'And with invalid form id' do
      before do
        @other_user = create(:user)
        post "/api/v1/answers", params: {form_id: 0}, headers: header_with_authentication(@user)
      end

      it 'returns 404' do
        expect_status(404)
      end
    end
  end
end
