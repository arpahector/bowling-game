class Ball < ActiveRecord::Base
  belongs_to :frame
  validates_presence_of :pins
  validates_numericality_of :pins, greater_than_or_equal_to: 0, less_than_or_equal_to: 10
  validate :pins_less_or_equal_to_remaining_pins

  before_validation :join_frame
  before_create :set_score

  def strike?
    @strike ||= pins == 10 && (first_one? || (second_one? && first_one.strike?) || third_one? && first_one.strike? && second_one.strike?)
  end

  def spare?
    @spare ||= (second_one? && pins + first_one.pins == 10) || (third_one? && first_one.strike? && !second_one.strike? && second_one.pins + pins == 10)
  end

  def first_one?
    first_one == self
  end

  def second_one?
    second_one == self
  end

  def third_one?
    third_one == self
  end

  def first_one
    frame.balls.first
  end

  def second_one
    frame.balls.second
  end

  def third_one
    frame.balls.third
  end

private

  def join_frame
    if Ball.count == 0 || (Frame.count < 10 && (Ball.last.strike? || Ball.last.second_one?))
      self.frame_id = Frame.create.id
    else
      self.frame_id = Frame.last.id
    end
  end

  def set_score
    if Ball.count == 0
      self.score = self.pins
    else
      self.score = Ball.last.score + self.pins
      self.score += self.pins if Ball.last.strike? || Ball.last.spare?
      self.score += self.pins if Ball.second_to_last.try(:strike?)
    end
  end

  def self.second_to_last
    self.order("id DESC").offset(1).first
  end

  def pins_less_or_equal_to_remaining_pins
    if frame.balls.size == 1 && !first_one.strike? && (first_one.pins + pins > 10) || (frame.balls.size == 3 && !second_one.strike? && (second_one.pins + pins > 10))
      errors.add(:pins, "You can't throw more pins than the remaining ones")
    end
  end
end
