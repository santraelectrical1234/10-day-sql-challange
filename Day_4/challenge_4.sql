# Challenge-04

/* Samantha interviews many
candidates from different colleges using coding challenges and contests. Write
a query to print the contest_id, emp_id, name, and the
sums of t_submission, t_accept_submissions, t_views, and t_unique_views
for each contest sorted by contest_id. Exclude the contest from the
result if all four sums are 0. */

/* Note: A specific contest can
be used to screen candidates at more than one college, but each college only
holds 1 screening contest. The DDL Command is given by – */

create database interview_db;

use interview_db;

create table contests (
contest_id int,
emp_id int,
name char(20));

insert into contests (contest_id, emp_id, name)
values 
(66406, 17973, "Pat"),
(66556, 79153, "Julia"),
(94828, 80275, "Matt");

create table colleges (
college_id int,
contest_id int);

insert into colleges (college_id, contest_id)
values 
(11219, 66406),
(32473, 66556),
(56685, 94828);

create table challenges (
challenge_id int,
college_id int);

insert into challenges (challenge_id, college_id)
values 
(18765, 11219),
(47127, 11219),
(60292, 32473),
(72974, 56685);

create table view_stats (
challenge_id int,
t_views int,
t_unique_views int);

insert into view_stats (challenge_id, t_views, t_unique_views)
values 
(47127, 26, 19),
(47127, 15, 14),
(18765, 43, 10),
(18765, 72, 13),
(75516, 35, 17),
(60292, 11, 10),
(72974, 41, 15),
(75516, 75, 11);

create table submission_stats (
challenge_id int,
t_submissions int,
t_accept_submissions int);

insert into submission_stats (challenge_id,
t_submissions, t_accept_submissions)
values 
(75516, 34, 12),
(47127, 27, 10),
(47127, 56, 18),
(75516, 74, 12),
(75516, 83, 8),
(72974, 68, 24),
(72974, 82, 14),
(47127, 28, 11);
select * from challenges;
select * from colleges;
select * from contests;
select * from submission_stats;
select * from view_stats;
/*. Write
a query to print the contest_id, emp_id, name, and the
sums of t_submission, t_accept_submissions, t_views, and t_unique_views
for each contest sorted by contest_id. Exclude the contest from the
result if all four sums are 0. */

SELECT c1.contest_id, emp_id, name, 
  COALESCE(SUM(t_submissions), 0) AS sum_t_submissions, 
  COALESCE(SUM(t_accept_submissions), 0) AS sum_t_accept_submissions, 
  COALESCE(SUM(t_views), 0) AS sum_t_views, 
  COALESCE(SUM(t_unique_views), 0) AS sum_t_unique_views
FROM contests c1 inner join colleges c2 USING(contest_id)
inner join challenges c3 USING(college_id)
LEFT JOIN view_stats v USING(challenge_id)
LEFT JOIN submission_stats s USING(challenge_id)
GROUP BY c1.contest_id, emp_id, name
HAVING 
    SUM(t_submissions) > 0 OR
    SUM(t_accept_submissions) > 0 OR
    SUM(t_views) > 0 OR
    SUM(t_unique_views) > 0
ORDER BY c1.contest_id;
































/*chatgpt*/





































SELECT c.contest_id, c.emp_id, c.name,
       SUM(s.t_submissions) AS total_submissions,
       SUM(s.t_accept_submissions) AS total_accept_submissions,
       SUM(v.t_views) AS total_views,
       SUM(v.t_unique_views) AS total_unique_views
FROM contests c
LEFT JOIN submission_stats s ON c.contest_id = s.challenge_id
LEFT JOIN view_stats v ON c.contest_id = v.challenge_id
GROUP BY c.contest_id, c.emp_id, c.name
HAVING 
    SUM(s.t_submissions) + SUM(s.t_accept_submissions) +
    SUM(v.t_views) + SUM(v.t_unique_views) > 0
ORDER BY c.contest_id;