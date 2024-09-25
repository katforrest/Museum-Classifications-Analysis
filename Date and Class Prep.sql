select * from ArtObjects_Original where Classification like '%|%'

---Take a quick look at the frequency of multi-classed objects in the data.
select Classification, COUNT(*) as Frequency from ArtObjects_Original where classification like '%|%'
GROUP BY Classification
HAVING Count(*) > 3
Order by Frequency

/*Create a new table where objects with multiple classifications are paresed into new columns, using the "|" delimiter.
Note that when there are more than two | delimiters, the data is not parsed at all and remains in the original column. 
But this happened so rarley that I chose to delete the 6 objects with more than 3 classifications instead of adding another column, 
Data cleaning happens in the section below.*/

SELECT Object_ID as ObjectID, Object_Number as ObjectNumber, Department, Classification, 
     REVERSE(PARSENAME(REPLACE(REVERSE(Classification), '|', '.'), 1)) AS [Classification1]
   , REVERSE(PARSENAME(REPLACE(REVERSE(Classification), '|', '.'), 2)) AS [Classification2]
   , REVERSE(PARSENAME(REPLACE(REVERSE(Classification), '|', '.'), 3)) AS [Classification3],
   Medium, Object_Date as ObjDate, Object_Begin_Date as ObjBegin, Object_End_Date as ObjEnd
   INTO ArtObjects1
FROM ArtObjects_Original

---Create a new table where the Classifications are split into Classification and SubClassification, using the delimiter "-"
SELECT 
ObjectID, ObjectNumber, Department, Classification,
       (CASE
         WHEN classification1 LIKE '%-%' THEN LEFT(classification1, Charindex('-', classification1) - 1)
         ELSE classification1
         END) AS Classification1,
       (CASE 
	     WHEN classification1 LIKE '%-%' THEN RIGHT(classification1, Charindex('-', Reverse(classification1)) - 1)
         END) AS SubClass1,

		 (CASE
         WHEN classification2 LIKE '%-%' THEN LEFT(classification2, Charindex('-', classification2) - 1)
         ELSE classification2
         END) AS Classification2,
       (CASE 
	     WHEN classification2 LIKE '%-%' THEN RIGHT(classification2, Charindex('-', Reverse(classification2)) - 1)
         END) AS SubClass2,

		 (CASE
         WHEN classification3 LIKE '%-%' THEN LEFT(classification3, Charindex('-', classification3) - 1)
         ELSE classification3
         END) AS Classification3,
       (CASE 
	     WHEN classification3 LIKE '%-%' THEN RIGHT(classification3, Charindex('-', Reverse(classification3)) - 1)
         END) AS SubClass3,

		 Medium, ObjDate, ObjBegin, ObjEnd
	   INTO ArtObjects2
FROM ArtObjects1

select top 1000 * from ArtObject2 where Classification1 is not null


/* At this point, I renamed ArtObject2 > ArtObjects, and deleted ArtObject1.
I also renamed the date fields to BeginDate and EndDate*/
select * from ArtObjects


/*I wanted to bin the objects by century, using the Begin Date. But using the LEFT() function to group them
didn't work because not all the years are four digit years. I also tried using the ROUND() function to round to the nearest century,
which also didn't work for the same reasons.*/
select classification1, LEFT(ObjBegin, 2), COUNT(*) from ArtObjects
GROUP BY Classification1, LEFT(ObjBegin, 2)
Order by LEFT(ObjBegin, 2)

select
	ROUND(BeginDate, -2) AS Century,
		COUNT(*) as Frequency from ArtObjects
GROUP BY ROUND(BeginDate, -2)
ORDER by Century

/* Instead, I manually created bins using two new columns, "Century" and "Century Year." 
Century is the varchar string, i.e. 3rd century AD. I chose to use AD and BC.
Century Year is a numerical representation of the Century, which can be used for sorting. 
I used a spreadsheet to write these statements. */

