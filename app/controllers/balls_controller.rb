class BallsController < ApplicationController
  def new
    @ball ||= Ball.new
    @frame_number = Frame.number
    @score = Ball.last.try(:score) || 0
  end

  def create
    @ball = Ball.create(params[:ball].permit(:pins))
    new
    render action: "new"
  end
end
