class BallsController < ApplicationController
  def new
    @frame_number = Frame.number
    @score = Ball.last.try(:score) || 0
  end

  def create
    logger.debug params.inspect
    if Ball.create(params[:ball].permit(:pins))
      new
      render action: "new"
    else
      #error
    end
  end
end
