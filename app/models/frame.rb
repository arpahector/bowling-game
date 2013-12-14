class Frame < ActiveRecord::Base
  has_many :balls

  def strike?
    balls.first.pins == 10
  end

  def spare?
    balls.size == 2 && [balls.first, balls.second].map(&:pins).sum == 10
  end

  def self.number
    if count == 0 || count == 10 || last.balls.size == 2 || last.try(:strike?)
      if count < 10
        count + 1
      else
        (last.balls.size == 3 or (!last.strike? && !last.spare? && last.balls.size == 2)) ? 11 : 10
      end
    else
      count
    end
  end
end
