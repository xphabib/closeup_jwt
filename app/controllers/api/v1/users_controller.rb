class Api::V1::UsersController < Api::V1::BaseController
  skip_before_action :authenticate_request, only: [:login, :registration]

  def login
    command = AuthenticateUser.call(user_params[:login], user_params[:password])
    if command.success?
      render json: {success: true, user: AuthenticateUser.find_record(user_params[:login]), auth_token: command.result}
    else
      render json: {success: false, errors: command.errors, message: 'Invalid credential or account is not active!'}, status: 200
    end
  end

  def registration
    user = User.new(user_params)
    if user.save
      token = AuthenticateUser.get_token(user)
      render json: {success: true, message: 'Registration Success', user: user, auth_token: token}
    else
      render json: {success: false, errors: user.errors}, status: 200
    end
  end

  def profile
    render json: {success: true, profile: current_user, status: 200}
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end