class ActiveStatsConfig
    STATS_URL = "http://games.espn.go.com/flb/playertable/prebuilt/activestats?leagueId=7566&teamId=%d&filter=1&mode=bydate&view=stats&context=activestats"
    STATS_COLS = ["period", nil, nil, nil, nil, "R", "HR", "RBI", nil, "KO", "SB", "AVG", "OBP", "SLG", nil, "IP", nil, nil, "HRA", nil, "K", "W", "SV", "HD", "ERA", "WHIP"]
    LOWER_IS_BETTER = ["KO", "HRA", "ERA", "WHIP"]
    MONTH_COMBOS = [{m1: 'september', m2: 'october', combo_name: 'September/October'}]
    TEAMS = {1 =>'Dong Slammers', 2 => 'Bay of Puigs', 3 => 'Fat Miggy and the Bastardos', 4 => 'Michigan Giant Douche',
      7 => 'Hollywoo Stars and Celebrities', 8 => 'DC se puede', 9 => 'Inappropriate NamesAreBadLuck', 10 => 'Manager of the Year'}
end