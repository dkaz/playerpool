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
      player = Player.where(:last_name => p['lastname'], :first_name => p['firstname'], :team_id => Team.where(:code => p['teamcode'])).first
      next if player.nil?
      player.update_attributes! :points => player.points + p['points'].to_i
    end
  end
end
