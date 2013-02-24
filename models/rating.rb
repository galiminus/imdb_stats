require 'rest-client'
require 'csv'

class Rating
  attr_accessor :title, :directors, :user_rating, :average_rating,
                :year, :genres, :num_votes, :release_date, :url

  def Rating.download(url)
    CSV.parse(RestClient.get(url).body)[1..-1].map do |row|
      Rating.new(title: row[5],
                 directors: row[7],
                 user_rating: row[8].to_f,
                 average_rating: row[9].to_f,
                 year: row[11],
                 genres: row[12],
                 num_votes: row[13].to_i,
                 release_date: row[14],
                 url: row[15])
    end
  end

  def initialize(opts)
    opts.each do |key, value|
      send("#{key}=", value) if respond_to?(:"#{key}=")
    end
  end
end
