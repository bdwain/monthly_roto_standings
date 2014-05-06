require_relative 'roto_standings_period'
require_relative 'team_stats'
require 'date'

class RotoStandings
    attr_reader :standings_by_period
    attr_reader :teams
    attr_reader :stat_names

    def initialize(all_team_stats)
        periods = all_team_stats[0].get_periods
        periods.reject!{|period| period != "totals" && Date::MONTHNAMES.index(period.capitalize) > Date.today.month}
        @teams = Hash[all_team_stats.collect { |team_stats| [team_stats.team_id, team_stats.team_name] }]
        @stat_names = TeamStats::get_stat_names
        @standings_by_period = {}
        periods.each do |period|
            @standings_by_period[period] = RotoStandingsPeriod.new(period, all_team_stats)
        end
    end
end