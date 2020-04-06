class ApplicationController < ActionController::API
  before_action :authorize_request, only: [:me, :sharing, :game_1, :game_2, :game_3, :game_4, :game_5, :buy_ticket]
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
    if (user_params[:email].blank? || user_params[:phone_number].blank?)
      render json: {
          data: {
              messages: 'Missing params email or phone number!'
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
    render json: {
        data: {
            user: @current_user
        }
    }
  end

  def sign_in
    data = AuthenticateUser.new(auth_params[:login], auth_params[:password]).call
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

  def count_user
    render json: {
        total_user: User.all.count
    }
  end

  def game_1
    if @current_user.game_1
      return render json: {
          data: {
              user: @current_user
          }
      }
    end
    @current_user.update(game_1: true, coin: @current_user.coin + 100)
    render json: {
        data: {
            user: @current_user
        }
    }
  end

  def game_2
    if @current_user.game_2
      return render json: {
          data: {
              user: @current_user
          }
      }
    end
    @current_user.update(game_2: true, coin: @current_user.coin + 100)
    render json: {
        data: {
            user: @current_user
        }
    }
  end

  def game_3
    if @current_user.game_3
      return render json: {
          data: {
              user: @current_user
          }
      }
    end
    @current_user.update(game_3: true, coin: @current_user.coin + 100)
    render json: {
        data: {
            user: @current_user
        }
    }
  end

  def game_4
    if params[:time]
      @current_user.update(game_4_time: params[:time], coin: @current_user.coin + 100)
    end
    render json: {
        data: {
            user: @current_user
        }
    }
  end

  def game_5
    if @current_user.game_5
      return render json: {
          data: {
              user: @current_user
          }
      }
    end
    @current_user.update(game_5: true, coin: @current_user.coin + 100)
    render json: {
        data: {
            user: @current_user
        }
    }
  end

  def buy_ticket
    if params[:ticket_type] == 1 && @current_user.coin >= 100
      @current_user.update(ticket_type_1: @current_user.ticket_type_1 + 1, coin: @current_user.coin - 100)
    elsif params[:ticket_type] == 2 && @current_user.coin >= 50
      @current_user.update(ticket_type_2: @current_user.ticket_type_2 + 1, coin: @current_user.coin - 50)
    elsif params[:ticket_type] == 3 && @current_user.coin >= 20
      @current_user.update(ticket_type_3: @current_user.ticket_type_3 + 1, coin: @current_user.coin - 20)
    else
      return render json: {
          is_success: false,
          data: {
              user: @current_user
          }
      }
    end
    render json: {
        is_success: true,
        data: {
            user: @current_user
        }
    }
  end

  def top_gamers
    @top_gamers = User.where("game_4_time > 0").select(:id, :username, :email, :phone_number, :game_4_time).order(game_4_time: :asc).limit(params[:limit] || 5)
    render json: {
        data: {
            top_gamers: @top_gamers
        }
    }
  end

  private

  def user_params
    params.permit(:email, :phone_number, :username, :is_received_email)
  end

  def game_params
    params.permit(:game_1, :game_2, :game_3, :game_5)
  end

  def auth_params
    params.permit(:login, :password)
  end

  def authorize_request
    @current_user = AuthorizeApiRequest.new(request.headers).call.result
    render json: { message: 'Not Authorized' }, status: 401 unless @current_user
  end

end
