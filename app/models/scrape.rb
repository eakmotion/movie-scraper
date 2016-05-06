class Scrape
  attr_accessor :title, :hotness, :image_url, :synopsis, :rating, :genre, 
                :director, :runtime, :release_date, :failure

  def scrape_new_movie
    begin
      page = Nokogiri::HTML(open('http://www.rottentomatoes.com/m/the_jungle_book_2016/'))
      page.css('script').remove

      self.title = page.at("h1[@itemprop = 'name']").text
      self.hotness = page.at("span[@itemprop = 'ratingValue']").text.to_i
      self.image_url = page.at_css('#movie-image-section img')['src'] 
      self.rating = page.at("td[@itemprop = 'contentRating']").text 
      self.director = page.at("td[@itemprop = 'director']").css('a').first.text 
      self.genre = page.at("span[@itemprop = 'genre']").text 
      self.runtime = page.at("time[@itemprop = 'duration']").text 
      self.release_date = page.at("td[@itemprop = 'datePublished']")['content'].to_date

      s = page.css('#movieSynopsis').text
      if !(s.valid_encoding?)
        s = s.encode('UTF-16be', invalid: :replace, replace: "?").encode('UTF-8')
      end
      self.synopsis = s

      return true
    rescue Exception => e
      self.failure = 'Something went wrong with the scrape'
    end
  end

  def save_movie
    movie = Movie.new(
      title: self.title,
      hotness: self.hotness,
      image_url: self.image_url,
      rating: self.rating,
      genre: self.genre,
      director: self.director,
      runtime: self.runtime,
      release_date: self.release_date,
      synopsis: self.synopsis
    )
    movie.save
  end
end
