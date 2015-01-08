class HomesController < ApplicationController

  respond_to :js

  def index
    @days = Home.all.order(:day)
  end

  def ajax
    @days = Home.all.order(:day)
    @line = Home.find_or_initialize_by(:day => Time.now.to_date)
    time = params[:time].to_time(:utc)
    if @line.time.nil?
      @line.time = time.to_formatted_s(:only_time)
    else
      h = time.to_formatted_s(:only_hours).to_i
      m = time.to_formatted_s(:only_minutes).to_i
      s = time.to_formatted_s(:only_seconds).to_i
      @line.time = (@line.time.to_time(:utc) + h.hours + m.minutes + s.seconds).to_formatted_s(:only_time)
    end

    if @line.save
      respond_to do |format|
        format.js
      end
    end
  end

end
