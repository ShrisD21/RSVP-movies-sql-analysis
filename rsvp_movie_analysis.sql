USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:
SELECT 
    'DIRECTOR_MAPPING' AS TABLE_NAME, COUNT(*) AS RECORD_COUNT
FROM
    IMDB.director_mapping 
UNION SELECT 
    'GENRE' AS TABLE_NAME, COUNT(*) AS RECORD_COUNT
FROM
    IMDB.genre 
UNION SELECT 
    'MOVIE' AS TABLE_NAME, COUNT(*) AS RECORD_COUNT
FROM
    IMDB.movie 
UNION SELECT 
    'NAMES' AS TABLE_NAME, COUNT(*) AS RECORD_COUNT
FROM
    IMDB.names 
UNION SELECT 
    'RATINGS' AS TABLE_NAME, COUNT(*) AS RECORD_COUNT
FROM
    IMDB.ratings 
UNION SELECT 
    'ROLE_MAPPING' AS TABLE_NAME, COUNT(*) AS RECORD_COUNT
FROM
    IMDB.role_mapping;









-- Q2. Which columns in the movie table have null values?
-- Type your code below:

SELECT SUM(id_null_count) AS id_null_count,
       SUM(year_null_count) AS year_null_count,
       SUM(title_null_count) AS title_null_count,
       SUM(date_published_null_count) AS date_published_null_count,
       SUM(duration_null_count) AS duration_null_count,
       SUM(country_null_count) AS country_null_count,
       SUM(worlwide_gross_income_null_count) AS worlwide_gross_income_null_count,
       SUM(languages_null_count) AS languages_null_count,
       SUM(production_company_null_count) AS production_company_null_count
FROM
(
    SELECT CASE
               WHEN id IS NULL THEN
                   1
               ELSE
                   0
           END AS id_null_count,
           CASE
               WHEN year IS NULL THEN
                   1
               ELSE
                   0
           END AS year_null_count,
           CASE
               WHEN title IS NULL THEN
                   1
               ELSE
                   0
           END AS title_null_count,
           CASE
               WHEN date_published IS NULL THEN
                   1
               ELSE
                   0
           END AS date_published_null_count,
           CASE
               WHEN duration IS NULL THEN
                   1
               ELSE
                   0
           END AS duration_null_count,
           CASE
               WHEN country IS NULL THEN
                   1
               ELSE
                   0
           END AS country_null_count,
           CASE
               WHEN worlwide_gross_income IS NULL THEN
                   1
               ELSE
                   0
           END AS worlwide_gross_income_null_count,
           CASE
               WHEN languages IS NULL THEN
                   1
               ELSE
                   0
           END AS languages_null_count,
           CASE
               WHEN production_company IS NULL THEN
                   1
               ELSE
                   0
           END AS production_company_null_count
    FROM imdb.movie
) column_count;



-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT year,
       COUNT(*) AS number_of_movies
FROM IMDB.movie
GROUP BY year
ORDER BY year;
--
SELECT MONTH(date_published) AS month_num,
       COUNT(*) AS number_of_movies
FROM IMDB.movie
GROUP BY MONTH(date_published)
ORDER BY MONTH(date_published);








/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:



SELECT COUNT(*) AS NO_OF_MOVIES
FROM IMDB.movie
WHERE year = 2019
      AND (
              UPPER(country) LIKE '%INDIA%' -- upper function is optional in case we are 100% sure that the data is always small case
              OR UPPER(country) LIKE '%USA%'
          );







/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:


SELECT 
    GENRE
FROM
    IMDB.genre
GROUP BY GENRE;





/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

SELECT 
    genre, COUNT(*) AS no_of_movies
FROM
    imdb.genre ge,
    imdb.movie mo
WHERE
    ge.movie_id = mo.id
GROUP BY genre
ORDER BY COUNT(*) DESC
LIMIT 1;








/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

SELECT COUNT(*) as movie_count
FROM
(
    SELECT id
    FROM imdb.genre ge,
         imdb.movie mo
    WHERE ge.movie_id = mo.id
    GROUP BY id
    HAVING COUNT(*) = 1
) single_genre;








/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
SELECT 
    ge.genre, 
    round(AVG(duration),2) AS avg_duration
FROM
    imdb.genre ge,
    imdb.movie mo
WHERE
    ge.movie_id = mo.id
GROUP BY ge.genre
order by AVG(duration) desc; -- optional just for better readability









/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT genre,
       movie_count,
       rn as genre_rank 
       FROM (SELECT 
             count(*) as movie_count,
             ge.genre,
             RANK()
             OVER(ORDER BY count(*) DESC) rn
             FROM
	     imdb.genre ge,
             imdb.movie mo
             WHERE
             ge.movie_id = mo.id
             GROUP BY ge.genre) genre_rank
