require 'spec_helper'

describe Ball do
  it "is invalid without pins" do
    expect(Ball.new(pins: nil)).to have(1).errors_on(:pins)
  end

  it "should belong to a frame" do
    ball = Ball.create(pins: 7)
    expect(ball.frame).not_to be nil
  end

  describe "after being thrown" do
    pending "receives a score"
  end
end
