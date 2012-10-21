class Movie < ActiveRecord::Base
	@@all = ['G','PG','PG-13','R','NC-17']
  def self.all_ratings
    return @@all
  end
end
