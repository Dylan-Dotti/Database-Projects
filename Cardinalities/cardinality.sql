drop table if exists student cascade;
drop table if exists dorm_room cascade;
drop table if exists developer cascade;
drop table if exists workstation cascade;
drop table if exists pupil cascade;
drop table if exists assigned_seat cascade;
drop table if exists painting cascade;
drop table if exists artist cascade;
drop table if exists dorm_resident cascade;
drop table if exists prescription cascade;
drop table if exists patient cascade;
drop table if exists doctor cascade;
drop table if exists medication cascade;


create table dorm_room(
    building text,
    number int,
    constraint dr_pk primary key (building, number)
    );

create table student(
    id int primary key,
    first_name text not null,
    last_name text not null,
    dorm_room_building text,
    dorm_room_number int,
    constraint student_fk foreign key (dorm_room_building, dorm_room_number) 
    	references dorm_room(building, number)
    );


create table workstation(
    hostname text primary key
    );

create table developer(
    first_name text,
    last_name text,
    workstation_hostname text not null unique,
    constraint dev_pk primary key (first_name, last_name),
    constraint dev_hostname_fk foreign key (workstation_hostname) references workstation(hostname)
    );
    

create table assigned_seat(
    number int primary key
    );
    
create table pupil(
    id int primary key,
    name text,
    assigned_seat_number int unique,
    constraint pupil_seat_fk foreign key (assigned_seat_number) references assigned_seat(number)
    );


create table artist(
    name text primary key,
    year_born int not null,
    year_died int
    );

create table painting(
    id int primary key,
    name text,
    artist_name text not null,
    constraint paint_artist_name_fk foreign key (artist_name) references artist(name)
    );


create table dorm_resident(
    id int primary key,
    first_name text not null,
    last_name text not null,
    room_number int,
    resident_assistant int,
    constraint dorm_res_assist_fk foreign key (resident_assistant) references dorm_resident(id)
    );


create table patient(
    id int primary key,
    first_name text not null,
    last_name text not null
    );

create table doctor(
    id int primary key,
    last_name text not null
    );

create table medication(
    name text primary key
    );

create table prescription(
    patient_id int,
    doctor_id int,
    medication_name text,
    constraint pscrip_patient_id_fk foreign key (patient_id) references patient(id),
    constraint pscrip_doctor_id_fk foreign key (doctor_id) references doctor(id),
    constraint pscrip_med_name_fk foreign key (medication_name) references medication(name),
    constraint pscrip_pk primary key (patient_id, doctor_id, medication_name)
    );

