require './sinatra/head_includes'
require 'sinatra'
require './lib/espn_stats'

get '/' do
  @stats = EspnStats.get_all_team_stats
  @standings = EspnStats.calculate_standings(@stats)
  @player_standings = EspnStats.get_standings_by_team(@standings)
  js :jquery, :tablesorter, :stats
  css :tablesorter
  erb :index
end

not_found do
  erb "That's not a valid page"
end

error do
  erb "Error: " + env['sinatra.error'].message
end