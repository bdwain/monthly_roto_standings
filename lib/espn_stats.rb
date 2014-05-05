require 'nokogiri'
require 'open-uri'
 
STATS_URL = "http://games.espn.go.com/flb/playertable/prebuilt/activestats?leagueId=7566&teamId=%d&filter=1&mode=bydate&view=stats&context=activestats"
 
STATS_COLS = ["period", nil, nil, nil, nil, "R", "HR", "RBI", nil, "KO", "SB", "AVG", "OBP", "SLG", nil, "IP", nil, nil, "HRA", nil, "K", "W", "SV", "HD", "ERA", "WHIP"]
 
LOWER_IS_BETTER = ["KO", "HRA", "ERA", "WHIP"]
 
TEAM_NAMES = ['Dong Slammers', 'Bay of Puigs', 'Fat Miggy and the Bastardos', 'Michigan Giant Douche', 'Whole Meal of Food', 'Keli and Pedro', 'Little Orphan Adrian', 'DC se puede', 'Inappropriate NamesAreBadLuck', 'Manager of the Year']

class EspnStats
    def self.get_stats_doc(team_id)
        url = STATS_URL % (team_id + 1)
        Nokogiri::HTML(open(url))
    end
     
    def self.get_all_stats_for_team(team_id)
        team_stats_doc = get_stats_doc(team_id)
        stats_by_period = {}
        team_stats_doc.xpath('//tr[@class="tableBody"][@bgcolor="#e0e0a8"]').each do |row|
            cols = row.xpath('td')
            stat_row = {}
            STATS_COLS.each_with_index do |stat, index|
                stat_row[stat] = cols[index].content if !stat.nil?
            end
            period = stat_row.delete("period")
            stats_by_period[period] = stat_row
        end
        stats_by_period
    end
     
    def self.get_all_team_stats()
        stats = []
        (0..TEAM_NAMES.length - 1).each do |team_id|
            stats[team_id] = get_all_stats_for_team(team_id)
        end
        stats
    end
     
    def self.get_stats_by_period(all_team_stats)
        stats_by_period = {}
        all_team_stats.each_with_index do |team_stat_array, index|
            team_stat_array.each do |period, stats|
                stats_by_period[period] = Array.new(all_team_stats.length) unless stats_by_period.include?(period)
                stats_by_period[period][index] = stats
            end
        end
     
        stats_by_period
    end
     
    def self.get_standings_for_stat(stats, stat_name)
        stats_with_teams = []
        stats.each_with_index do |team_stats, index|
            stats_with_teams << { :team_id => index, :val => team_stats[stat_name].to_f }
        end
        stats_with_teams.sort_by! { |x| -x[:val] }
        stats_with_teams.reverse! if LOWER_IS_BETTER.include?(stat_name)
        num_teams = stats.length
        standings_for_stat = Array.new(num_teams)
        tied_teams = []
        last_val = nil
        current_points = num_teams
        points_for_tied = 0.0
        stats_with_teams.each do |stat_with_team|
            if !last_val.nil? && stat_with_team[:val] != last_val
                points = points_for_tied / tied_teams.length
                tied_teams.each do |team_id|
                    standings_for_stat[team_id] = points
                end
                tied_teams = []
                points_for_tied = 0
                last_val = nil
            end
            tied_teams << stat_with_team[:team_id]
            last_val = stat_with_team[:val]
            points_for_tied += current_points
            current_points -= 1
        end
        points = points_for_tied / tied_teams.length
        tied_teams.each do |team_id|
            standings_for_stat[team_id] = points
        end
        standings_for_stat
    end
     
    def self.get_standings_for_period(stats)
        stat_names = stats[0].keys
        standings_for_period = {}
        stat_names.each do |stat_name|
            standings_for_period[stat_name] = get_standings_for_stat(stats, stat_name)
        end
        standings_for_period
    end
     
    def self.calculate_standings(all_team_stats)
        stats_by_period = get_stats_by_period(all_team_stats)
        
        standings_by_period = {}
        stats_by_period.each do |period, stats|
            standings_by_period[period] = get_standings_for_period(stats)
        end
        standings_by_period
    end

    def self.get_standings_by_team(all_standings)
        new_standings = Hash.new
        all_standings.each do |month, standings|
            cur_month_standings = Array.new(10) {Hash.new}
            standings.each do |stat, scores|
                scores.each_with_index do |score, index|
                    cur_month_standings[index][stat] = score
                end
            end

            new_standings[month] = Hash.new
            cur_month_standings.each_with_index do |team, index|
                new_standings[month][TEAM_NAMES[index]] = team
            end
            new_standings[month] = new_standings[month].sort_by {|name, stats| -1*stats.values.inject(:+)}
        end
        new_standings
    end
end

