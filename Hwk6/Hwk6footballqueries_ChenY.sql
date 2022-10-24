USE premier_ChenY;
-- select * from team_venue;
-- select * from manager_info;
-- select * from match_info;

-- Compose queries to answer the following questions 
-- 4. Generate a list of matches for match day 1, in which the home team won. The result should contain the match number, home team and the away team name. (5 points) 
select match_number, match_day, team_name_1 as home_team , team_name_2 as away_team 
from match_info where (match_day = 1) and (fulltimescore_team1 > fulltimescore_team2);

-- 5. Which teams had more than one manager in the season? The result should contain the team name and the number of managers. (5 points) 
select team_name, num_manager 
from(
	select team_name, count(manager_name) as num_manager
	from manager_info group by team_name
    ) as count_table
where num_manager > 1;

-- 6. Which manager/managers worked for more than one team? The result should contain the manager name and number of teams. (5 points) 
select manager_name, num_teams
from(
	select manager_name, count(team_name) as num_teams
	from manager_info group by manager_name
    ) as count_table
where num_teams > 1;

-- 7. Generate a result that contains managers, teams and the number of goals scored by the team in the home stadium for each team for this season. Consider only the active managers. The list should be in descending order of number of goals. The result should contain the manager’s name, the team name, and the number of goals. (5 points) 
select team_name_1, manager_name, num_goals_athome
from(
	select team_name_1, sum(fulltimescore_team1) as num_goals_athome
	from match_info
	group by team_name_1
	) as home_score
left outer join (
				select manager_name, team_name 
                from manager_info
                where managing_status = 'Active'
                ) as team_manager
 on team_name_1 = team_name
 order by num_goals_athome desc;

-- 8. Generate a list consisting of a manager’s name, total number of matches won by the manager in the season. The list should be in descending order of number of matches. Consider only the active managers. (5 points) 
select manager_name, num_wins
from (
	 select manager_name, team_name 
	 from manager_info
	 where managing_status = 'Active'
	 ) as managers
left outer join (
				select team_name, count(team_name) as num_wins
				from (
					 select team_name_1 as team_name, fulltimescore_team1 as team_goal, fulltimescore_team2 as opponent_goal
					 from match_info union all
					 select team_name_2, fulltimescore_team2, fulltimescore_team1
					 from match_info
					 ) as all_team_match
				where team_goal > opponent_goal
				group by team_name
                ) as team_win
using (team_name)
order by num_wins desc;

-- 9. Determine the stadium, where the most number of goals were scored. The result should only contain the stadium name. (5 points) 
select venue_name 
from team_venue 
join(
    select team_name_1 as team_name, sum(fulltimescore_team1)+sum(fulltimescore_team2) as num_goal
    from match_info
    group by team_name_1
    ) as venue_score
using(team_name)
order by num_goal desc
limit 1;

-- 10. Determine the number of matches ended as a draw per team. The result should contain the team name and the number of matches. (5 points)
select team_name, count(team_name) as num_draw_matches
from(
	select team_name_1 as team_name, fulltimescore_team1, fulltimescore_team2
	from match_info union all
	select team_name_2, fulltimescore_team1, fulltimescore_team2
	from match_info
    ) as match_table
where fulltimescore_team1 = fulltimescore_team2
group by team_name
order by num_draw_matches desc;


-- 11. Clean sheets means that the team did not allow an opponent to score a goal in the match. Determine the top 5 teams ranked by number of clean sheets in the season. The result should contain the team’s name and the count of the clean sheets. The result should be ordered in descending order by the count of clean sheets. (5 points) 
select team_name, count(team_name) as num_clean_sheets
from(
	select team_name_1 as team_name, fulltimescore_team1 as team_goal, fulltimescore_team2 as opponent_goal
	from match_info union all
	select team_name_2, fulltimescore_team2, fulltimescore_team1
	from match_info
    ) as match_table
where (opponent_goal = 0) -- and (team_goal > 0)
group by team_name
order by num_clean_sheets desc
LIMIT 5;

-- 12. Generate a list of matches played between Christmas and 3rd January where the home team scored 3 or more goals. Consider the date range 25th December to 3rd January(Including). Display all the fields for the match. (5 points) 
select * from match_info 
where (match_date between '2017-12-25' and '2018-01-03') and (fulltimescore_team1 >= 3);

-- 13. Generate the list of all the matches, where a team came back from losing the game at the end of the first half of the game , to winning at the end of the second half. The result should contain all the columns in the match tuple. (5 points) 
select * from match_info
where (halftimescore_team1 < halftimescore_team2 and fulltimescore_team1 > fulltimescore_team2)
	or (halftimescore_team1 > halftimescore_team2 and fulltimescore_team1 < fulltimescore_team2);

-- 14. Determine the top 5 teams by the number of matches won by the teams. The result should just contain team names. (5 points) 
select team_name
from(
	select team_name, count(team_name) as num_wins
	from(
		select team_name_1 as team_name, fulltimescore_team1 as team_goal, fulltimescore_team2 as opponent_goal
		from match_info union all
		select team_name_2, fulltimescore_team2, fulltimescore_team1
		from match_info
		) as all_team_match
	where team_goal > opponent_goal
	group by team_name
    ) as match_table
order by num_wins desc
LIMIT 5;

-- 15. Write a query that computes for each team the average number of goals conceded at home, the average number of goals scored at home, the average number of goals scored away from home and the average number of goals conceded away from home. (5 points) 
select team_name, concede_at_home, scored_at_home, concede_away_home, scored_away_home
from(
	select team_name_1 as team_name, avg(fulltimescore_team2) as concede_at_home, avg(fulltimescore_team1) as scored_at_home
	from match_info 
    group by team_name
    ) as at_home
join(
	select team_name_2 as team_name, avg(fulltimescore_team1) as concede_away_home, avg(fulltimescore_team2) as scored_away_home
	from match_info
    group by team_name
    ) as away_home
using (team_name);
