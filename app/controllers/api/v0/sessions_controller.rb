class Api::V0::SessionsController < ApplicationController
  def create
    user = User.find_by(email: session_params[:email])

    if user && user.authenticate(session_params[:password])
      render json: UserSerializer.new(user), status: :ok
    else
      render json: { error: 'Invalid credentials' }, status: :unauthorized
    end
  end

  private

  def session_params
    params.require(:user).permit(:email, :password)
  end
end