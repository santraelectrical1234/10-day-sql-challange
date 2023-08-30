CREATE DATABASE bank1 ;

USE bank1 ;
SELECT * FROM uk;

alter table uk 
modify column Date_Joined date;

DELETE FROM uk WHERE Date_Joined="06-Jan-15";