ALTER TABLE ArtObjects
ADD CenturyYear AS Case
when BeginDate >=-4100 and BeginDate <=-4001 then '-4100'
when BeginDate >=-4200 and BeginDate <=-4101 then '-4200'
when BeginDate >=-4300 and BeginDate <=-4201 then '-4300'
when BeginDate >=-4400 and BeginDate <=-4301 then '-4400'
when BeginDate >=-4500 and BeginDate <=-4401 then '-4500'
when BeginDate >=-4600 and BeginDate <=-4501 then '-4600'
when BeginDate >=-4700 and BeginDate <=-4601 then '-4700'
when BeginDate >=-4800 and BeginDate <=-4701 then '-4800'
when BeginDate >=-4900 and BeginDate <=-4801 then '-4900'
when BeginDate >=-5000 and BeginDate <=-4901 then '-5000'
when BeginDate >=-5100 and BeginDate <=-5001 then '-5100'
when BeginDate >=-5200 and BeginDate <=-5101 then '-5200'
when BeginDate >=-5300 and BeginDate <=-5201 then '-5300'
when BeginDate >=-5400 and BeginDate <=-5301 then '-5400'
when BeginDate >=-5500 and BeginDate <=-5401 then '-5500'
when BeginDate >=-5600 and BeginDate <=-5501 then '-5600'
when BeginDate >=-5700 and BeginDate <=-5601 then '-5700'
when BeginDate >=-5800 and BeginDate <=-5701 then '-5800'
when BeginDate >=-5900 and BeginDate <=-5801 then '-5900'
when BeginDate >=-6000 and BeginDate <=-5901 then '-6000'
when BeginDate >=-6100 and BeginDate <=-6001 then '-6100'
when BeginDate >=-6200 and BeginDate <=-6101 then '-6200'
when BeginDate >=-6300 and BeginDate <=-6201 then '-6300'
when BeginDate >=-6400 and BeginDate <=-6301 then '-6400'
when BeginDate >=-6500 and BeginDate <=-6401 then '-6500'
when BeginDate >=-6600 and BeginDate <=-6501 then '-6600'
when BeginDate >=-6700 and BeginDate <=-6601 then '-6700'
when BeginDate >=-6800 and BeginDate <=-6701 then '-6800'
when BeginDate >=-6900 and BeginDate <=-6801 then '-6900'
when BeginDate >=-7000 and BeginDate <=-6901 then '-7000'
when BeginDate >=-7100 and BeginDate <=-7001 then '-7100'
when BeginDate >=-7200 and BeginDate <=-7101 then '-7200'
when BeginDate >=-7300 and BeginDate <=-7201 then '-7300'
when BeginDate >=-7400 and BeginDate <=-7301 then '-7400'
when BeginDate >=-7500 and BeginDate <=-7401 then '-7500'
when BeginDate >=-7600 and BeginDate <=-7501 then '-7600'
when BeginDate >=-7700 and BeginDate <=-7601 then '-7700'
when BeginDate >=-7800 and BeginDate <=-7701 then '-7800'
when BeginDate >=-7900 and BeginDate <=-7801 then '-7900'
when BeginDate >=-8000 and BeginDate <=-7901 then '-8000'
when BeginDate >=-4000and BeginDate <=-3901then '-4000'
when BeginDate >=-3900and BeginDate <=-3801then '-3900'
when BeginDate >=-3800and BeginDate <=-3701then '-3800'
when BeginDate >=-3700and BeginDate <=-3601then '-3700'
when BeginDate >=-3600and BeginDate <=-3501then '-3600'
when BeginDate >=-3500and BeginDate <=-3401then '-3500'
when BeginDate >=-3400and BeginDate <=-3301then '-3400'
when BeginDate >=-3300and BeginDate <=-3201then '-3300'
when BeginDate >=-3200and BeginDate <=-3101then '-3200'
when BeginDate >=-3100and BeginDate <=-3001then '-3100'
when BeginDate >=-3000and BeginDate <=-2901then '-3000'
when BeginDate >=-2900and BeginDate <=-2801then '-2900'
when BeginDate >=-2800and BeginDate <=-2701then '-2800'
when BeginDate >=-2700and BeginDate <=-2601then '-2700'
when BeginDate >=-2600and BeginDate <=-2501then '-2600'
when BeginDate >=-2500and BeginDate <=-2401then '-2500'
when BeginDate >=-2400and BeginDate <=-2301then '-2400'
when BeginDate >=-2300and BeginDate <=-2201then '-2300'
when BeginDate >=-2200and BeginDate <=-2101then '-2200'
when BeginDate >=-2100and BeginDate <=-2001then '-2100'
when BeginDate >=-2000and BeginDate <=-1901then '-2000'
when BeginDate >=-1900and BeginDate <=-1801then '-1900'
when BeginDate >=-1800and BeginDate <=-1701then '-1800'
when BeginDate >=-1700and BeginDate <=-1601then '-1700'
when BeginDate >=-1600and BeginDate <=-1501then '-1600'
when BeginDate >=-1500and BeginDate <=-1401then '-1500'
when BeginDate >=-1400and BeginDate <=-1301then '-1400'
when BeginDate >=-1300and BeginDate <=-1201then '-1300'
when BeginDate >=-1200and BeginDate <=-1101then '-1200'
when BeginDate >=-1100and BeginDate <=-1001then '-1100'
when BeginDate >=-1000and BeginDate <=-901then '-1000'
when BeginDate >=-900and BeginDate <=-801then '-900'
when BeginDate >=-800and BeginDate <=-701then '-800'
when BeginDate >=-700and BeginDate <=-601then '-700'
when BeginDate >=-600and BeginDate <=-501then '-600'
when BeginDate >=-500and BeginDate <=-401then '-500'
when BeginDate >=-400and BeginDate <=-301then '-400'
when BeginDate >=-300and BeginDate <=-201then '-300'
when BeginDate >=-200and BeginDate <=-101then '-200'
when BeginDate >=-100and BeginDate <=-1then '-100'
when BeginDate = 0 then '0'
when BeginDate >=1and BeginDate <=100then '1'
when BeginDate >=101and BeginDate <=200then '101'
when BeginDate >=201and BeginDate <=300then '201'
when BeginDate >=301and BeginDate <=400then '301'
when BeginDate >=401and BeginDate <=500then '401'
when BeginDate >=501and BeginDate <=600then '501'
when BeginDate >=601and BeginDate <=700then '601'
when BeginDate >=701and BeginDate <=800then '701'
when BeginDate >=801and BeginDate <=900then '801'
when BeginDate >=901and BeginDate <=1000then '901'
when BeginDate >=1001and BeginDate <=1100then '1001'
when BeginDate >=1101and BeginDate <=1200then '1101'
when BeginDate >=1201and BeginDate <=1300then '1201'
when BeginDate >=1301and BeginDate <=1400then '1301'
when BeginDate >=1401and BeginDate <=1500then '1401'
when BeginDate >=1501and BeginDate <=1600then '1501'
when BeginDate >=1601and BeginDate <=1700then '1601'
when BeginDate >=1701and BeginDate <=1800then '1701'
when BeginDate >=1801and BeginDate <=1900then '1801'
when BeginDate >=1901and BeginDate <=2000then '1901'
when BeginDate >=2001and BeginDate <=2100then '2001'

