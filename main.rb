require './sinatra/head_includes'
require 'sinatra'
require './lib/espn_stats_fetcher'
require './lib/roto_standings'

get '/' do
  @stats = EspnStatsFetcher.new().get_all_team_stats
  @roto_standings = RotoStandings.new(@stats)
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