require 'spec_helper'

describe Ball do
  it "is invalid without pins" do
    expect(Ball.new(pins: nil)).to have(1).errors_on(:pins)
  end
end
