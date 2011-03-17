require 'net/http'
require 'uri'

class Game < ActiveRecord::Base
  before_create :fetch_game_attributes
  after_create :update_player_points
  before_destroy :subtract_player_points
  validates_uniqueness_of :url

  def fetch_game_attributes
    http_response = Net::HTTP.get_response(URI.parse(self.url))
    raise "ERROR: HTTP RESPONSE STATUS NOT 200: #{http_response.body}" if http_response.code != '200'
    response = JSON.parse http_response.body
    raise "ERROR: EMPTY DATA (#{response.inspect})"  if response.nil? || response.empty? || response[0].nil?
    raise "ERROR: STATUS NOT FINAL (#{response[0]['status']})" if response[0]['status'] != 'FINA' 
    self.away = response[0]['away']['code']
    self.home = response[0]['home']['code']
  end

  def update_player_points
    data = JSON.parse Net::HTTP.get_response(URI.parse(self.url)).body
    ['home', 'away'].each do |side|
      data[0][side]['players']['starters'].each do |p|
        team = Team.find_or_create_by_code(:code => p['teamcode'], :name => data[0][side]['preferred_name'])
        player = Player.find_or_create_by_last_name_and_first_name_and_team_id(p['lastname'], p['firstname'], team.to_param) 
        player.update_attributes! :points => player.points + p['points'].to_i
      end
    end
  end

  def subtract_player_points
    data = JSON.parse Net::HTTP.get_response(URI.parse(self.url)).body
    ['home', 'away'].each do |side|
      data[0][side]['players']['starters'].each do |p|
        team = Team.find_by_code p['teamcode']
        player = Player.where(:last_name => p['lastname'], :first_name => p['firstname'], :team_id => team.to_param).first
        player.update_attributes! :points => player.points - p['points'].to_i
      end
    end
  end
end
