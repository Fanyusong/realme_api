class ApplicationController < ActionController::API
  before_action :authorize_request, only: [:me, :sharing, :quay_so, :history, :change_coin_to_live]
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

  def change_coin_to_live
    live_number = @current_user.coin / 1000
    if live_number >= 1
      remain_coin = @current_user.coin - (live_number * 1000)
      @current_user.update(lives: live_number, coin: remain_coin)
      render json: {
          is_success: true,
          data: {
              lives: live_number,
              coin: remain_coin
          }
      }
    else
      render json: {
          is_success: false,
          message: 'Bạn không có đủ số xu để đổi 1 lượt quay'
      }
    end
  end

  def sharing
    unless @current_user.sharing_day.nil?
      newDay = @current_user.sharing_day.split('/')
      compare_day = Date.new(newDay[2].to_i, newDay[0].to_i, newDay[1].to_i).to_s
    end
    if  @current_user.sharing_day.nil? || ( compare_day && compare_day != DateTime.parse(Time.now.to_s).strftime("%Y-%m-%d"))
      @current_user.update!({ sharing_day: Date.today, coin: @current_user.coin + 1000 })
    end
    render json: @current_user
  end

  def count_user
    render json: {
        total_user: User.all.count
    }
  end

  def quay_so
    unless @current_user.lives > 0
      return render json: {
          is_sucess: false,
          message: 'Bạn không còn lượt quay'
      }
    end
    random_number = rand(600000)
    so_trung_thuong = RewardList.where(id: random_number)&.first
    @current_user.update(lives: (@current_user.lives - 1 ))

    unless so_trung_thuong.nil?
      Reward.create(reward_number: random_number,
                    description: so_trung_thuong.reward_type.name,
                    reward_type_id: so_trung_thuong.reward_type_id,
                    user_id: @current_user.id)
      type = so_trung_thuong.reward_type.name
      if (so_trung_thuong.reward_type.name == 'realme-hat' || so_trung_thuong.reward_type.name == 'realme-phone' || so_trung_thuong.reward_type.name == 'realme-headphone')
        so_trung_thuong.delete
      end
      render json: {
        is_sucess: true,
        data: {
            is_trung_thuong: true,
            message: "Bạn đã trúng #{type}",
            type: type
        }
      }
    else
      failed_reward_type = RewardType.where(name: 'failed')&.first
      Reward.create(reward_number: random_number,
                    description: 'failed',
                    reward_type_id: failed_reward_type.id,
                    user_id: @current_user.id)
      render json: {
        is_sucess: true,
        data: {
            is_trung_thuong: false,
            data: 'Chúc bạn may mắn lần sau',
            type: 'failed'
        }
      }
    end
  end

  def history
    histories = Reward.where(user_id: @current_user.id)
    render json: {
        data: {
            histories: histories
        }
    }
  end

  private

  def user_params
    params.permit(:email, :phone_number, :name, :is_received_email)
  end

  def auth_params
    params.permit(:login)
  end

  def authorize_request
    @current_user = AuthorizeApiRequest.new(request.headers).call.result
    render json: { message: 'Not Authorized' }, status: 401 unless @current_user
  end

end
