class Frame < ActiveRecord::Base
  has_many :balls
  def self.number
    if count == 0 || last.balls.size == 2 || last.try(:strike?)
      self.count + 1
    else
      self.count
    end
  end

  def strike?
    balls.first.pins == 10
  end

  def spare?
    balls.size == 2 && [balls.first, balls.second].map(&:pins).sum == 10
  end
end
