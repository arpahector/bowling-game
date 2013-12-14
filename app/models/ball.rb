class Ball < ActiveRecord::Base
  belongs_to :frame
  validates_presence_of :pins
  validates_numericality_of :pins, greater_than_or_equal_to: 0, less_than_or_equal_to: 10

  before_create :join_frame
  before_create :set_score

  def first_one?
    frame.balls.first == self
  end

  def second_one?
    frame.balls.second == self
  end

  def strike?
    frame.strike?
  end

  def spare?
    frame.spare?
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
end
