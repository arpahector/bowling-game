class Frame < ActiveRecord::Base
  has_many :balls

  def self.number
    if count == 0 || last.balls.size == 2 || last.try(:strike?)
      if count < 10
        count + 1
      else
        balls = last.balls
        (balls.size == 3 or (balls.first.pins < 10 && (balls.second.pins + balls.first.pins < 10))) ? 11 : 10
      end
    else
      count
    end
  end

  def strike?
    balls.first.pins == 10
  end

  def spare?
    balls.size == 2 && [balls.first, balls.second].map(&:pins).sum == 10
  end
end
