require 'net/http'
require 'uri'
require 'nokogiri'

namespace :data do
  desc "load all teams"
  task :load_teams, :needs => :environment do
    begin
      response = Net::HTTP.get_response(URI.parse("http://rivals.yahoo.com/ncaa/basketball/teams"))
      doc = Nokogiri::HTML(response.body)
      doc.search("a").each do |line|
        if line.to_html.match(/ncaab\/teams\//)
          name = line.inner_html.gsub(/&#160;/, ' ').gsub(/&amp;/, '&').gsub(/&nbsp;/, ' ')
          puts "creating #{name}"
          Team.create :code => line.to_html.match(/ncaab\/teams\/(.*)\"/)[1], :name => name
        end 
      end 
    rescue => e
      puts "Caught exception finding all the teams: #{e}"
    end 
  end

  desc "load all players"
  task :load_players, :needs => :environment do
    Team.all.each do |team|
      begin
        puts "loading #{team}"
        response = Net::HTTP.get_response(URI.parse("http://rivals.yahoo.com/ncaa/basketball/teams/#{team.code}/roster"))
        doc = Nokogiri::HTML(response.body)
        teamname = doc.search("title").first.inner_html.split(' -').first
        doc.search("td a").each do |a| 
          if a.to_html.match(/ncaab\/players\//)
            name = a.inner_html.split(', ').reverse
            id = a['href'].match(/[0-9]+/)[0]
            puts " creating #{name.join(' ')}"
            Player.create :yahoo_id => id, :team_id => team.to_param, :first_name => name.first, :last_name => name.last 
          end 
        end 
      rescue => e
        puts "Caught exception finding all the players for #{team}: #{e}"
      end 
    end
  end
end
