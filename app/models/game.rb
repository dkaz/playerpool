require 'net/http'
require 'uri'

class Game < ActiveRecord::Base
  before_create :fetch_game_attributes
  after_create :update_player_points
  before_destroy :subtract_player_points
  validates_uniqueness_of :url

  def fetch_game_attributes
    self.json_response = Net::HTTP.get_response(URI.parse(self.url)).body
    response = JSON.parse self.json_response 
    self.away = response[0]['away']['code']
    self.home = response[0]['home']['code']
  end

  def update_player_points
    data = JSON.parse json_response
    ['home', 'away'].each do |side|
      data[0][side]['players']['starters'].each do |p|
        team = Team.find_or_create_by_code(:code => p['teamcode'], :name => data[0][side]['preferred_name'])
        player = Player.find_or_create_by_last_name_and_first_name_and_team_id(p['lastname'], p['firstname'], team.to_param) 
        player.update_attributes! :points => player.points + p['points'].to_i
      end
    end
  end

  def subtract_player_points
    data = JSON.parse json_response
    ['home', 'away'].each do |side|
      data[0][side]['players']['starters'].each do |p|
        team = Team.find_by_code p['teamcode']
        player = Player.where(:last_name => p['lastname'], :first_name => p['firstname'], :team_id => team.to_param).first
        player.update_attributes! :points => player.points - p['points'].to_i
      end
    end
  end
end
