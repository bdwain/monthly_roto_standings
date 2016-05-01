require 'nokogiri'
require 'open-uri'
require_relative 'active_stats_config'
require_relative 'team_stats'


class EspnStatsFetcher

    def initialize()
        @num_teams = ActiveStatsConfig::TEAMS.length
    end

    def get_all_team_stats()
        stats = []
        ActiveStatsConfig::TEAMS.keys.each do |team_id|
            stats << get_team_stats(team_id)
        end
        stats
    end

    private

    def get_stats_doc(team_id)
        url = ActiveStatsConfig::STATS_URL % (team_id)
        Nokogiri::HTML(open(url))
    end

    def get_team_stats(team_id)
        raw_stats = get_raw_team_stats(team_id)
        TeamStats.new(team_id, raw_stats)
    end
     
    def get_raw_team_stats(team_id)
        team_stats_doc = get_stats_doc(team_id)
        stats_by_period = {}
        team_stats_doc.xpath('//tr[@class="tableBody"][@bgcolor="#e0e0a8"]').each do |row|
            cols = row.xpath('td')
            stat_row = {}
            ActiveStatsConfig::STATS_COLS.each_with_index do |stat, index|
                stat_row[stat] = cols[index].content if !stat.nil?
            end
            period = fix_period(stat_row.delete("period"))
            stats_by_period[period] = stat_row
        end
        stats_by_period
    end
    
    def fix_period(period_name)
        period_name.chomp(" TOTALS").downcase
    end

end

