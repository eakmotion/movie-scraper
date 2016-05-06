class Scrape
  attr_accessor :title, :hotness, :image_url, :synopsis, :rating, :genre, 
                :director, :runtime, :release_date, :failure

  def scrape_new_movie(url)
    begin
      page = Nokogiri::HTML(open(url))
      page.css('script').remove

      self.title = page.at("h1[@itemprop = 'name']").text
      self.hotness = page.at("span[@itemprop = 'ratingValue']").text.to_i
      self.image_url = page.at_css('#movie-image-section img')['src'] 
      self.rating = page.at("td[@itemprop = 'contentRating']").text 
      self.director = page.at("td[@itemprop = 'director']").css('a').first.text 
      self.genre = page.at("span[@itemprop = 'genre']").text 
      self.runtime = page.at("time[@itemprop = 'duration']").text 
      self.release_date = page.at("td[@itemprop = 'datePublished']")['content'].to_date
      self.synopsis = page.css('#movieSynopsis').text.tidy_bytes

      return true
    rescue Exception => e
      self.failure = 'Something went wrong with the scrape'
    end
  end
end
