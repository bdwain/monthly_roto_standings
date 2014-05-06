require_relative 'active_stats_config'

class TeamStats
    attr_reader :team_id
    attr_reader :team_name

    def initialize(team_id, stats_by_period)
        @team_id = team_id
        @team_name = ActiveStatsConfig::TEAM_NAMES[team_id - 1]
        @stats_by_period = stats_by_period
    end

    def get_stat_for_period(period, stat)
        @stats_by_period[period][stat]
    end

    def get_periods()
       @stats_by_period.keys 
    end

    def self.get_stat_names()
        ActiveStatsConfig::STATS_COLS.reject {|stat| stat.nil? || stat == "period" }
    end


end