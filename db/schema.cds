namespace my.checkinapi;

using cuid from '@sap/cds/common';

entity Users {
    key ID : String;
    name   : String;
    email  : String;
}

entity CheckIn {
    key ID : Integer;
    user   : Association to Users;
    office : Association to Offices;
    floor  : Association to Floors;
    date   : Date;
    active : Integer;
}

entity Offices {
    key ID : Integer;
    name   : String;
}

entity Floors {
    key ID   : Integer;
    name     : String;
    capacity : Integer;
    office   : Association to Offices;
}

entity SecurityGuards{
    key ID : Integer;
    name   : String;
    email  : String;
}

entity FloorSecurityGuards{
    key ID         : Integer;
    floor          : Association to Floors;
    securityGuard  : Association to SecurityGuards;
}

context View {
    VIEW CheckInList as SELECT FROM CheckIn
    {
        key ID,
        office.name as officeName,
        floor.name as floorName,
        date,
        active,
        user.ID as user
    };

    VIEW AvailableCapacity as SELECT FROM CheckIn
    {
        key floor.ID,

        (floor.capacity - count(ID)) as AvailableCapacity : Integer,
        date
    } GROUP BY floor.ID, date;

    VIEW OccupiedCapacity as SELECT FROM CheckIn
    {
        key floor.ID,
        (office.name || '-' || floor.name) as officeFloor : String,
        count(ID) as OccupiedCapacity : Integer,
        date
    } GROUP BY floor.ID, date
}