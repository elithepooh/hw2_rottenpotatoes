class Movie < ActiveRecord::Base
  def self.all_ratings
    all(:select => "rating").map(&:rating).uniq
  end
end
