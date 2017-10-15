### Orank - Rewrite of the GAOC ranking ##
 
Version two is a complete rewrite. Previously, we had a calculation module written in Java and a Ruby on Rails system to display the results. It is now one system. Major changes in the new ranking system:
1. Adding results files can be done from anywhere with an internet connection.
2. Updates to the calculations:
   * Runners initial values were previously set at 50. They are now based on their first race score.
   * If a runner runs Yellow and an advanced course, their Yellow result is moved into a sprint result.
3. Can now import both OE (OE0014) and OR files without modification.
4. News can be remotely added and published.
5. Some news is auto generated.
6. Data store moved to SQLite from MySQL
7. Added the ability to filter rankings by club or school.
8. Added a ‘Pace’ tracking chart to the runner’s detail page.

#### Ranking Methodology
The ranking methodology is derived from Orienteering USA’s methodology. Daily Ranking points earned by competition are calculated as follows: The Course Difficulty is calculated from the average of the Personal Course Difficulty of each competitor, which is the competitor’s ranking points for that race multiplied by their time in minutes.

This calculation is circular, so the Iteration Method is used to determine each competitor’s ranking points.
Competitors initial start points are based on the relative performace of their first race in the calculation period.
The calculations are repeatedly performed until the results converge.
The average Personal Course Difficulty is a harmonic mean, which is the reciprocal of the arithmetic mean of the reciprocals. This causes the results in (a) to converge and results in non-drifting (i.e., significant) results.
Daily Ranking scores of zero are excluded from this iterative calculation process.

#### High School Power Rankings
A school’s “Power” ranking is the combined score of the school’s top 5 runners in each category: Varsity, Junior Varsity, Intermediate

High School ranking scores are normalized by course and gender. The average of the top 10% (minimum of 2) of the runners is set to 100. The runners scores are then normalized to the calculated 100 score. 

##### Varsity
A school's top 5 ranking scores on Red, Green or Brown. If a runner has ranking scores on multiple courses, only their highest score is included. 

##### Junior Varsity
A school's top 5 ranking scores on Orange. A runner cannot be included in Junior Varsity if they are included in the Varsity rankings. 

##### Intermediate
A school’s top 5 ranking scores on Yellow. A runner cannot be included in Intermediate if they are included in the Varsity or Junior Varsity rankings. 

#### Split Analysis 
Split Caclulation:
* Create baseline (Batman)
  * For each split, calculation batman’s time as the harmonic mean of the runners split times.
* Calculate runner’s speed
  * For each split, calculate the runner’s performance as a ratio of batman’s split (batman’s time / runner’s time)
  * Get the harmonic mean for each of the runners scores
  * Remove outliers - any score 20% below their initial harmonic mean
  * Recalculate runners speed with the remaining scores
* Calculate time lost
  * Calculates runners expected time ( batman’s split / speed)
  * If the runners actual time is more that 10% slower that the expected time. The delta is considered time lost.
