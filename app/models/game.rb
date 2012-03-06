require 'net/http'
require 'uri'

class Game < ActiveRecord::Base
  before_create :fetch_game_attributes
  before_destroy :subtract_player_points
  validates_uniqueness_of :url

  def fetch_game_attributes
    http_response = Net::HTTP.get_response(URI.parse(self.url))
    raise "ERROR: HTTP RESPONSE STATUS NOT 200: #{http_response.body}" if http_response.code != '200'
    response = Nokogiri::HTML(http_response.body)
    raise "ERROR: GAME IS NOT A FINAL" unless response.css('#ysp-reg-box-line_score .final').length > 0
    away_team = response.search("#ysp-reg-box-header .hd h4 a").first.to_html
    home_team = response.search("#ysp-reg-box-header .hd h4 a").last.to_html
    self.away = Team.find_or_create_by_code(:code => away_team.match(/teams\/(.*)\"/)[1], :name => away_team.match(/\">(.*)<\/a>/)[1])
    self.home = Team.find_or_create_by_code(:code => home_team.match(/teams\/(.*)\"/)[1], :name => home_team.match(/\">(.*)<\/a>/)[1])
    away_points = 0
    home_points = 0
    response.css('#ysp-reg-box-game_details-game_stats').css('.bd').first.search('tbody tr').each do |p|
      player_data = p.search('a').to_html
      player = Player.find_or_create_by_yahoo_id(:yahoo_id => player_data.match(/[0-9]+/)[0],
                                                 :last_name => player_data.match(/>.* (.*)<\/a>/)[1],
                                                 :team_id => self.away.to_param)
      player.update_attributes! :points => player.points + p.search('td').last.text.to_i
      away_points += player.points
    end
    response.css('#ysp-reg-box-game_details-game_stats').css('.bd').last.search('tbody tr').each do |p|
      player_data = p.search('a').to_html
      player = Player.find_or_create_by_yahoo_id(:yahoo_id => player_data.match(/[0-9]+/)[0],
                                                 :last_name => player_data.match(/>.* (.*)<\/a>/)[1],
                                                 :team_id => self.home.to_param)
      player.update_attributes! :points => player.points + p.search('td').last.text.to_i
      home_points += player.points
    end
    home_points > away_points ? self.away.update_attributes!(:eliminated => true) : self.home.update_attributes!(:eliminated => true)
  end

  def subtract_player_points
    http_response = Net::HTTP.get_response(URI.parse(self.url))
    response = Nokogiri::HTML(http_response.body)
    away_team = Team.find_by_code response.search("#ysp-reg-box-header .hd h4 a").first.to_html
    home_team = Team.find_by_code response.search("#ysp-reg-box-header .hd h4 a").last.to_html
    response.css('#ysp-reg-box-game_details-game_stats').css('.bd').first.search('tbody tr').each do |p|
      player_data = p.search('a').to_html
      player = Player.find_by_yahoo_id player_data.match(/[0-9]+/)[0]
      player.update_attributes! :points => player.points - p.search('td').last.text.to_i
    end
    response.css('#ysp-reg-box-game_details-game_stats').css('.bd').last.search('tbody tr').each do |p|
      player_data = p.search('a').to_html
      player = Player.find_by_yahoo_id player_data.match(/[0-9]+/)[0]
      player.update_attributes! :points => player.points - p.search('td').last.text.to_i
    end
    self.away.update_attributes!(:eliminated => false)
    self.home.update_attributes!(:eliminated => false)
  end
end
