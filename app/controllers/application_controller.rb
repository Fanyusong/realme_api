class ApplicationController < ActionController::API
  before_action :authorize_request, except: [:register, :login]
  attr_reader :current_user
  include ExceptionHandler

  def register
    user = User.new(user_params)
    if user.save
      auth_token = AuthenticateUser.new(user.email).call
      render json: {
          data: {
              status: true,
              data: {
                  token: auth_token
              }
          }
      }
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
            status: true,
            data: {
                token: auth_token
            }
        }
    }
  end

  def update_game_score
    score = current_user.update_info_game_score(game_score_params)
    if score
      render json: {
          data: {
              message: 'Update game score success'
          }
      }
    else
      render json: {
          data: {
              message: 'Update game score failed'
          }
      }, status: 422
    end
  end

  private

  def user_params
    params.permit(:email, :phone_number, :address, :name)
  end

  def game_score_params
    params.permit(:game_1, :game_2, :game_3, :game_4, :game_5, :game_6)
  end

  def receive_mail_params
    params.permit(:is_received_email)
  end

  def auth_params
    params.permit(:login)
  end

  def authorize_request
    @current_user = (AuthorizeApiRequest.new(request.headers).call)[:user]
  end

end
