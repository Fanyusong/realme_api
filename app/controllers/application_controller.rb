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
      auth_token = AuthenticateUser.new(user.phone_number).call
      render json: {
          data: {
              user: {
                email: user.email,
                name: user.name,
                phone_number: user.phone_number
              },
              token: auth_token.result
          }
      }, status: 200
    else
      render json: {
          data: {
              messages: user.errors.full_messages
          }
      }, status: 422
    end
  end

  def sign_in
    auth_token = AuthenticateUser.new(auth_params[:login]).call
    render json: {
      data: {
          token: auth_token.result
      }
    }
  end

  private

  def user_params
    params.permit(:email, :phone_number, :name)
  end

  def auth_params
    params.permit(:login)
  end

  def authorize_request
    @current_user = AuthorizeApiRequest.new(request.headers).call.result
    render json: { message: 'Not Authorized' }, status: 401 unless @current_user
  end

end
