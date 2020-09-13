class ApplicationController < ActionController::API
  include ExceptionHandler
  before_action :authorize_request, only: [:me, :game_1, :game_2, :game_3, :game_4, :sharing, :current_rank]
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
          error: 101,
          is_success: false,
          data: nil,
          message: 'Missing params Email!',
      }
    end
    if user_params[:phone_number].blank?
      return render json: {
          error: 102,
          is_success: false,
          data: nil,
          message: 'Missing params phone number!',
      }
    end
    user.email = user_params[:email].strip
    user.phone_number = user_params[:phone_number].strip
    user.name = user_params[:name].strip if user_params[:name].present?
    user.password = user_params[:phone_number]
    if user.save
      data = AuthenticateUser.new(user.phone_number, user.password).call
      render json: {
          data: data.result,
          is_success: true,
          error: nil
      }
    else
      render json: {
          error: 103,
          is_success: false,
          data: nil,
          message: user.errors.full_messages
      }
    end
  end

  def me
    render_success
  end

  def sign_in
    data = AuthenticateUser.new(auth_params[:login], auth_params[:password]).call
    render json: {
        data: data.result,
        is_success: true,
        error: nil
    }
  end

  def sharing
    unless @current_user.sharing_day.nil?
      newDay = @current_user.sharing_day.split('/')
      compare_day = Date.new(newDay[2].to_i, newDay[0].to_i, newDay[1].to_i).to_s
    end
    if @current_user.sharing_day.nil? || (compare_day && compare_day != DateTime.parse(Time.now.to_s).strftime("%Y-%m-%d"))
      @current_user.sharing_day = Date.today
      @current_user.game_1_lives = @current_user.game_1_lives + 2 if ENV['GAME1'] == 'true'
      @current_user.game_2_lives = @current_user.game_2_lives + 2 if ENV['GAME2'] == 'true'
      @current_user.game_3_lives = @current_user.game_3_lives + 2 if ENV['GAME3'] == 'true'
      @current_user.game_4_lives = @current_user.game_4_lives + 2 if ENV['GAME4'] == 'true'
      @current_user.save
      render_success
    else
      render_error 111, 'Mỗi ngày bạn chỉ được chia sẽ 1 lần'
    end
  end

  def game_1
    return render_error(104, "Your lives in game 1 is 0") unless @current_user.game_1_lives > 0
    if params[:game_1]&.to_i > 1000
      is_qualified = ENV['GAME2'] == @current_user.game_2.present?.to_s && ENV['GAME3'] == @current_user.game_3.present?.to_s && ENV['GAME4'] == @current_user.game_4.present?.to_s
      if @current_user.game_1.nil?
        @current_user.update(game_1: params[:game_1]&.to_i,
                             prev_game_1: params[:game_1]&.to_i,
                             total_time: @current_user.total_time + params[:game_1]&.to_i - @current_user.prev_game_1,
                             current_total_time: @current_user.current_total_time + params[:game_1]&.to_i,
                             is_qualified: is_qualified,
                             game_1_lives: @current_user.game_1_lives - 1)
      else
        is_update = params[:game_1]&.to_i < @current_user.prev_game_1
        if is_update
          @current_user.update(game_1: params[:game_1]&.to_i,
                               prev_game_1: params[:game_1]&.to_i,
                               total_time: @current_user.total_time + params[:game_1]&.to_i - @current_user.prev_game_1,
                               current_total_time: @current_user.current_total_time + params[:game_1]&.to_i - @current_user.prev_game_1,
                               is_qualified: is_qualified,
                               game_1_lives: @current_user.game_1_lives - 1)
        else
          @current_user.update(game_1_lives: @current_user.game_1_lives - 1, is_qualified: is_qualified)
        end
      end
      @current_user.reload
      render_success
    else
      render_error 110, "Your game params is not correct!"
    end
  end

  def game_2
    return render_error(105, "Your lives in game 2 is 0") unless @current_user.game_2_lives > 0
    if params[:game_2].present?
      return render_error(115, "Params is not correct") unless params[:game_2] =~ /^50d5e5d73cbaa47bee(\d+)7bee76d64a242f53e2$/
      params[:game_2] = params[:game_2].reverse
      params[:game_2] = params[:game_2].gsub('2e35f242a46d67eeb7', '').gsub('eeb74aabc37d5e5d05', '')
    end
    if params[:game_2]&.to_i > 1000
      is_qualified = ENV['GAME1'] == @current_user.game_1.present?.to_s && ENV['GAME3'] == @current_user.game_3.present?.to_s && ENV['GAME4'] == @current_user.game_4.present?.to_s
      if @current_user.game_2.nil?
        @current_user.update(game_2: params[:game_2]&.to_i,
                             prev_game_2: params[:game_2]&.to_i,
                             total_time: @current_user.total_time + params[:game_2]&.to_i - @current_user.prev_game_2,
                             current_total_time: @current_user.current_total_time + params[:game_2]&.to_i,
                             is_qualified: is_qualified,
                             game_2_lives: @current_user.game_2_lives - 1)
      else
        is_update = params[:game_2]&.to_i < @current_user.prev_game_2
        if is_update
          @current_user.update(game_2: params[:game_2]&.to_i,
                               prev_game_2: params[:game_2]&.to_i,
                               total_time: @current_user.total_time + params[:game_2]&.to_i - @current_user.prev_game_2,
                               current_total_time: @current_user.current_total_time + params[:game_2]&.to_i - @current_user.prev_game_2,
                               is_qualified: is_qualified,
                               game_2_lives: @current_user.game_2_lives - 1)
        else
          @current_user.update(game_2_lives: @current_user.game_2_lives - 1, is_qualified: is_qualified)
        end
      end
      @current_user.reload
      render_success
    else
      render_error 110, "Your game params is not correct!"
    end
  end

  def game_3
    return render_error(106, "Your lives in game 3 is 0") unless @current_user.game_3_lives > 0
    if params[:game_3]&.to_i > 1000
      is_qualified = ENV['GAME1'] == @current_user.game_1.present?.to_s && ENV['GAME2'] == @current_user.game_2.present?.to_s && ENV['GAME4'] == @current_user.game_4.present?.to_s
      if @current_user.game_3.nil?
        @current_user.update(game_3: params[:game_3]&.to_i,
                             prev_game_3: params[:game_3]&.to_i,
                             total_time: @current_user.total_time + params[:game_3]&.to_i - @current_user.prev_game_3,
                             current_total_time: @current_user.current_total_time + params[:game_3]&.to_i,
                             is_qualified: is_qualified,
                             game_3_lives: @current_user.game_3_lives - 1)
      else
        is_update = params[:game_3]&.to_i < @current_user.prev_game_3
        if is_update
          @current_user.update(game_3: params[:game_3]&.to_i,
                               prev_game_3: params[:game_3]&.to_i,
                               total_time: @current_user.total_time + params[:game_3]&.to_i - @current_user.prev_game_3,
                               current_total_time: @current_user.current_total_time + params[:game_3]&.to_i - @current_user.prev_game_3,
                               is_qualified: is_qualified,
                               game_3_lives: @current_user.game_3_lives - 1)
        else
          @current_user.update(game_3_lives: @current_user.game_3_lives - 1, is_qualified: is_qualified)
        end
      end
      @current_user.reload
      render_success
    else
      render_error 110, "Your game params is not correct!"
    end
  end

  def game_4
    return render_error(107, "Your lives in game 4 is 0") unless @current_user.game_4_lives > 0
    if params[:game_4]&.to_i > 1000
      is_qualified = ENV['GAME1'] == @current_user.game_1.present?.to_s && ENV['GAME2'] == @current_user.game_2.present?.to_s && ENV['GAME3'] == @current_user.game_3.present?.to_s
      if @current_user.game_4.nil?
        @current_user.update(game_4: params[:game_4]&.to_i,
                             prev_game_4: params[:game_4]&.to_i,
                             total_time: @current_user.total_time + params[:game_4]&.to_i - @current_user.prev_game_4,
                             current_total_time: @current_user.current_total_time + params[:game_4]&.to_i,
                             is_qualified: is_qualified,
                             game_4_lives: @current_user.game_4_lives - 1)
      else
        is_update = params[:game_4]&.to_i < @current_user.prev_game_4
        if is_update
          @current_user.update(game_4: params[:game_4]&.to_i,
                               prev_game_4: params[:game_4]&.to_i,
                               total_time: @current_user.total_time + params[:game_4]&.to_i - @current_user.prev_game_4,
                               current_total_time: @current_user.current_total_time + params[:game_4]&.to_i - @current_user.prev_game_4,
                               is_qualified: is_qualified,
                               game_4_lives: @current_user.game_4_lives - 1)
        else
          @current_user.update(game_4_lives: @current_user.game_4_lives - 1, is_qualified: is_qualified)
        end
      end
      @current_user.reload
      render_success
    else
      render_error 110, "Your game params is not correct!"
    end
  end

  def top_gamers
    @top_gamers = User.where(is_qualified: true)
                      .order(total_time: :asc)
                      .select(:id, :name, :email, :phone_number, :current_total_time)
                      .limit(15)
    render json: {
        data: {
            top_gamers: @top_gamers
        },
        is_success: true,
        error: nil
    }
  end

  def total_users
    total = User.count
    render json: {
        data: {
            total_users: total
        },
        is_success: true,
        error: nil
    }
  end

  def current_rank
    result = ActiveRecord::Base.connection.exec_query("SELECT id, row_number, name, current_total_time, email FROM top_gamers WHERE top_gamers.id = #{@current_user.id}").to_a
    if result&.first["row_number"] > 9
      top4_above = ActiveRecord::Base.connection.exec_query("SELECT id, row_number, name, email, current_total_time FROM top_gamers LIMIT 9 OFFSET #{result&.first["row_number"] - 10}").to_a
      top4_below = ActiveRecord::Base.connection.exec_query("SELECT id, row_number, name, email, current_total_time FROM top_gamers LIMIT 9 OFFSET #{result&.first["row_number"]}").to_a
    else
      top4_above = ActiveRecord::Base.connection.exec_query("SELECT id, row_number, name, email, current_total_time FROM top_gamers LIMIT #{result&.first["row_number"] - 1} OFFSET 0").to_a
      top4_below = ActiveRecord::Base.connection.exec_query("SELECT id, row_number, name, email, current_total_time FROM top_gamers LIMIT 9 OFFSET #{result&.first["row_number"]}").to_a
    end
    below = []
    above = []
    top4_above.each do |v|
      above << {
          id: v["id"],
          name: v["name"],
          email: v["email"],
          total_time: v["current_total_time"],
          rank: v["row_number"]
      }
    end
    top4_below.each do |v|
      below << {
          id: v["id"],
          name: v["name"],
          email: v["email"],
          total_time: v["current_total_time"],
          rank: v["row_number"]
      }
    end
    render json: {
        data: {
            current: {
                id: result&.first["id"],
                name: result&.first["name"],
                email: result&.first["email"],
                total_time: result&.first["current_total_time"],
                rank: result&.first["row_number"]
            },
            above: above,
            below: below

        },
        is_success: true,
        error: nil
    }
  end

  private

  def user_params
    params.permit(:email, :phone_number, :name, :is_received_email)
  end

  def game_params
    params.permit(:game_1, :game_2, :game_3, :game_4)
  end

  def auth_params
    params.permit(:login, :password)
  end

  def authorize_request
    @current_user = AuthorizeApiRequest.new(request.headers).call.result
    render json: {is_success: false, data: nil, error: 401, message: 'Not Authorized'} unless @current_user
  end

  def render_success
    render json: {
        is_success: true,
        data: {
            user: @current_user.serialize_user_data
        },
        error: nil
    }
  end

  def render_error error, message
    render json: {
        is_success: false,
        data: {
            user: @current_user.serialize_user_data
        },
        error: error,
        message: message
    }
  end
end
