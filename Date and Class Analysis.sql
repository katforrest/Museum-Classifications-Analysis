select top 100 * from ArtObjects

---Grouped by cenutry and ordered chronologically
select Classification1, Century, CenturyYear, COUNT(*) as Frequency from ArtObjects
GROUP BY Classification1, Century, CenturyYear
Order by Cast(CenturyYear as INT)

select * from artobjects where Classification1 like 'paintings' and CenturyYear = 1

--review the centuries present
select distinct cast(centuryyear as int), century from artobjects order by cast(centuryyear AS int)

/*
Before we go further, I want to limit my analysis to the most frequently used classifications for better visualizations. 
See the Classifications.sql file where I create the Classification view Class_Frequency using the Classifications table.
*/

/* A review of the records to see if I can limit my analysis to objects that date from 800 BC to now*/
select * from ArtObjects where Cast(CenturyYear as INT) < -1000 or Cast(CenturyYear as INT) > 2101 

select * from ArtObjects where Cast(CenturyYear as INT) < -800 or Cast(CenturyYear as INT) > 2100 
AND Classification1 in (select Classification from Classifications) 

select distinct Classification1 from ArtObjects

---Grouped by cenutry
select Classification1, Century, COUNT(*) as Frequency from ArtObjects 
where Cast(CenturyYear as INT) < -1000 or Cast(CenturyYear as INT) > 2100 
AND Classification1 in (select Classification from Classifications) 
GROUP BY Classification1, Century
Order by Century


---Create a Group By query that contains null values for 0 records using a Left join
SELECT C.Classification1 as Classification, C.Century, COUNT(ArtObjects.Classification1) as Frequency from 
(SELECT 
Classification1, Century
FROM
(Select DISTINCT Classification1 from ArtObjects) AS Classification1,
(Select DISTINCT Century from ArtObjects) AS Century) 
as C
LEFT JOIN 
ArtObjects ON C.Classification1 = ArtObjects.Classification1
AND C.Century = ArtObjects.Century
GROUP BY C.Classification1, C.Century
ORDER BY Frequency desc

Select * from ArtObjects where Classification1 like 'Seals' and century like '21st Century AD'
select * from Class_frequency

/* This view is the same query as above, but it only uses the top 28 classifications from the Classifications table. 
There's a subquery for all distinct values of Century regardless of whether or not there are obejcts in that category. 
This makes it possible to pull a frequency table with a null value for the combinations of Class, Century with no records. */
ALTER VIEW Class_frequency AS
	SELECT C.Classification1 as Classification, C.Century, COUNT(ArtObjects.Classification1) as Frequency from 
		(SELECT Classification1, Century FROM
			(Select DISTINCT Classification1 from ArtObjects where Classification1 in 
				(SELECT Classification from Classifications)) AS Classification1,
			(Select DISTINCT Century from ArtObjects) AS Century)
	as C
	LEFT JOIN 
		ArtObjects ON C.Classification1 = ArtObjects.Classification1 AND C.Century = ArtObjects.Century
	GROUP BY C.Classification1, C.Century

select * from Class_Frequency
select SUM(Frequency) from CLass_Frequency
select * from Classifications

/*Here we join the Class_frequency view to the ArtObjects table in order to add the CenturyYear column.
The result is a frequency table with Classification, Century, century year, and frequency (including nulls)
And I'm thinking about adding in parameters to exclude everything older than 701 BC */
select C.Classification, C.Century, B.CenturyYear, C.Frequency from Class_Frequency C
INNER JOIN (Select distinct Century, CenturyYear from ArtObjects) B on C.Century = B.Century
Where CenturyYear < -701


select C.Classification1 as Classification, C.Century, B.CenturyYear, C.Frequency AS Frequency from Class_Frequency C
INNER JOIN (Select distinct Century, CenturyYear from ArtObjects) B on C.Century = B.Century
Where C.Century <> 'Year 0' AND CenturyYear < -701

select SUM(CenturyYear)  from ArtObjects 

SELECT 
Classification1, Century
FROM
(Select DISTINCT Classification1 from ArtObjects) AS Classification1,
(Select DISTINCT Century, CenturyYear from ArtObjects) AS Century

select ObjectID, ObjectNumber, Department, Classification1 AS Classification, Medium, Century, CenturyYear from ArtObjects 
where CenturyYear > -10000 AND Classification1 in (select Classification from Classifications)


select * from ArtObjects where Department like 'Greek and Roman Art' and Classification1 like 'Terracottas'

select distinct classification1 from artobjects
select * from artobjects where classification1 like 'woodblocks'