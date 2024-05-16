use restaurant_reservation;
create table Customers
(
	customerID int not null unique auto_increment primary key,
    customerName varchar(45) not null,
    contactInfo varchar(200)
);
select * from Customers;

create table Reservations
(
	reservationID int not null unique auto_increment primary key,
    customerID int not null references Customers(customerID),
    reservationTime datetime not null,
    numberOfGuests int not null,
    specialRequests varchar(200)
);
select * from Reservations;

create table DiningPreferences
(
	preferenceID int not null unique auto_increment primary key,
    customerID int not null references Customers(customerID),
    favoriteTable varchar(45),
    dietaryRestrictions varchar(200)
);
select * from DiningPreferences;

insert into Customers (customerName, contactInfo)
values 
	("David Foley", "davefoley10@gmail.com 717-333-2121 4122 Hart Country Lane, Thomaston, GA"),
    ("Richard Martinez", "richM44@gmail.com 252-657-4355 2454 Colony Street, Milford, CT"),
    ("Genesis Hartley", "gen88@gmail.com 316-324-7890 3309 Mesa Drive, Las Vegas, NV"),
    ("Jeff Vega", "JV2020@gmail.com 347-0954-9999 478 Jett Lane, Irvine, CA");
    
insert into Reservations (customerID, reservationTime, numberOfGuests, specialRequests)
values
	(1, '2023-09-14', 3, "Fudge Cake with caramel for dessert"),
    (2, '2023-07-15', 5, "3 Bottles of Pinot Noir wine"),
    (3, '2024-02-20', 1, "Everything must be Gluten-free"),
    (4, '2024-05-01', 0, "Call me an Uber at the end of the night");
    
insert into DiningPreferences (customerID, favoriteTable, dietaryRestrictions)
values
	(1, "Round table facing each other", "None"),
    (2, "Rectangular glass table", "Vegetarian"),
    (3, "Outside table", "Gluten-free diet"),
    (4, "Booth table", "None");

select * from Customers;
select * from Reservations;
select * from DiningPreferences;


delimiter //
create procedure findReservations(in id int)
begin
	select * 
    from Reservations
    where customerID=id;
end //
delimiter ;
call findReservations(2);

delimiter //
create procedure addSpecialRequest(in res_id int, in new_req varchar(200))
begin
	update Reservations 
    set specialRequests=new_req
    where reservationID=res_id;
end //
delimiter ; 
call addSpecialRequest(1, "Bring breadsticks every 20 minutes");

delimiter //
create procedure addReservation7(in cust_id int, in cust_name varchar(45), in res_id int, in res_date datetime, in num_gst int, in pref_id int) 
begin
	if not exists(select 1 from Reservations where customerID=cust_id)then
		insert into Customers(customerID, customerName)
        values(cust_id, cust_name);
        insert into Reservations(reservationID, customerID, reservationTime, numberOfGuests)
        values(res_id, cust_id, res_date, num_gst);
        insert into DiningPreferences(preferenceID, customerID)
        values(pref_id, cust_id);
        
	else
	select 'Customer already has a reservation.';
        
	end if;

end //
delimiter ;
call addReservation7(5, "James Franko", 5, '2024-05-13', 2, 5);

delimiter //
create procedure deleteReservation(in cus_id int)
begin
	delete from Reservations
    where customerID=cus_id;
end //
delimiter ;
call deleteReservation(5);

delimiter //
create procedure searchPreferences(in c_id int)
begin
	select *
    from DiningPreferences
    where customerID=c_id;
end //
delimiter ;
call searchPreferences(2);



select * from Customers;
select * from Reservations;
select * from DiningPreferences;