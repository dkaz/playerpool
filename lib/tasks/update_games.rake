require 'net/http'
require 'uri'
require 'cgi'
require 'json'

desc "Update games for date"
task :update_games, :day, :needs => :environment do |t,args|
  day = args[:day] ? Date.parse(args[:day]) : Date.today
  puts "Finding games on #{day.to_s}"
  url = "http://api.fanfeedr.com/basic/v1/games_on_date?date=#{day.to_s}&appId=ybvmwcag2xz9t7f2sagcmy4x&format=json&resource=#{CGI.escape("league://ncaa_basketball")}"
  response = Net::HTTP.get_response(URI.parse(url))
  if response.code != '200'
    puts "HTTP RESPONSE STATUS NOT 200: #{response.body}"
    exit
  end
  games = JSON.parse response.body
  resources = games.collect{|g| g['resource']}
  puts "Found #{resources.count} games"
  resources.each do |r|
    begin
      Game.find_or_create_by_url "http://api.fanfeedr.com/basic/v1/boxscore?format=json&resource=#{r}&appId=ybvmwcag2xz9t7f2sagcmy4x"
    rescue Exception => e
      print "\n"
      puts e.message
    end
    print '.'
  end
  puts
end
