json.array!(@movies) do |movie|
  json.extract! movie, :id, :title, :hotness, :image_url, :synopsis, :rating, :genre, :director, :runtime, :release_date, :user_id
  json.url movie_url(movie, format: :json)
end
