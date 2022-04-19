/* Data was scraped from BBC website using Selenium library in Python, 
converted to a dataframe using Pandas library(Python) and cleaned. 
It was subsequently imported to MySql for analysis.

Note that the datasets we have here contains data for only the top
5 votes count in all states 

We will create visualizations from data obtained from our analysis with Tableau

Thank you
*/

-- to select the schema we want to extract our data from
USE nig_2019_elections;

-- examining our table
SELECT 
    *
FROM
    nig_elect2019_results;

-- examining the contents of our second table
SELECT 
    *
FROM
    nig_elect2019_voters_num
LIMIT 10;

-- total vote count of all candidates across all states
SELECT 
    candidates, political_party, SUM(votes) AS total_votes
FROM
    nig_elect2019_results
GROUP BY political_party
ORDER BY total_votes DESC;

-- obtaining results for the capital of Nigeria FCT
SELECT 
    *
FROM
    nig_elect2019_results
WHERE
    state_name LIKE '%CT'
ORDER BY votes DESC;

-- number of times each political party was among the top 5 in the various states 
SELECT 
    political_party,
    COUNT(political_party) AS num_of_times_in_top5_across_all_states
FROM
    nig_elect2019_results
GROUP BY political_party
ORDER BY num_of_times_in_top5_across_all_states DESC;

-- difference between the vote count of the winner and other candidates in respective states
SELECT 
	state_name, 
    candidates, 
    political_party, 
    votes,
	MAX(votes) OVER(PARTITION BY state_name) as highest_vote_state,
	MAX(votes) OVER(PARTITION BY state_name) - votes as vote_counts_diff
FROM nig_elect2019_results;

-- creating a temporary table so we can include a new column(region)
CREATE TEMPORARY TABLE vote_region as(
SELECT 
	state_name, 
    candidates, 
    votes, 
    political_party,
	CASE
	WHEN state_name IN ('Benue', 'Kogi', 'Kwara', 'Nasarawa', 'Niger', 'Plateau', 'FCT') THEN 'North Central'
	WHEN state_name IN ('Adamawa', 'Bauchi', 'Borno', 'Gombe', 'Taraba', 'Yobe') THEN 'North East'
	WHEN state_name IN ('Jigawa', 'Kaduna', 'Kano', 'Katsina', 'Kebbi', 'Sokoto', 'Zamfara') THEN 'North West'
	WHEN state_name IN ('Abia', 'Anambra', 'Ebonyi', 'Enugu', 'Imo') THEN 'South East'
	WHEN state_name IN ('Akwa Ibom', 'Bayelsa', 'Cross River', 'Delta', 'Edo', 'Rivers') THEN 'South South'
	ELSE 'South West'
	END as regions
FROM nig_elect2019_results);

-- viewing our temp table
SELECT 
    *
FROM
    vote_region
LIMIT 10;

-- top 2 votes count of candidates by state
SELECT s.state_name, s.candidates, s.political_party, s.votes, 
s.regions, s.position_rank
FROM (
	SELECT state_name, candidates, political_party, votes, regions,
	RANK() OVER(PARTITION BY state_name ORDER BY votes DESC) as position_rank
	FROM vote_region) s
WHERE s.position_rank IN ('1', '2');

-- winners in each state 
SELECT 
    state_name,
    candidates,
    political_party AS winner_of_election,
    regions AS state_region,
    MAX(votes) AS num_votes_winner
FROM
    vote_region
GROUP BY state_name
ORDER BY state_name;

-- total votes of top 2 political parties across all states
SELECT 
    political_party, SUM(votes) AS total_votes_across_states
FROM
    vote_region
GROUP BY political_party
ORDER BY total_votes_across_states DESC
LIMIT 2;

-- comparing votes count of parties from all regions
SELECT a.political_party, a.regions, a.total_votes,a.next_highest_votes
FROM(
	SELECT b.political_party, b.regions,b.total_votes,
    LEAD(total_votes) OVER(PARTITION BY b.regions ORDER BY b.total_votes DESC) as next_highest_votes
		FROM(
			SELECT political_party, regions, votes, SUM(votes) as total_votes
			FROM vote_region
			GROUP BY regions, political_party
			ORDER BY regions, total_votes DESC) b) a;
 
-- number of states won by each political party
SELECT 
	p.political_party, 
    COUNT(p.political_party) as num_of_states_won
FROM (
	SELECT 
		state_name,
        political_party, 
        MAX(votes) as num_of_vote_of_winner
	FROM nig_elect2019_results
	GROUP BY state_name
	ORDER BY state_name) p
GROUP BY p.political_party
ORDER BY num_of_states_won DESC;

-- percent of valid votes in all states
SELECT 
    states,
    accredited_votes,
    valid_votes,
    (valid_votes / accredited_votes) * 100 AS percent_of_valid_vote
FROM
    nig_elect2019_voters_num
ORDER BY states;

-- vote count for other political parties excluding the top 5 in all states
SELECT 
    r.state_name,
    n.accredited_votes,
    n.valid_votes,
    SUM(r.votes) AS total_vote_count_of_top5_pol_party,
    n.valid_votes - SUM(r.votes) AS vote_count_for_other_parties
FROM
    nig_elect2019_results r
        JOIN
    nig_elect2019_voters_num n ON r.state_name = n.states
GROUP BY r.state_name
ORDER BY state_name;

-- states with more than 1 million votes
SELECT 
    state_name, SUM(votes) AS total_votes
FROM
    nig_elect2019_results
GROUP BY state_name
HAVING total_votes >= 1000000;

-- total valid and invalid votes for the election
SELECT 
    SUM(accredited_votes) AS total_accredited_voters,
    SUM(valid_votes) AS total_valid_votes,
    SUM(accredited_votes) - SUM(valid_votes) AS invalid_votes
FROM
    nig_elect2019_voters_num;



