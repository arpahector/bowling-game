class Frame < ActiveRecord::Base
  has_many :balls

  def strike?
    @strike ||= balls.first.try(:strike?)
  end

  def spare?
    @spare ||= balls.second.try(:spare?)
  end

  def self.game_over?
    number == 11
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
