-- PART 1
-- TASK 1
-- Write a query that shows bands & their respective albums’ release date in descending order.
select bandname as 'Band',
	   albumname as 'Album',
       releasedate as 'Release Date'
from band b
join album a 
on a.idband = b.idband
order by releasedate desc;

-- TASK 2
-- Write a query that shows all of the players that utilize drums along with the bands that they are a part of. 
select concat(pfname, ' ', plname) as 'Name', bandname as 'Band'
from player p
join band b
on b.idband = p.idband
where instid = 4;

-- TASK 3
-- Write a query that describes the number of instruments used by each band.
select bandname as 'Band Name', 
	   count(distinct p.instid) as 'Number of Instruments'
from band b
left join player p
on b.idband = p.idband
group by bandname
order by bandname;

-- TASK 4
-- Write a query that lists the most popular instrument amongst the players.
select instrument, count(p.instid) as 'Number of Players'
from instrument i
join player p
on i.instid = p.instid
group by instrument
order by count(p.instid) desc;

-- TASK 5
-- Write a query that lists any albums that have a missing name and/or missing release dates. How should we handle these?
select * from album
where albumname is null
or releasedate is null;
	-- We should try to add the correct data to the table using an instert statement.
    -- If no such data exists we may want to hide these rows so that future queries are not affected.
    
-- PART 2
-- TASK 1
-- Add more bands to the band table.
select * from band;
      
insert into band(bandname)
values('Weezer'),
	  ('TLC'),
      ('Paramore'),
      ('BlackPink'),
      ('Vampire Weekend');
      
-- TASK 2
-- Which table would we use to add the names of band members?
-- we would want to inset the data into the table Player.

-- TASK 3 
-- Using the table you identified in Task 2, add the following values
/* 'Weezer, Rivers, Cuomo, Vocals, Rochester, New York
Weezer, Brian, Bell, Guitar, Iowa City, Iowa
Weezer, Patrick, Wilson, Drums, Buffalo, New York
Weezer, Scott, Shriner, Bass, Toledo, Ohio
TLC, Tionne, Watkins, Vocals, Des Moines, Iowa
TLC, Rozonda, Thomas, Vocals, Columbus, Georgia
Paramore, Hayley, Williams, Vocals, Franklin, Tennessee
Paramore, Taylor, York, Guitar, Nashville, Tennessee
Paramore, Zac, Farro, Drums, Voorhees Township, New Jersey
Blackpink, Jisoo, Kim, Vocals, null, South Korea
Blackpink, Jennie, Kim, Vocals, null, South Korea
Blackpink, Roseanne, Park, Vocals, null, New Zealand
Blackpink, Lisa, Manoban, Vocals, null, Thailand
Vampire Weekend, Ezra, Koenig, Vocals, New York, New York
Vampire Weekend, Chris, Baio, Bass, Bronxville, New York
Vampire Weekend, Chris, Tomson, Drums, Upper Freehold Township, New Jersey */

insert into player (instid, idband, pfname, plname, homecity, homestate)
values (3, 22, 'Rivers', 'Cuomo', 'Rochester', 'New York'),
		(1, 22, 'Brian', 'Bell', 'Iowa City', 'Iowa'),
		(4, 22, 'Patrick', 'Wilson', 'Buffalo', 'New York'),
		(2, 22, 'Scott', 'Shriner', 'Toledo', 'Ohio'),
		(3, 23, 'Tionne', 'Watkins', 'Des Moines', 'Iowa'),
		(3, 23, 'Rozonda', 'Thomas', 'Columbus', 'Georgia'),
		(3, 24, 'Hayley', 'Williams', 'Franklin', 'Tennessee'),
		(1, 24, 'Taylor', 'York', 'Nashville', 'Tennessee'),
		(4, 24, 'Zac', 'Farro', 'Voorhees Township', 'New Jersey'),
		(3, 25, 'Jisoo', 'Kim', null, 'South Korea'),
		(3, 25, 'Jennie', 'Kim', null, 'South Korea'),
		(3, 25, 'Roseanne', 'Park', null, 'New Zealand'),
		(3, 25, 'Lisa', 'Manoban', null, 'Thailand'),
		(3, 26, 'Ezra', 'Koenig', 'New York', 'New York'),
		(2, 26, 'Chris', 'Baio', 'Bronxville', 'New York'),
		(4, 26, 'Chris', 'Tomson', 'Upper Freehold Township', 'New Jersey');
        