WHERE
genre ='Thriller';







/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	X|	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

SELECT MIN(avg_rating) AS min_avg_rating,
       MAX(avg_rating) AS max_avg_rating,
       MIN(total_votes) AS min_total_votes,
       MAX(total_votes) AS max_total_votes,
       MIN(median_rating) AS min_median_rating,
       MAX(median_rating) AS max_median_rating
FROM imdb.ratings;




    

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too

-- Using Dense Rank and the output with Rank and dense rank will be different 
SELECT title,
       avg_rating,
       movie_rank
FROM
(
    SELECT mo.title,
           ra.avg_rating AS avg_rating,
           DENSE_RANK() OVER (ORDER BY ra.avg_rating DESC) AS movie_rank
    FROM imdb.movie mo,
         imdb.ratings ra
    WHERE mo.id = ra.movie_id
    GROUP BY title,
             avg_rating
) movie_rank
WHERE movie_rank <= 10;
           





/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have

SELECT 
    ra.median_rating, COUNT(*) AS movie_count
FROM
    imdb.movie mo,
    imdb.ratings ra
WHERE
    mo.id = ra.movie_id
GROUP BY ra.median_rating
ORDER BY ra.median_rating; -- optional
     









/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT 
	production_company,
	movie_count,
	prod_company_rank
FROM
    (
    SELECT 
		mo.production_company, 
		COUNT(*) AS movie_count,
		DENSE_RANK()
		OVER(ORDER BY COUNT(*) DESC) prod_company_rank
	FROM
		imdb.movie mo,
		imdb.ratings ra
	WHERE
         mo.id = ra.movie_id
	AND  ra.avg_rating > 8
	AND  production_company is not null
	GROUP BY mo.production_company
    ) production_company_rank
WHERE prod_company_rank =1;
     







-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT 
    ge.genre, COUNT(*) AS movie_count
FROM
    imdb.genre ge,
    imdb.movie mo,
    imdb.ratings ra
WHERE
    ge.movie_id = mo.id
        AND mo.id = ra.movie_id
        AND mo.year = 2017
        AND MONTH(mo.date_published) = 3
        AND UPPER(country) LIKE '%USA%'
        AND ra.total_votes > 1000
GROUP BY ge.genre
ORDER BY COUNT(*) DESC; -- optional just for data redability







-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT 
    mo.title, ra.avg_rating, ge.genre
FROM
    imdb.genre ge,
    imdb.movie mo,
    imdb.ratings ra
WHERE
    ge.movie_id = mo.id
        AND mo.id = ra.movie_id
        AND UPPER(mo.title) LIKE 'THE%'
        AND ra.avg_rating > 8
ORDER BY ra.avg_rating DESC; -- optional





-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:


SELECT 
    COUNT(*) as movie_count
FROM
    imdb.movie mo,
    imdb.ratings ra
WHERE
         mo.id = ra.movie_id
        AND mo.date_published BETWEEN '2018-04-01' AND '2019-04-01'
        AND ra.median_rating = 8;






-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

SELECT 
    language, SUM(total_votes)
FROM
    (SELECT 
        'GERMAN' AS language, languages, total_votes
    FROM
        imdb.movie mo, imdb.ratings ra
    WHERE
        mo.id = ra.movie_id
            AND UPPER(languages) LIKE '%GERMAN%' UNION ALL SELECT 
        'ITALIAN' AS language, languages, total_votes
    FROM
        imdb.movie mo, imdb.ratings ra
    WHERE
        mo.id = ra.movie_id
            AND UPPER(languages) LIKE '%ITALIAN%') language_total_vote
GROUP BY language;






-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:
SELECT SUM(name_null_count) AS name_nulls,
       SUM(height_null_count) AS height_nulls,
       SUM(date_of_birth_null_count) AS date_of_birth_nulls,
       SUM(known_for_movies_null_count) AS known_for_movies_nulls
FROM
(
    SELECT CASE
               WHEN name IS NULL THEN
                   1
               ELSE
                   0
           END AS name_null_count,
           CASE
               WHEN height IS NULL THEN
                   1
               ELSE
                   0
           END AS height_null_count,
           CASE
               WHEN date_of_birth IS NULL THEN
                   1
               ELSE
                   0
           END AS date_of_birth_null_count,
           CASE
               WHEN known_for_movies IS NULL THEN
                   1
               ELSE
                   0
           END AS known_for_movies_null_count
    FROM imdb.names
) null_column_count;









