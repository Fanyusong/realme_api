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
              lives: @current_user.lives,
              coin: @current_user.coin
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
    # phone_and_headphone_ids = RewardList.where(reward_type_id: RewardType.where(name: ['realme-phone', 'realme-headphone']).pluck(:id)).pluck(:id) # 11
    # xu100_ids = RewardList.where(reward_type_id: RewardType.where(name: '100xu').pluck(:id)).limit(20).pluck(:id)
    # xu500_ids = RewardList.where(reward_type_id: RewardType.where(name: '500xu').pluck(:id)).limit(20).pluck(:id)
    # xu700_ids = RewardList.where(reward_type_id: RewardType.where(name: '700xu').pluck(:id)).limit(15).pluck(:id)
    # hat_ids = RewardList.where(reward_type_id: RewardType.where(name: 'realme-hat').pluck(:id)).limit(10).pluck(:id)
    # failed_ids = (1000000...1000025).to_a # 25
    # total = [phone_and_headphone_ids, xu100_ids, xu500_ids, xu700_ids, hat_ids, failed_ids].flatten
    # total.sample
    # random_number = total.sample
    so_random = RandomNumber&.first
    @current_user.update(lives: (@current_user.lives - 1 ))
    if so_random.nil?
      failed_reward_type = RewardType.where(name: 'failed')&.first
      Reward.create(reward_number: 100000000,
                    description: 'failed',
                    reward_type_id: failed_reward_type.id,
                    user_id: @current_user.id)
      return render json: {
          is_sucess: true,
          data: {
              is_trung_thuong: false,
              message: 'Chúc bạn may mắn lần sau',
              type: 'failed'
          }
      }
    end
    random_number = so_random&.number
    so_random.delete
    # random_number = rand(600000)
    so_trung_thuong = RewardList.where(random_number: random_number)&.first

    unless so_trung_thuong.nil?
      Reward.create(reward_number: random_number,
                    description: so_trung_thuong.reward_type.name,
                    reward_type_id: so_trung_thuong.reward_type_id,
                    user_id: @current_user.id)
      type = so_trung_thuong.reward_type.name
      if (so_trung_thuong.reward_type.name == 'realme-hat' || so_trung_thuong.reward_type.name == 'realme-phone' || so_trung_thuong.reward_type.name == 'realme-headphone')
        so_trung_thuong.delete
      else
        added_coin = 0
        if so_trung_thuong.reward_type.name == '100xu'
          added_coin = 100
        elsif  so_trung_thuong.reward_type.name == '500xu'
          added_coin = 500
        else
          added_coin = 700
        end
        @current_user.update(coin: (@current_user.coin + added_coin))
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
            message: 'Chúc bạn may mắn lần sau',
            type: 'failed'
        }
      }
    end
  end

  def history
    histories = Reward.where(user_id: @current_user.id).order(created_at: :desc)
    render json: {
        data: {
            histories: histories
        }
    }
  end

  def top5_recent_winner
    top5 = Reward.joins(:reward_type, :user)
        .where(reward_type_id: RewardType.where(name: ['realme-hat', 'realme-phone', 'realme-headphone']).pluck(:id))
        .order("reward_types.priority ASC, rewards.created_at DESC").limit(5)
    data = []
    top5.each do |v|
      phone = v.user&.phone_number
      phone[0..3] = "xxxx"
      data << {
          name: v.user&.name,
          phone: phone,
          email: v.user&.email,
          type: v.reward_type.name,
          created_at: v.created_at
      }
    end
    render json: {
        data: data
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
