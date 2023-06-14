require 'rails_helper'

RSpec.describe "Api::V0::Users", type: :request do
  describe "POST /create" do
    let(:valid_attributes) do
      {
        user: {
        email: 'user@example.com',
        password: 'password',
        password_confirmation: 'password'
        }
      }
    end

    let(:invalid_attributes) do
      {
        user: {
        email: 'user@example.com',
        password: 'password',
        password_confirmation: 'wrongpassword'
        }
      }
    end

    context "with valid parameters" do
      before { post '/api/v0/users', params: valid_attributes }

      it "creates a new User" do
        expect(User.count).to eq(1)
      end

      it "renders a successful response" do
        expect(response).to have_http_status(:created)
      end

      it "renders the email in the response body" do
        expect(response.body).to match(/user@example.com/)
      end

      it "does not render the password in the response body" do
        expect(response.body).not_to match(/password/)
      end

      it "renders the API key in the response body" do
        user = User.first
        expect(response.body).to match(/#{user.api_key}/)
      end
    end

    context "with invalid parameters" do
      before { post '/api/v0/users', params: invalid_attributes }

      it "does not create a new User" do
        expect(User.count).to eq(0)
      end

      it "renders an unsuccessful response" do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "renders error messages in the response body" do
        expect(response.body).to match(/Password confirmation doesn't match Password/)
      end
    end
  end
end

