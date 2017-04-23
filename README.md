## Orank - Rewrite of the GAOC ranking ##
#  
Algorithm is derived from the OUSA ranking algorithm
#2 Orank 
Daily Ranking points earned by competition are calculated as follows: 
* The Course Difficulty is calculated from the average of the Personal Course Difficulty of each competitor, which is the competitor’s ranking points for that race multiplied by their time in minutes. 
* This calculation is circular, so the Iteration Method is used to determine each competitor’s ranking points.
* The runners initial ranking score will be based on their first race in the ranking period.  If a race does not have three runners with a ranking score.  The ranking scores will be based on the the average of the top three runners time.   
* The average Personal Course Difficulty is a harmonic mean, which is the reciprocal of the arithmetic mean of the reciprocals. This causes the results in (a) to converge and results in non-drifting (i.e., significant) results.
* Daily Ranking scores of zero are excluded from this iterative calculation process.

##$