else ''
END

ALTER TABLE ArtObjects
ADD Century AS
Case
when BeginDate >=-4100and BeginDate <=-4001then '41st Century BC'
when BeginDate >=-4200and BeginDate <=-4101then '42nd Century BC'
when BeginDate >=-4300and BeginDate <=-4201then '43rd Century BC'
when BeginDate >=-4400and BeginDate <=-4301then '44th Century BC'
when BeginDate >=-4500and BeginDate <=-4401then '45th Century BC'
when BeginDate >=-4600and BeginDate <=-4501then '46th Century BC'
when BeginDate >=-4700and BeginDate <=-4601then '47th Century BC'
when BeginDate >=-4800and BeginDate <=-4701then '48th Century BC'
when BeginDate >=-4900and BeginDate <=-4801then '49th Century BC'
when BeginDate >=-5000and BeginDate <=-4901then '50th Century BC'
when BeginDate >=-5100and BeginDate <=-5001then '51st Century BC'
when BeginDate >=-5200and BeginDate <=-5101then '52nd Century BC'
when BeginDate >=-5300and BeginDate <=-5201then '53rd Century BC'
when BeginDate >=-5400and BeginDate <=-5301then '54th Century BC'
when BeginDate >=-5500and BeginDate <=-5401then '55th Century BC'
when BeginDate >=-5600and BeginDate <=-5501then '56th Century BC'
when BeginDate >=-5700and BeginDate <=-5601then '57th Century BC'
when BeginDate >=-5800and BeginDate <=-5701then '58th Century BC'
when BeginDate >=-5900and BeginDate <=-5801then '59th Century BC'
when BeginDate >=-6000and BeginDate <=-5901then '60th Century BC'
when BeginDate >=-6100and BeginDate <=-6001then '61st Century BC'
when BeginDate >=-6200and BeginDate <=-6101then '62nd Century BC'
when BeginDate >=-6300and BeginDate <=-6201then '63rd Century BC'
when BeginDate >=-6400and BeginDate <=-6301then '64th Century BC'
when BeginDate >=-6500and BeginDate <=-6401then '65th Century BC'
when BeginDate >=-6600and BeginDate <=-6501then '66th Century BC'
when BeginDate >=-6700and BeginDate <=-6601then '67th Century BC'
when BeginDate >=-6800and BeginDate <=-6701then '68th Century BC'
when BeginDate >=-6900and BeginDate <=-6801then '69th Century BC'
when BeginDate >=-7000and BeginDate <=-6901then '70th Century BC'
when BeginDate >=-7100and BeginDate <=-7001then '71st Century BC'
when BeginDate >=-7200and BeginDate <=-7101then '72nd Century BC'
when BeginDate >=-7300and BeginDate <=-7201then '73rd Century BC'
when BeginDate >=-7400and BeginDate <=-7301then '74th Century BC'
when BeginDate >=-7500and BeginDate <=-7401then '75th Century BC'
when BeginDate >=-7600and BeginDate <=-7501then '76th Century BC'
when BeginDate >=-7700and BeginDate <=-7601then '77th Century BC'
when BeginDate >=-7800and BeginDate <=-7701then '78th Century BC'
when BeginDate >=-7900and BeginDate <=-7801then '79th Century BC'
when BeginDate >=-8000and BeginDate <=-7901then '80th Century BC'
when BeginDate >=-4000and BeginDate <=-3901then '40th Century BC'
when BeginDate >=-3900and BeginDate <=-3801then '39th Century BC'
when BeginDate >=-3800and BeginDate <=-3701then '38th Century BC'
when BeginDate >=-3700and BeginDate <=-3601then '37th Century BC'
when BeginDate >=-3600and BeginDate <=-3501then '36th Century BC'
when BeginDate >=-3500and BeginDate <=-3401then '35th Century BC'
when BeginDate >=-3400and BeginDate <=-3301then '34th Century BC'
when BeginDate >=-3300and BeginDate <=-3201then '33rd Century BC'
when BeginDate >=-3200and BeginDate <=-3101then '32nd Century BC'
when BeginDate >=-3100and BeginDate <=-3001then '31st Century BC'
when BeginDate >=-3000and BeginDate <=-2901then '30th Century BC'
when BeginDate >=-2900and BeginDate <=-2801then '29th Century BC'
when BeginDate >=-2800and BeginDate <=-2701then '28th Century BC'
when BeginDate >=-2700and BeginDate <=-2601then '27th Century BC'
when BeginDate >=-2600and BeginDate <=-2501then '26th Century BC'
when BeginDate >=-2500and BeginDate <=-2401then '25th Century BC'
when BeginDate >=-2400and BeginDate <=-2301then '24th Century BC'
when BeginDate >=-2300and BeginDate <=-2201then '23rd Century BC'
when BeginDate >=-2200and BeginDate <=-2101then '22nd Century BC'
when BeginDate >=-2100and BeginDate <=-2001then '21st Century BC'
when BeginDate >=-2000and BeginDate <=-1901then '20th Century BC'
when BeginDate >=-1900and BeginDate <=-1801then '19th Century BC'
when BeginDate >=-1800and BeginDate <=-1701then '18th Century  BC'
when BeginDate >=-1700and BeginDate <=-1601then '17th Century  BC'
when BeginDate >=-1600and BeginDate <=-1501then '16th Century  BC'
when BeginDate >=-1500and BeginDate <=-1401then '15th Century  BC'
when BeginDate >=-1400and BeginDate <=-1301then '14th Century  BC'
when BeginDate >=-1300and BeginDate <=-1201then '13th Century  BC'
when BeginDate >=-1200and BeginDate <=-1101then '12th Century BC'
when BeginDate >=-1100and BeginDate <=-1001then '11th Century BC'
when BeginDate >=-1000and BeginDate <=-901then '10th Century BC'
when BeginDate >=-900and BeginDate <=-801then '9th Century BC'
when BeginDate >=-800and BeginDate <=-701then '8th Century BC'
when BeginDate >=-700and BeginDate <=-601then '7th Century BC'
when BeginDate >=-600and BeginDate <=-501then '6th Century BC'
when BeginDate >=-500and BeginDate <=-401then '5th Century BC'
when BeginDate >=-400and BeginDate <=-301then '4th Century BC'
when BeginDate >=-300and BeginDate <=-201then '3rd Century BC'
when BeginDate >=-200and BeginDate <=-101then '2nd Century BC'
when BeginDate >=-100and BeginDate <=-1then '1st Century BC'
when BeginDate =0 then 'Year 0'
when BeginDate >=1and BeginDate <=100 then '1st Century AD'
when BeginDate >=101and BeginDate <=200then '2nd Century AD'
when BeginDate >=201and BeginDate <=300then '3rd Century AD'
when BeginDate >=301and BeginDate <=400then '4th Century AD'
when BeginDate >=401and BeginDate <=500then '5th Century AD'
when BeginDate >=501and BeginDate <=600then '6th Century AD'
when BeginDate >=601and BeginDate <=700then '7th Century AD'
when BeginDate >=701and BeginDate <=800then '8th Century AD'
when BeginDate >=801and BeginDate <=900then '9th Century AD'
when BeginDate >=901and BeginDate <=1000then '10th Century AD'
when BeginDate >=1001and BeginDate <=1100then '11th Century AD'
when BeginDate >=1101and BeginDate <=1200then '12th Century AD'
when BeginDate >=1201and BeginDate <=1300then '13th Century AD'
when BeginDate >=1301and BeginDate <=1400then '14th Century AD'
when BeginDate >=1401and BeginDate <=1500then '15th Century AD'
when BeginDate >=1501and BeginDate <=1600then '16th Century AD'
when BeginDate >=1601and BeginDate <=1700then '17th Century AD'
when BeginDate >=1701and BeginDate <=1800then '18th Century AD'
when BeginDate >=1801and BeginDate <=1900then '19th Century AD'
when BeginDate >=1901and BeginDate <=2000then '20th Century AD'
when BeginDate >=2001and BeginDate <=2100then '21st Century AD'

