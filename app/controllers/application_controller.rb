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
    user = User.new(user_params)
    if user.save
      auth_token = AuthenticateUser.new(user.email).call
      render json: {
          data: {
              status: true,
              data: {
                  token: auth_token.result
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
          token: auth_token.result
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

  def receive_email
    unless @current_user.email.blank?
      @current_user.update(is_received_email: receive_mail_params[:is_received_email])
      render json: {
          data: {
              message: 'Update status of receive email success'
          }
      }
    else
      render json: {
          data: {
              message: 'Please update your email'
          }
      }, status: 422
    end
  end

  def profile
    render json: {
        data: {
            email: @current_user&.email,
            phone_number: @current_user&.phone_number,
            game_1: @current_user.game_1,
            game_2: @current_user.game_2,
            game_3: @current_user.game_3,
            game_4: @current_user.game_4,
            game_5: @current_user.game_5,
            game_6: @current_user.game_6,
            is_received_email: @current_user.is_received_email
        }
    }
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
    @current_user = AuthorizeApiRequest.new(request.headers).call.result
    render json: { message: 'Not Authorized' }, status: 401 unless @current_user
  end

end
