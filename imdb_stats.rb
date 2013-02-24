require 'sinatra'
require 'slim'
require './models/rating'

get '/' do
  slim :index
end

get '/statistics' do
  @ratings = Rating.download params[:url]
  slim :statistics
end

helpers do
  def diff_sorted(ratings)
    @diff_sorted ||= ratings.sort_by! do |rating|
      rating.user_rating - rating.average_rating
    end
  end

  def diff_top(ratings, max)
    diff_sorted(ratings).reverse[0..max]
  end

  def diff_bottom(ratings, max)
    diff_sorted(ratings)[0..max]
  end

  def rating_summary(ratings)
    @rating_summary ||= ([0] * 10).tap do |rating_summary|
      ratings.each do |rating|
        rating_summary[rating.user_rating - 1] += 1
      end
    end
  end

  def genres_summary(ratings)
    {}.tap do |genre|
      ratings.each do |rating|
        rating.genres.split(", ").each do |name|
          genre[name] ||= { count: 0, average: 0.0 }
          genre[name][:count] += 1
          genre[name][:average] = (genre[name][:average] * genre[name][:count] + rating.user_rating) / (genre[name][:count] + 1)
        end
      end
    end.sort_by { |k, v| v[:count] }.reverse
  end

end