-- TASK 4
-- A new venue should be added to the venue table. 

/*
Attribute
Value
Venue
Twin City Rock House
City
Minneapolis
State
Minnesota
Zip Code
55,414
Seating Capacity
2,000
*/

select * from venue;

insert into venue (idvenue, vname, city, state, zipcode, seats)
values (12, 'Twin City Rock House', 'Minneapois', 'MN', 55414, 2000);


-- TASK 5
-- Which state has the largest amount of seating available (regardless of the number of venues at the state)?
select State, sum(seats) as 'Total Seats'
from venue
group by state
order by sum(seats) desc;
	-- California has the most seats.
    
-- PART 3
-- TASK 1
-- We need to add some data on upcoming performances for some of the artists. Which table should we use to add this information?
	-- We should use the table Gig.
select * from gig;

-- TASK 2
-- Add info to the gig table
insert into gig (gigid, idvenue, idband, gigdate, numattendees)
values (1, 4, 2, '2022-05-05', 19000),
	   (2, 12, 36, '2022-04-15', null),
       (3, 8, 33, '2022-06-07', 18000),
       (4, 2, 32, '2022-07-03', 175);

-- TASK 3
-- Are any of the venues oversold?
Select GigID, bandname as Band, gigdate as Date, vname as Venue, numattendees as 'Expected Attendees', seats as 'Available Seats'
from gig g
join venue v
on g.idvenue = v.idvenue
join band b
on b.idband = g.idband
where numattendees > seats;
	-- The Weezer concert and the TLC concert are oversold.

-- TASK 4
-- We just got word that Vampire Weekend can expect 1,750 guests. Write a query to update the table accordingly.
update gig
set numattendees = 1750
where gigid = 2;

select * from gig;

-- TASK 5 
-- We just got an update that the expected number of attendees at the River Club for Weezer will only have 125 guests. 
update gig
set numattendees = 125
where gigid = 4;

-- TASK 6
/* Create a view (called vw_giginfo) that will show the band, the dates they will play, the venue they will play at, 
the number of attendees, and the venue capacity. For this view, also create a column that describes what percentage of 
the venue capacity was utilized. */

create view vw_giginfo 
as
select bandname as Band, 
	   gigdate as Date, 
       vname as Venue, 
       numattendees as 'Number of Attendees', 
       seats as 'Venue Capacity',
       (numattendees/seats)*100 as 'Percentage Utilized'
from gig g
join venue v
on g.idvenue = v.idvenue
join band b
on b.idband = g.idband

-- PART 4

-- TASK 1
-- Create a stored procedure that lists all of the venues that can handle more than 10,000 guests.
delimiter $
create procedure sp_getvenues()
begin
	select vname as Venue, seats as Capacity
    from venue
    where seats > 10000
    Order by seats desc;
end $
    
call sp_getvenues();

-- TASK 2
/* Create a stored procedure that lists all of the players that come from a specific state. 
We want to see (once we run this stored procedure), what bands they are a part of, their full name (in one column), 
and the state they are from.*/

delimiter $
create procedure sp_playerstate(in state char(100))
begin 
	select concat(pfname, ' ', plname) as Name, bandname as Band, homestate as State
    from player p
    join band b
    on p.idband = b.idband
    where p.homestate = state;
end $


call sp_playerstate('CA');

