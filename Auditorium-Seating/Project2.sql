drop schema if exists private cascade;
drop table if exists Seat cascade;
drop table if exists Ticket cascade;
drop table if exists SeatRow cascade;
drop table if exists SeatNum cascade;
drop table if exists Customer cascade;

create schema private;

create table SeatRow(
    row text primary key
);

insert into SeatRow
select chr(generate_series + ascii('A'))
from generate_series(0, 17);
delete from SeatRow where row = 'I';

insert into SeatRow values
('AA'), ('BB'), ('CC'), ('DD'),
('EE'), ('FF'), ('GG'), ('HH');

create table SeatNum(
    num int primary key
);

insert into SeatNum select * from generate_series(1, 15);
insert into SeatNum	select * from generate_series(101, 126);


create table Seat(
    SeatRow text references SeatRow(row),
    SeatNumber int references SeatNum(num),
    Section text not null
    	check (Section in ('Balcony', 'Main Floor')),
    Side text not null
    	check (Side in ('Left', 'Middle', 'Right')),
    PricingTier text not null
    	check (PricingTier in ('Upper Balcony', 'Side', 'Orchestra')),
    Wheelchair bool not null,
    constraint Seat_PK primary key (SeatRow, SeatNumber)
);

/*Middle Rows*/
insert into Seat (SeatRow, SeatNumber, Section, Side, PricingTier, Wheelchair)
select SeatRow.row, SeatNum.num, 'Main Floor', 'Middle', 'Orchestra', false
from SeatRow join SeatNum
on SeatRow.row in ('A', 'B', 'C', 'EE', 'FF')
and SeatNum.num in (select * from generate_series(1, 10))
or SeatRow.row in ('D', 'E', 'F', 'GG', 'HH')
and SeatNum.num in (select * from generate_series(1, 11))
or SeatRow.row in ('G', 'H', 'J')
and SeatNum.num in (select * from generate_series(1, 12))
or SeatRow.row in ('K', 'L', 'M', 'AA')
and SeatNum.num in (select * from generate_series(1, 13))
or SeatRow.row in ('N', 'O', 'P', 'BB', 'CC', 'DD')
and SeatNum.num in (select * from generate_series(1, 14))
or SeatRow.row in ('Q', 'R')
and SeatNum.num in (select * from generate_series(1, 15));

/*Side Rows*/
insert into Seat (SeatRow, SeatNumber, Section, Side, PricingTier, Wheelchair)
select SeatRow.row, SeatNum.num, 'Main Floor', 'Right', 'Orchestra', false
from SeatRow join SeatNum
on SeatRow.row in ('A')
and SeatNum.num in (select * from generate_series(101, 114))
or SeatRow.row in ('B', 'C', 'D', 'E')
and SeatNum.num in (select * from generate_series(101, 116))
or SeatRow.row in ('F', 'G', 'H', 'J', 'HH')
and SeatNum.num in (select * from generate_series(101, 118))
or SeatRow.row in ('K', 'L', 'M', 'N', 'GG')
and SeatNum.num in (select * from generate_series(101, 120))
or SeatRow.row in ('O', 'P', 'Q', 'R', 'EE', 'FF')
and SeatNum.num in (select * from generate_series(101, 122))
or SeatRow.row in ('AA', 'BB', 'CC')
and SeatNum.num in (select * from generate_series(101, 124))
or SeatRow.row in ('DD')
and SeatNum.num in (select * from generate_series(101, 126));

/*Update Balcony*/
update Seat
set Section = 'Balcony'
where SeatRow like '__';

/*Update Upper Balcony Pricing*/
update Seat
set PricingTier = 'Upper Balcony'
where SeatRow in ('EE', 'FF', 'GG', 'HH');

/*Update Left Side*/
update Seat
set Side = 'Left'
where SeatNumber > 100
and SeatNumber % 2 != 0;

/*Update Side Pricing*/
update Seat
set PricingTier = 'Side'
where SeatRow like '_'
and SeatNumber > 106
or SeatRow in ('AA', 'BB', 'CC', 'DD')
and SeatNumber > 100;

/*Update Wheelchair*/
update Seat
set Wheelchair = true
where SeatRow in ('P', 'Q', 'R')
and SeatNumber > 108;


create table Customer(
    CustomerID int primary key,
    FirstName text not null,
    LastName text not null
);

/*
The project description says to use int for
the CCN, but it is too large so I used bigint.
Could have also been text.
*/
create table private.Customer(
    CustomerID int primary key references public.Customer(CustomerID),
    CreditCard bigint not null
);

create table Ticket(
    TicketNumber serial primary key,
    CustomerID int not null references Customer(CustomerID),
    SeatRow text not null references SeatRow(row),
    SeatNumber int not null references SeatNum(num),
    ShowTime timestamp not null,
    unique (SeatRow, SeatNumber, ShowTime)
);

insert into Customer (CustomerID, FirstName, LastName) values
(1234, 'Mike', 'Johnson');
insert into private.Customer (CustomerID, CreditCard) values
(1234, 1234567887654321);
insert into Ticket (CustomerID, SeatRow, SeatNumber, ShowTime) values
(1234, 'A', 6, '2017-12-15 02:00:00'),
(1234, 'A', 8, '2017-12-15 02:00:00'),
(1234, 'A', 9, '2017-12-15 02:00:00'),
(1234, 'A', 10, '2017-12-15 02:00:00');

