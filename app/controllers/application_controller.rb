class ApplicationController < ActionController::API
  include ExceptionHandler
  before_action :authorize_request, only: [:me, :game_1, :game_2, :game_3, :game_4]
  attr_reader :current_user

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
    if user_params[:email].blank?
      return render json: {
          data: {
              messages: 'Missing params email!',
              error_code: 101
          }
      }, status: 422
    end
    if user_params[:phone_number].blank?
      return render json: {
          data: {
              messages: 'Missing params phone number!',
              error_code: 102
          }
      }, status: 422
    end
    user.email = user_params[:email].strip
    user.phone_number = user_params[:phone_number].strip
    user.name = user_params[:username].strip if user_params[:username].present?
    user.password = user_params[:phone_number].last(6)
    if user.save
      data = AuthenticateUser.new(user.phone_number, user.password).call
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
    render_success
  end

  def sign_in
    data = AuthenticateUser.new(auth_params[:login], auth_params[:password]).call
    render json: {
      data: data.result
    }
  end

  def sharing
    unless @current_user.sharing_day.nil?
      newDay = @current_user.sharing_day.split('/')
      compare_day = Date.new(newDay[2].to_i, newDay[0].to_i, newDay[1].to_i).to_s
    end
    if  @current_user.sharing_day.nil? || ( compare_day && compare_day != DateTime.parse(Time.now.to_s).strftime("%Y-%m-%d"))
      @current_user.update!({ sharing_day: Date.today, coin: @current_user.coin + 20 })
      render json: {
         is_success: true,
         data: {
             coin: @current_user.coin,
             lives: @current_user.lives
         }
      }
    else
      render json: {
          is_success: false,
          message: 'Mỗi ngày bạn chỉ được chia sẽ 1 lần'
      }
    end
  end

  def game_1
    if params[:game_1] =~ /[0-9]*\.?[0-9]+\Z/
      is_update = if @current_user.game_1_float > 0
                    params[:game_1]&.to_f < @current_user.prev_game1
                  else
                    true
                  end
      @current_user.update(game_1: params[:game_1]&.to_f,
                           game_1_float: params[:game_1]&.to_f,
                           prev_game1: params[:game_1]&.to_f,
                           total_time: @current_user.total_time + params[:game_1]&.to_f - @current_user.prev_game1) if is_update
    end
    render_success
  end

  def game_2
    if params[:game_2] =~ /[0-9]*\.?[0-9]+\Z/
      is_update = if @current_user.game_2_float > 0
                    params[:game_2]&.to_f < @current_user.prev_game2
                  else
                    true
                  end
      @current_user.update(game_2: params[:game_2]&.to_f,
                           game_2_float: params[:game_2]&.to_f,
                           prev_game2: params[:game_2]&.to_f,
                           total_time: @current_user.total_time + params[:game_2]&.to_f - @current_user.prev_game2) if is_update
    end
    render_success
  end

  def game_3
    if params[:game_3] =~ /[0-9]*\.?[0-9]+\Z/
      is_update = if @current_user.game_3_float > 0
                    params[:game_3]&.to_f < @current_user.prev_game3
                  else
                    true
                  end
      @current_user.update(game_3: params[:game_3]&.to_f,
                           game_3_float: params[:game_3]&.to_f,
                           prev_game3: params[:game_3]&.to_f,
                           total_time: @current_user.total_time + params[:game_3]&.to_f - @current_user.prev_game3) if is_update
    end
    render_success
  end

  def game_4
    if params[:game_4] =~ /[0-9]*\.?[0-9]+\Z/
      is_update = if @current_user.game_4_float > 0
        params[:game_4]&.to_f < @current_user.prev_game4
      else
        true
      end
      @current_user.update(game_4: params[:game_4]&.to_f,
                           game_4_float: params[:game_4]&.to_f,
                           prev_game4: params[:game_4]&.to_f,
                           total_time: @current_user.total_time + params[:game_4]&.to_f - @current_user.prev_game4) if is_update
    end
    render_success
  end

  def top_gamers
    @top_gamers = User.where("total_time > 0")
                      .order(total_time: :desc)
                      .select(:id, :name, :email, :phone_number, :total_time)
                      .limit(params[:limit] || 10)
    render json: {
      data: {
          top_gamers: @top_gamers
      }
    }
  end

  def total_users
    total = User.count
    render json: {
        data: {
            total_users: total
        }
    }
  end

  private

  def user_params
    params.permit(:email, :phone_number, :username, :is_received_email)
  end

  def game_params
    params.permit(:game_1, :game_2, :game_3, :game_4)
  end

  def auth_params
    params.permit(:login, :password)
  end

  def authorize_request
    @current_user = AuthorizeApiRequest.new(request.headers).call.result
    render json: { message: 'Not Authorized' }, status: 401 unless @current_user
  end

  def render_success
    render json: {
        is_success: true,
        data: {
            user: {
                email: @current_user.email,
                phone_number: @current_user.phone_number,
                game_1: @current_user.game_1,
                game_2: @current_user.game_2,
                game_3: @current_user.game_3,
                game_4: @current_user.game_4,
                total_time: @current_user.total_time
            }
        }
    }
  end

end
