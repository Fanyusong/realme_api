class ApplicationController < ActionController::API
  before_action :authorize_request, only: [:me, :update_live, :sharing, :quay_so, :identify, :update_game, :new_post]
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
            token: request.headers['Authorization'].split(' ').last,
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
    unless @current_user.sharing_day.nil?
      newDay = @current_user.sharing_day.split('/')
      compare_day = Date.new(newDay[2].to_i, newDay[0].to_i, newDay[1].to_i).to_s
    end
    if  @current_user.sharing_day.nil? || ( compare_day && compare_day != DateTime.parse(Time.now.to_s).strftime("%Y-%m-%d"))
      @current_user.update!({ sharing_day: Date.today, lives: @current_user.lives + 1 })
    end
    render json: @current_user
  end

  def identify
    @current_user.update!({ identify: true }) unless @current_user.identify

    render json: @current_user
  end

  def count_user
    render json: {
        total_user: User.all.count
    }
  end

  def update_game
    @current_user.update!(game_params)
    render json: @current_user
  end

  def quay_so
    random_number = rand(600000)
    so_trung_thuong = RewardList.where(id: random_number)
    unless so_trung_thuong.nil?
      Reward.create(reward_number: random_number,
                    reward_type: so_trung_thuong.reward_type_id,
                    user_id: @current_user.id)
      render json: {
          is_trung_thuong: true,
          data: "Bạn đã trúng #{so_trung_thuong.reward_type.name}",
          type: so_trung_thuong.reward_type.name
      }
    else
      render json: {
          is_trung_thuong: false,
          data: 'Chúc bạn may mắn lần sau',
          type: 'trung_gio'
      }
    end
  end

  private

  def user_params
    params.permit(:email, :phone_number, :name, :is_received_email)
  end

  def auth_params
    params.permit(:login)
  end

  def game_params
    params.permit(:game_1, :game_2)
  end

  def authorize_request
    @current_user = AuthorizeApiRequest.new(request.headers).call.result
    render json: { message: 'Not Authorized' }, status: 401 unless @current_user
  end

end