/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below: CHECK IT
WITH top_3_genre
AS (SELECT genre
    FROM imdb.genre ge,
         imdb.movie mo,
         imdb.ratings ra
    WHERE ge.movie_id = mo.id
          AND ra.movie_id = mo.id
          AND ra.avg_rating > 8
    GROUP BY genre
	ORDER by count(*) desc
	LIMIT 3
   )
SELECT director_name,
       movie_count
from
(
    SELECT dir_name.name as director_name,
           count(distinct mo.id) as movie_count,  -- distinct count of movie coz based on genre there could be the same movie in two genres
           DENSE_RANK() OVER (ORDER BY COUNT(distinct mo.id) DESC) AS RN
    FROM imdb.names dir_name,
         imdb.director_mapping dir_map,
         imdb.movie mo,
         imdb.genre ge,
         imdb.ratings ra
    WHERE dir_name.id = dir_map.name_id
          AND dir_map.movie_id = mo.id
          AND mo.id = ge.movie_id
          AND ra.movie_id = mo.id
          AND ge.genre IN (
                              select genre from top_3_genre
                          )
          AND ra.avg_rating > 8
    GROUP BY NAME
) director_rank
WHERE rn <= 3;



/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT 
    actor_name.name AS actor_name,
    COUNT(*) AS movie_count
FROM
    imdb.names actor_name,
    imdb.role_mapping role,
    imdb.movie mo,
    imdb.ratings ra
WHERE
    actor_name.id = role.name_id
AND role.movie_id = mo.id
AND ra.movie_id = mo.id
AND ra.median_rating >= 8
	GROUP BY actor_name.name
	ORDER BY COUNT(*) DESC
	LIMIT 2;






/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:
SELECT production_company,
       vote_count,
       rn AS prod_comp_rank
FROM   (SELECT production_company,
               Sum(total_votes)                    AS vote_count,
               Dense_rank()
                 OVER (
                   ORDER BY Sum(total_votes) DESC) rn
        FROM   imdb.movie mo,
               imdb.ratings ra
        WHERE  mo.id = ra.movie_id
               AND production_company IS NOT NULL
        GROUP  BY production_company) production_company_rank
WHERE  rn <= 3; 








/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
SELECT name.NAME AS actor_name,
       Sum(ra.total_votes) as total_votes,
       Count(ra.movie_id) AS movie_count,
       Round(Sum(ra.avg_rating * ra.total_votes) / Sum(ra.total_votes), 2) AS actor_avg_rating,
       Rank() OVER (ORDER BY Round(Sum(ra.avg_rating * ra.total_votes) / Sum(ra.total_votes), 2) DESC,
                             Sum(ra.total_votes) DESC
                   ) actor_rank
FROM names name,
     movie mo,
     ratings ra,
     role_mapping role
WHERE mo.country = 'India'
      AND role.category = 'actor'
      AND mo.id = ra.movie_id
      AND mo.id = role.movie_id
      AND name.id = role.name_id
GROUP BY actor_name
HAVING Count(*) >= 5;





-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
SELECT name.NAME AS actress_name,
       Sum(ra.total_votes) as total_votes,
       Count(ra.movie_id) AS movie_count,
       Round(Sum(ra.avg_rating * ra.total_votes) / Sum(ra.total_votes), 2) AS actress_avg_rating,
       Rank() OVER (ORDER BY Round(Sum(ra.avg_rating * ra.total_votes) / Sum(ra.total_votes), 2) DESC,
                             Sum(ra.total_votes) DESC
                   ) actress_rank
FROM names name,
     movie mo,
     ratings ra,
     role_mapping role
WHERE mo.country = 'India'
      AND role.category = 'actress'
      AND mo.languages = 'HINDI'
      AND mo.id = ra.movie_id
      AND mo.id = role.movie_id
      AND name.id = role.name_id
GROUP BY actress_name
HAVING Count(*) >= 3;





/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:
SELECT mo.title,
       avg_rating,
       CASE
           WHEN avg_rating > 8 THEN
               'Superhit movies'
           WHEN avg_rating
                BETWEEN 7 AND 8 THEN
               'Hit movies'
           WHEN avg_rating
                BETWEEN 5 AND 7 THEN
               'One-time-watch movies'
           WHEN avg_rating < 5 THEN
               'Flop movies'
       END AS category
FROM imdb.movie mo,
     imdb.genre ge,
     imdb.ratings ra
WHERE mo.id = ge.movie_id
      AND mo.id = ra.movie_id
      AND genre = 'Thriller';









