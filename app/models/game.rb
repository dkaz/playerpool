require 'net/http'
require 'uri'

class Game < ActiveRecord::Base
  before_create :fetch_game_attributes
  after_create :update_player_points
  validates_uniqueness_of :url

  def fetch_game_attributes
    self.json_response = JSON.parse Net::HTTP.get_response(URI.parse(self.url)).body
    self.away = json_response[0]['away']['code']
    self.home = json_response[0]['home']['code']
  end

  def update_player_points
    players = json_response[0]['away']['players']['starters'] + json_response[0]['home']['players']['starters']
    players.each do |p|
      team = Team.where :code => p['teamcode']
      raise 'Unable to find team' if team.nil?
      player = Player.find_or_create p['lastname'], p['firstname'], team 
      player.update_attributes! :points => player.points + p['points'].to_i
    end
  end
end
