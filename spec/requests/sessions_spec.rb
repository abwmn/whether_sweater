require 'rails_helper'

RSpec.describe "Api::V0::Sessions", type: :request do
  describe "POST /create" do
    let(:user) { User.create(email: 'user@example.com', password: 'password', password_confirmation: 'password') }

    let(:valid_attributes) do
      {
        email: user.email,
        password: 'password'
      }
    end

    let(:invalid_attributes) do
      {
        email: user.email,
        password: 'wrongpassword'
      }
    end

    context "with valid parameters" do
      before { post '/api/v0/sessions', params: valid_attributes }

      it "renders a successful response" do
        expect(response).to have_http_status(:ok)
      end

      it "renders the email in the response body" do
        expect(response.body).to match(/user@example.com/)
      end

      it "renders the API key in the response body" do
        expect(response.body).to match(/#{user.api_key}/)
      end
    end

    context "with invalid parameters" do
      before { post '/api/v0/sessions', params: invalid_attributes }

      it "renders an unsuccessful response" do
        expect(response).to have_http_status(:unauthorized)
      end

      it "renders error messages in the response body" do
        expect(response.body).to match(/Invalid credentials/)
      end
    end
  end
end