/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:
SELECT genre,
       ROUND(AVG(mo.duration), 2) as avg_duration,
       SUM(ROUND(AVG(mo.duration), 2)) OVER (ORDER BY ge.genre ROWS UNBOUNDED PRECEDING) as running_total_duration,
       ROUND(AVG(ROUND(AVG(mo.duration), 2)) OVER (ORDER BY ge.genre ROWS 13 PRECEDING), 2) as moving_avg_duration
FROM movie mo,
     genre ge
WHERE mo.id = ge.movie_id
GROUP BY ge.genre
ORDER BY ge.genre;








-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies
-- Assumption here is the data in worlwide_gross_income is all in $ and the INR data is also considered as $ so not converting the data.
WITH top_3_genre
AS (SELECT genre,
           RANK() OVER (ORDER BY count(*) desc) AS rn
    FROM imdb.movie mo,
         imdb.genre ge
    WHERE mo.id = ge.movie_id
          AND worlwide_gross_income IS NOT NULL
    GROUP BY genre
   )
SELECT genre,
       year,
       movie_name,
       worlwide_gross_income,
       movie_rank
FROM
(
    SELECT genre,
           year,
           title as movie_name,
           cast(regexp_substr(worlwide_gross_income, "[0-9]+") as decimal) as worlwide_gross_income,
           DENSE_RANK() OVER (PARTITION BY YEAR
                              ORDER BY cast(regexp_substr(worlwide_gross_income, "[0-9]+") as decimal) DESC
                             ) movie_rank
    FROM imdb.movie mo,
         imdb.genre ge
    WHERE mo.id = ge.movie_id
          AND worlwide_gross_income IS NOT NULL
          AND ge.genre IN (
                              SELECT genre FROM top_3_genre WHERE rn <= 3
                          )
) movie_rank
WHERE movie_rank <= 5;









-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT production_company,
       movie_count,
       prod_comp_rank
FROM
(
    SELECT production_company,
           COUNT(*) as movie_count,
           DENSE_RANK() OVER (ORDER BY count(*) desc) prod_comp_rank
    FROM imdb.movie mo,
         imdb.ratings ra
    WHERE mo.id = ra.movie_id
          AND ra.median_rating >= 8
		  AND POSITION(',' IN mo.languages)>0
          AND production_company is not null
    GROUP BY production_company
) prod_company_rank
WHERE prod_comp_rank <= 2;








-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
-- can use both rank or dense_rank but going with rank function 
SELECT actress_name,
       total_votes,
       movie_count,
       actress_avg_rating,
       actress_rank
FROM
(
    SELECT actor_name.name AS actress_name,
           sum(total_votes) as total_votes,
           COUNT(*) AS movie_count,
           avg(ra.avg_rating) as actress_avg_rating,
           RANK() OVER (ORDER BY COUNT(*) DESC) actress_rank
    FROM imdb.names actor_name,
         imdb.role_mapping role,
         imdb.movie mo,
         imdb.genre ge,
         imdb.ratings ra
    WHERE actor_name.id = role.name_id
          AND role.movie_id = mo.id
          AND mo.id = ge.movie_id
          AND ra.movie_id = mo.id
          AND UPPER(role.category) = 'ACTRESS'
          AND ge.genre = 'Drama'
          AND ra.avg_rating > 8
    GROUP BY actor_name.id
) actress_rank
WHERE actress_rank <= 3;








/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days prev_movie - current movie
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format: 
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:

SELECT Director_id,
       Director_name,
       Number_of_movies,
       Average_inter_movie_days,
       Average_movie_ratings,
       Total_votes,
       Min_rating,
       Max_rating,
       Total_movie_durations
FROM
(
    SELECT Director_id,
           Director_name,
           COUNT(*) AS Number_of_movies,
           round(avg(datediff(prev_movie_date, date_published))) AS Average_inter_movie_days,
           AVG(avg_rating) AS Average_movie_ratings,
           SUM(Total_votes) AS Total_votes,
           MIN(avg_rating) AS Min_rating,
           MAX(avg_rating) AS Max_rating,
           SUM(duration) AS total_movie_durations,
           rank() over (order by count(*) desc) as director_rank
    FROM
    (
        SELECT dir_map.name_id as Director_id,
               name.Name as director_name,
               mo.duration,
               avg_rating,
               total_votes,
               date_published,
               lag(date_published, 1) over (partition by dir_map.name_id order by date_published desc) as prev_movie_date
        FROM imdb.director_mapping dir_map,
             imdb.names name,
             imdb.ratings ra,
             imdb.movie mo
        WHERE dir_map.name_id = name.id
              AND dir_map.movie_id = mo.id
              AND ra.movie_id = mo.id
    ) top_9_directors
    GROUP BY Director_id
) director_rank
WHERE director_rank <= 9;






