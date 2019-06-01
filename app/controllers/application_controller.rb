class ApplicationController < ActionController::API
  before_action :authorize_request, except: [:register, :sign_in, :home, :route_not_found]
  attr_reader :current_user
  include ExceptionHandler

  def home
    render json: {
        data: {
            message: 'Home'
        }
    }
  end

  def route_not_found
    render json: {
        data: {
            message: 'Route not found'
        }
    }, status: 404
  end

  def register
    user = User.new
    user.email = user_params[:email].strip if user_params[:email].present?
    user.phone_number = user_params[:phone_number].strip if user_params[:phone_number].present?
    user.name = user_params[:name].strip if user_params[:name].present?
    if user.save
      data = AuthenticateUser.new(user.phone_number).call
      render json: {
          data: data.result
      }, status: 200
    else
      render json: {
          data: {
              messages: user.errors.full_messages
          }
      }, status: 422
    end
  end

  def me
    render json: {
        data: {
            user: @current_user
        }
    }
  end

  def sign_in
    data = AuthenticateUser.new(auth_params[:login]).call
    render json: {
      data: data.result
    }
  end

  def update_live
    @current_user.update!({lives: @current_user.lives - 1}) unless @current_user.lives.zero?

    render json: {
      lives: @current_user.lives
    }
  end

  def sharing
    @current_user.update!({ sharing_day: Date.today, lives: @current_user.lives + 1 }) unless @current_user.sharing_day

    render json: @current_user
  end

  def identify
    @current_user.update!({ identify: true, lives: @current_user.lives + 1 }) unless @current_user.identify

    render json: @current_user
  end

  private

  def user_params
    params.permit(:email, :phone_number, :name)
  end

  def auth_params
    params.permit(:login)
  end

  def live_params
    params.permit(:value)
  end

  def authorize_request
    @current_user = AuthorizeApiRequest.new(request.headers).call.result
    render json: { message: 'Not Authorized' }, status: 401 unless @current_user
  end

end
