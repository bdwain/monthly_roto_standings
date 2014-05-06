class ActiveStatsConfig
    STATS_URL = "http://games.espn.go.com/flb/playertable/prebuilt/activestats?leagueId=7566&teamId=%d&filter=1&mode=bydate&view=stats&context=activestats"
    STATS_COLS = ["period", nil, nil, nil, nil, "R", "HR", "RBI", nil, "KO", "SB", "AVG", "OBP", "SLG", nil, "IP", nil, nil, "HRA", nil, "K", "W", "SV", "HD", "ERA", "WHIP"]
    LOWER_IS_BETTER = ["KO", "HRA", "ERA", "WHIP"]
    TEAM_NAMES = ['Dong Slammers', 'Bay of Puigs', 'Fat Miggy and the Bastardos', 'Michigan Giant Douche', 'Whole Meal of Food', 'Keli and Pedro', 'Little Orphan Adrian', 'DC se puede', 'Inappropriate NamesAreBadLuck', 'Manager of the Year']
end