else ''
END


select * from ArtObjects





/* ~~~~~~~ DATA CLEANING ~~~~~~~~~ */ 

---Quick look at the frequency of classifications in the sample.
select Classification1 as Classification, COUNT(*) as Frequency from ArtObjects
GROUP BY Classification1
Order by Frequency

---Delete 78,717 records with no classification, 406,239 remain
select COUNT(*) from ArtObjects where Classification is null

DELETE from ArtObjects where Classification is null

---Delete 6 records where there were more than 3 classifications, 406,233 remain
select * from ArtObjects where Classification1 is null
DELETE from ArtObjects where Classification1 is null

---Delete rows with dates in the future
select * from ArtObjects where BeginDate > 2200
DELETE from ArtObjects where BeginDate > 2200


select Century, COUNT(*) from ArtObjects GROUP BY Century Order By Century

select Distinct BeginDate from ArtObjects where Century like ''
Order by BeginDate

---Delete 21 objects where BeginDate is older than -10,000 (5 digit year), 406,210 remain
select * from ArtObjects where BeginDate <= -10000
DELETE From ArtObjects where BeginDate <= -10000

select Count(*) from ArtObjects


---Delete 87 records where Classification is "(not assigned)", 406,123 remain
select * from ArtObjects where Classification1 like '(not%'
DELETE from ArtObjects where Classification like '(not assigned)%'



---Delete 1,212 records where BeginDate = 0, 404,911 records remaining
select * from ArtObjects where Century like 'Year 0'
select * from ArtObjects where BeginDate like '0'
select * from ArtObjects where Century like 'Year 0' and EndDate <> '0'
select distinct EndDate from ArtObjects where  Century like 'Year 0' and EndDate <> '0'
Order by EndDate

DELETE from ArtObjects where Century like 'Year 0'
select count(*) from ArtObjects 

/*I wanted to check on these objects because -1005 seemed like a weirdly specific date. 
But looking at these records, I can tell that the cataloger used 1000 +- 5 years to fill out the Begin Date and End Date.*/
select * from ArtObjects where BeginDate like '-1005'

---Total Count = 404,911
select Count(*) from ArtObjects

---Create a Backup Table
SELECT 
		ObjectID, ObjectNumber, Department, Classification, 
		Classification1, SubClass1, Classification2, SubClass2, Classification3, SubClass3,  
		Medium, ObjDate, BeginDate, EndDate, CenturyYear, Century
	   INTO ArtObjects_Backup
FROM ArtObjects

select top 1000 * from ArtObjects_Backup