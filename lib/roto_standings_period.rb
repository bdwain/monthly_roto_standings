require_relative 'active_stats_config'
require_relative 'team_stats'

class RotoStandingsPeriod
    attr_reader :standings_by_team

    def initialize(period, all_team_stats)
        @period = period
        @all_team_stats = all_team_stats
        @team_ids = all_team_stats.collect { |team_stats| team_stats.team_id }
        @standings_by_team = calculate_standings
    end

    private

    def calculate_standings
        stat_names = TeamStats::get_stat_names
        standings = {}
        stat_names.each do |stat_name|
            standings_for_stat = get_standings_for_stat(stat_name)
            @team_ids.each do |team_id|
                standings[team_id] = {} if standings[team_id].nil?
                standings[team_id][stat_name] = standings_for_stat[team_id]
            end
        end
        totals = calculate_totals(standings)
        
        Hash[@team_ids.collect { |team_id| [team_id, { :by_stat => standings[team_id], :total => totals[team_id] }] }]
            .sort_by { |team_id, data| -data[:total] }
    end

    def calculate_totals(standings)
        totals = {}
        standings.each do |team_id, points_by_stat|
            totals[team_id] = points_by_stat.values.inject(0) { |total, standing| total + standing[:points] }
        end
        totals
    end

    def get_standings_for_stat(stat_name)
        stats_with_teams = []
        @all_team_stats.each do |team_stats|
            stats_with_teams << { :team_id => team_stats.team_id, :val => team_stats.get_stat_for_period(@period, stat_name) }
        end
        stats_with_teams.sort_by! { |x| -x[:val].to_f }
        stats_with_teams.reverse! if ActiveStatsConfig::LOWER_IS_BETTER.include?(stat_name)
        num_teams = @all_team_stats.length
        standings_for_stat = {}
        tied_teams = []
        last_val = nil
        current_points = num_teams
        points_for_tied = 0.0
        stats_with_teams.each do |stat_with_team|
            if !last_val.nil? && stat_with_team[:val].to_f != last_val.to_f
                points = points_for_tied / tied_teams.length
                tied_teams.each do |team_id|
                    standings_for_stat[team_id] = { :points => points, :stat_val => last_val }
                end
                tied_teams = []
                points_for_tied = 0.0
                last_val = nil
            end
            tied_teams << stat_with_team[:team_id]
            last_val = stat_with_team[:val]
            points_for_tied += current_points
            current_points -= 1.0
        end
        points = points_for_tied / tied_teams.length
        tied_teams.each do |team_id|
            standings_for_stat[team_id] = { :points => points, :stat_val => last_val }
        end
        standings_for_stat
    end

end