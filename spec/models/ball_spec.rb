require 'spec_helper'

describe Ball do
  it "is invalid without pins" do
    expect(Ball.new(pins: nil)).to have(2).errors_on(:pins)
  end

  it "should belong to a frame" do
    ball = Ball.create(pins: 7)
    expect(ball.frame).not_to be nil
  end

  it "throws between 0 and 10 pins" do
    expect(Ball.create(pins: 11)).not_to be_valid
  end

  context "when in the second ball of a frame" do
    it "throws a maximum of the remaining pins" do
      Ball.create(pins: 7)
      expect(Ball.create(pins: 4)).to have(1).errors_on(:pins)
    end
  end

  context "10th frame" do
    it "three strikes are allowed" do
      18.times{ Ball.create(pins: 3) }
      expect(Ball.create(pins: 10)).to be_valid
      expect(Ball.create(pins: 10)).to be_valid
      expect(Ball.create(pins: 10)).to be_valid
    end

    it "after one strike + 7 pins thrown only remain 3 pins" do
      18.times{ Ball.create(pins: 3) }
      expect(Ball.create(pins: 10)).to be_valid
      expect(Ball.create(pins: 7)).to be_valid
      expect(Ball.create(pins: 4)).to have(1).errors_on(:pins)
    end
  end
end
