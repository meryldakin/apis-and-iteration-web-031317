require 'rest-client'
require 'json'
require 'pry'

def titlecase(string)
  string.split(" ").map(&:capitalize).join(" ")
end

def get_character_weight(character)
  all_characters = RestClient.get('http://www.swapi.co/api/people/')
  character_hash = JSON.parse(all_characters)

  character_hash["results"].each do |chars|
    chars.each do |key, value|
      if character == chars["name"].downcase
        character_titlecase = titlecase(character)
        puts "#{character_titlecase} is a SHOCKING #{chars["mass"]} kg!!"
        return
      end
    end
  end
end

def get_character_movies_from_api(character)
  #make the web request
  all_characters = RestClient.get('http://www.swapi.co/api/people/')
  character_hash = JSON.parse(all_characters)

  film_info = []

  character_hash["results"].each do |chars|
    chars.each do |key, value|
      if character == chars["name"].downcase
        film_info = chars["films"].collect do |film|
          RestClient.get(film)
        end
      end
    end
  end
  film_info
end

def parse_character_movies(films_hash)
  parsed_film = films_hash.collect do |film|
    JSON.parse(film)
  end

  parsed_film.each_with_index do |film, index|
    puts "#{index + 1}. #{film["title"]}"
  end
end



def show_character_movies(character)
  puts "Building film list"
  sleep(1)
  puts "."
  sleep(1)
  puts ".."
  sleep(1)
  puts "..."
  films_hash = get_character_movies_from_api(character)
  parse_character_movies(films_hash)
end
