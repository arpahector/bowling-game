class BallsController < ApplicationController
  after_filter :data, only: :new

  def new
    @ball = Ball.new
   end

  def create
    @ball = Ball.create(params[:ball].permit(:pins))
    data
    render action: "new"
  end

private

  def data
    @frame_number = Frame.number
    @game_over = Frame.game_over?
    @score = Ball.last.try(:score) || 0
  end
end
