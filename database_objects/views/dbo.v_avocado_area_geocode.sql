USE [EC_BA380_DA]
GO

/****** Object:  View [dbo].[v_avocado_area_geocode]    Script Date: 2/3/2020 2:55:19 PM ******/
DROP VIEW [dbo].[v_avocado_area_geocode]
GO

/****** Object:  View [dbo].[v_avocado_area_geocode]    Script Date: 2/3/2020 2:55:19 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[v_avocado_area_geocode]
AS

/*****************************************************************************************************************
NAME:    dbo.v_avocado_area_geocode
PURPOSE: Create the dbo.v_avocado_area_geocode view

MODIFICATION LOG:
Ver      Date        Author        Description
-----   ----------   -----------   -------------------------------------------------------------------------------
1.0     02/03/2020   JJAUSSI       1. Built this view for LDS BC BA280



RUNTIME: 
Approx. 1 sec


NOTES: 
The purpose of this view is to take the "region" names from the avocado data and assign a specific logical
geocode (latitude and longitude) to each. The objective here is to consume the avocado price data inside 
Power BI and one key requirement is a map-based reporting.

The initial step was to recognize that many of the "region" values could logically be assigned a specific 
City and State
Albany = Albany, NY

No direct City to State mapping data exists in the avocado data. So a number of logical assumptions must be made to create the mapping.
While it is true that some city names exist -
in more than one state (San Diego for example is a city in CA and TX) my working assumption was to use the 
most populous and widely recognized City/Sate combination (San Diego -> CA).

The next step was to deal with "region" values that are apparently a compound of primarily two cities probably referring
to a metropolitan area (MiamiFtLauderdale is an example). In these cases, I simply choose the first city name:
MiamiFtLauderdale = Miami and Ft. Lauderdale Florida = Miami

Next I dealt with the "region" values that implied a much larger geographic area and selected a representative
State and city (often that State's capitol city) with an emphasis on selecting City/State combinations not already
covered by other rows:
GreatLakes = Madison, WI

This resolved all 54 "region" values into a specific City and State. I rebranded "region" as area and segmented
the smaller more city specific values as "city" (42) and the larger less city specific values as "region" (12).

Once that work was done, I selected the first numeric (min) zip code for each City/State combination and used that
zip code's latitude and longitude as the geocode for the now rebranded avocado area. My working assumption here is 
that all geocodes for a given zip code where of equal value for the purpose and granularity of the Power BI
mapping requirement: this is a higher level view of the mapping designed to give us knowledge about the look and feel of the avocado data on a map



LICENSE: 
This code is covered by the GNU General Public License which guarantees end users
the freedom to run, study, share, and modify the code. This license grants the recipients
of the code the rights of the Free Software Definition. All derivative work can only be
distributed under the same license terms.
 
******************************************************************************************************************/

     WITH s1
          AS (SELECT DISTINCT 
                     a.region AS area_name
                   , CASE
                         WHEN a.region IN(
                                 --'Albany',
                                 --'Atlanta',
                                 --'BaltimoreWashington',
                                 --'Boise',
                                 --'Boston',
                                 --'BuffaloRochester',
                                 'California',
                                 --'Charlotte',
                                 --'Chicago',
                                 --'CincinnatiDayton',
                                 --'Columbus',
                                 --'DallasFtWorth',
                                 --'Denver',
                                 --'Detroit',
                                 --'GrandRapids',
                                 'GreatLakes',
                                 --'HarrisburgScranton',
                                 --'HartfordSpringfield',
                                 --'Houston',
                                 --'Indianapolis',
                                 --'Jacksonville',
                                 --'LasVegas',
                                 --'LosAngeles',
                                 --'Louisville',
                                 --'MiamiFtLauderdale',
                                 'Midsouth',
                                 --'Nashville',
                                 --'NewOrleansMobile',
                                 --'NewYork',
                                 'Northeast', 'NorthernNewEngland',
                                 --'Orlando',
                                 --'Philadelphia',
                                 --'PhoenixTucson',
                                 --'Pittsburgh',
                                 'Plains',
                                 --'Portland',
                                 --'RaleighGreensboro',
                                 --'RichmondNorfolk',
                                 --'Roanoke',
                                 --'Sacramento',
                                 --'SanDiego',
                                 --'SanFrancisco',
                                 --'Seattle',
                                 'SouthCarolina', 'SouthCentral', 'Southeast',
                                 --'Spokane',
                                 --'StLouis',
                                 --'Syracuse',
                                 --'Tampa',
                                 'TotalUS', 'West', 'WestTexNewMexico')
                         THEN 'region'
                         ELSE 'city'
                     END AS area_type
                FROM dbo.avocado AS a),
          s2
          AS (SELECT ROW_NUMBER() OVER(
                     ORDER BY s1.area_name ASC) AS area_id
                   , s1.area_name
                   , s1.area_type
                   , CASE
                         WHEN s1.area_name = 'Albany'
                         THEN 'Albany'
                         WHEN s1.area_name = 'Atlanta'
                         THEN 'Atlanta'
                         WHEN s1.area_name = 'BaltimoreWashington'
                         THEN 'Baltimore'
                         WHEN s1.area_name = 'Boise'
                         THEN 'Boise'
                         WHEN s1.area_name = 'Boston'
                         THEN 'Boston'
                         WHEN s1.area_name = 'BuffaloRochester'
                         THEN 'Buffalo'
                         WHEN s1.area_name = 'California'
                         THEN 'Fresno'
                         WHEN s1.area_name = 'Charlotte'
                         THEN 'Charlotte'
                         WHEN s1.area_name = 'Chicago'
                         THEN 'Chicago'
                         WHEN s1.area_name = 'CincinnatiDayton'
                         THEN 'Cincinnati'
                         WHEN s1.area_name = 'Columbus'
                         THEN 'Columbus'
                         WHEN s1.area_name = 'DallasFtWorth'
                         THEN 'Dallas'
                         WHEN s1.area_name = 'Denver'
                         THEN 'Denver'
                         WHEN s1.area_name = 'Detroit'
                         THEN 'Detroit'
                         WHEN s1.area_name = 'GrandRapids'
                         THEN 'Grand Rapids'
                         WHEN s1.area_name = 'GreatLakes'
                         THEN 'Madison'
                         WHEN s1.area_name = 'HarrisburgScranton'
                         THEN 'Harrisburg'
                         WHEN s1.area_name = 'HartfordSpringfield'
                         THEN 'Hartford'
                         WHEN s1.area_name = 'Houston'
                         THEN 'Houston'
                         WHEN s1.area_name = 'Indianapolis'
                         THEN 'Indianapolis'
                         WHEN s1.area_name = 'Jacksonville'
                         THEN 'Jacksonville'
                         WHEN s1.area_name = 'LasVegas'
                         THEN 'Las Vegas'
                         WHEN s1.area_name = 'LosAngeles'
                         THEN 'Los Angeles'
                         WHEN s1.area_name = 'Louisville'
                         THEN 'Louisville'
                         WHEN s1.area_name = 'MiamiFtLauderdale'
                         THEN 'Miami'
                         WHEN s1.area_name = 'Midsouth'
                         THEN 'Jefferson City'
                         WHEN s1.area_name = 'Nashville'
                         THEN 'Nashville'
                         WHEN s1.area_name = 'NewOrleansMobile'
                         THEN 'New Orleans'
                         WHEN s1.area_name = 'NewYork'
                         THEN 'New York'
                         WHEN s1.area_name = 'Northeast'
                         THEN 'Concord'
                         WHEN s1.area_name = 'NorthernNewEngland'
                         THEN 'Augusta'
                         WHEN s1.area_name = 'Orlando'
                         THEN 'Orlando'
                         WHEN s1.area_name = 'Philadelphia'
                         THEN 'Philadelphia'
                         WHEN s1.area_name = 'PhoenixTucson'
                         THEN 'Phoenix'
                         WHEN s1.area_name = 'Pittsburgh'
                         THEN 'Pittsburgh'
                         WHEN s1.area_name = 'Plains'
                         THEN 'Helena'
                         WHEN s1.area_name = 'Portland'
                         THEN 'Portland'
                         WHEN s1.area_name = 'RaleighGreensboro'
                         THEN 'Raleigh'
                         WHEN s1.area_name = 'RichmondNorfolk'
                         THEN 'Richmond'
                         WHEN s1.area_name = 'Roanoke'
                         THEN 'Roanoke'
                         WHEN s1.area_name = 'Sacramento'
                         THEN 'Sacramento'
                         WHEN s1.area_name = 'SanDiego'
                         THEN 'San Diego'
                         WHEN s1.area_name = 'SanFrancisco'
                         THEN 'San Francisco'
                         WHEN s1.area_name = 'Seattle'
                         THEN 'Seattle'
                         WHEN s1.area_name = 'SouthCarolina'
                         THEN 'Columbia'
                         WHEN s1.area_name = 'SouthCentral'
                         THEN 'Oklahoma City'
                         WHEN s1.area_name = 'Southeast'
                         THEN 'Jackson'
                         WHEN s1.area_name = 'Spokane'
                         THEN 'Spokane'
                         WHEN s1.area_name = 'StLouis'
                         THEN 'Saint Louis'
                         WHEN s1.area_name = 'Syracuse'
                         THEN 'Syracuse'
                         WHEN s1.area_name = 'Tampa'
                         THEN 'Tampa'
                         WHEN s1.area_name = 'TotalUS'
                         THEN 'Lebanon'
                         WHEN s1.area_name = 'West'
                         THEN 'Salt Lake City'
                         WHEN s1.area_name = 'WestTexNewMexico'
                         THEN 'Albuquerque'
                         ELSE 'UNKNOWN'
                     END AS city_resolve
                   , CASE
                         WHEN s1.area_name = 'Albany'
                         THEN 'NY'
                         WHEN s1.area_name = 'Atlanta'
                         THEN 'GA'
                         WHEN s1.area_name = 'BaltimoreWashington'
                         THEN 'MD'
                         WHEN s1.area_name = 'Boise'
                         THEN 'ID'
                         WHEN s1.area_name = 'Boston'
                         THEN 'MA'
                         WHEN s1.area_name = 'BuffaloRochester'
                         THEN 'NY'
                         WHEN s1.area_name = 'California'
                         THEN 'CA'
                         WHEN s1.area_name = 'Charlotte'
                         THEN 'NC'
                         WHEN s1.area_name = 'Chicago'
                         THEN 'IL'
                         WHEN s1.area_name = 'CincinnatiDayton'
                         THEN 'OH'
                         WHEN s1.area_name = 'Columbus'
                         THEN 'OH'
                         WHEN s1.area_name = 'DallasFtWorth'
                         THEN 'TX'
                         WHEN s1.area_name = 'Denver'
                         THEN 'CO'
                         WHEN s1.area_name = 'Detroit'
                         THEN 'MI'
                         WHEN s1.area_name = 'GrandRapids'
                         THEN 'MI'
                         WHEN s1.area_name = 'GreatLakes'
                         THEN 'WI'
                         WHEN s1.area_name = 'HarrisburgScranton'
                         THEN 'PA'
                         WHEN s1.area_name = 'HartfordSpringfield'
                         THEN 'CT'
                         WHEN s1.area_name = 'Houston'
                         THEN 'TX'
                         WHEN s1.area_name = 'Indianapolis'
                         THEN 'IN'
                         WHEN s1.area_name = 'Jacksonville'
                         THEN 'FL'
                         WHEN s1.area_name = 'LasVegas'
                         THEN 'NV'
                         WHEN s1.area_name = 'LosAngeles'
                         THEN 'CA'
                         WHEN s1.area_name = 'Louisville'
                         THEN 'KY'
                         WHEN s1.area_name = 'MiamiFtLauderdale'
                         THEN 'FL'
                         WHEN s1.area_name = 'Midsouth'
                         THEN 'MO'
                         WHEN s1.area_name = 'Nashville'
                         THEN 'TN'
                         WHEN s1.area_name = 'NewOrleansMobile'
                         THEN 'LA'
                         WHEN s1.area_name = 'NewYork'
                         THEN 'NY'
                         WHEN s1.area_name = 'Northeast'
                         THEN 'NH'
                         WHEN s1.area_name = 'NorthernNewEngland'
                         THEN 'ME'
                         WHEN s1.area_name = 'Orlando'
                         THEN 'FL'
                         WHEN s1.area_name = 'Philadelphia'
                         THEN 'PA'
                         WHEN s1.area_name = 'PhoenixTucson'
                         THEN 'AZ'
                         WHEN s1.area_name = 'Pittsburgh'
                         THEN 'PA'
                         WHEN s1.area_name = 'Plains'
                         THEN 'MT'
                         WHEN s1.area_name = 'Portland'
                         THEN 'OR'
                         WHEN s1.area_name = 'RaleighGreensboro'
                         THEN 'NC'
                         WHEN s1.area_name = 'RichmondNorfolk'
                         THEN 'VA'
                         WHEN s1.area_name = 'Roanoke'
                         THEN 'VA'
                         WHEN s1.area_name = 'Sacramento'
                         THEN 'CA'
                         WHEN s1.area_name = 'SanDiego'
                         THEN 'CA'
                         WHEN s1.area_name = 'SanFrancisco'
                         THEN 'CA'
                         WHEN s1.area_name = 'Seattle'
                         THEN 'WA'
                         WHEN s1.area_name = 'SouthCarolina'
                         THEN 'SC'
                         WHEN s1.area_name = 'SouthCentral'
                         THEN 'OK'
                         WHEN s1.area_name = 'Southeast'
                         THEN 'MS'
                         WHEN s1.area_name = 'Spokane'
                         THEN 'WA'
                         WHEN s1.area_name = 'StLouis'
                         THEN 'MO'
                         WHEN s1.area_name = 'Syracuse'
                         THEN 'NY'
                         WHEN s1.area_name = 'Tampa'
                         THEN 'FL'
                         WHEN s1.area_name = 'TotalUS'
                         THEN 'KS'
                         WHEN s1.area_name = 'West'
                         THEN 'UT'
                         WHEN s1.area_name = 'WestTexNewMexico'
                         THEN 'NM'
                         ELSE 'UNKNOWN'
                     END AS state_resolve
                FROM s1),
          s3
          AS (SELECT z.state
                   , z.city
                   , MIN(z.Zip) AS zip_resolve
                FROM dbo.ZipLatLong AS z
               GROUP BY z.state
                      , z.city)
          SELECT s2.*
               , s3.zip_resolve
               , z.latitude
               , z.longitude
            FROM s2
                 INNER JOIN
                 s3 ON s2.city_resolve = s3.city
                       AND s2.state_resolve = s3.state
                 INNER JOIN
                 dbo.ZipLatLong AS z ON s2.city_resolve = z.city
                                        AND s2.state_resolve = z.state
                                        AND s3.zip_resolve = z.zip;
GO


