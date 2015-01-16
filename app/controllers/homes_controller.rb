class HomesController < ApplicationController

  respond_to :js, :json

  def index
    @user = current_user unless current_user.nil?
    @days = Home.where(:user_id => @user.id) unless @user.nil?
  end

  def ajax
    @days = Home.all.order(:day)
    time = params[:time].to_time(:utc)
    binding.pry

    respond_to do |format|

      format.js do
        @line = current_user.homes.find_or_initialize_by(:day => Time.now.to_date)
        if @line.save_time(time)
          render 'ajax', format: :js
        end
      end

      format.json do
        @user = User.find_by_authentication_token(params[:authentication_token])
        @line = @user.homes.find_or_initialize_by(:day => Time.now.to_date)

        if @line.save_time(time)
          render :json => { :success => true }, :status=>201
        end
      end
    end
  end

end
