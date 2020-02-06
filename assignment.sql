--SQL to create all the tables 
CREATE TABLE locations(
    location VARCHAR(75) PRIMARY KEY
);

CREATE TABLE subjects(
    subject VARCHAR(30) PRIMARY KEY
);

CREATE TABLE students(
    name VARCHAR(25) NOT NULL, 
    contactDetails VARCHAR(320) NOT NULL,
    location VARCHAR(75) NOT NULL REFERENCES locations(location),
    PRIMARY KEY (name, contactDetails)
);

CREATE TABLE tutors(
    name VARCHAR(25) NOT NULL, 
    contactDetails VARCHAR(320) NOT NULL,
    PRIMARY KEY (name, contactDetails)
);

CREATE TABLE tutorLocationLink (
    location VARCHAR(75) NOT NULL REFERENCES locations(location),
    name VARCHAR(25) NOT NULL,
    contactDetails VARCHAR(320) NOT NULL,
    CONSTRAINT tutorsFK FOREIGN KEY (name, contactDetails) REFERENCES tutors (name, contactDetails),
    PRIMARY KEY (location, name, contactDetails)
);

CREATE TABLE tutorSubjectLink (
    subject VARCHAR(30) NOT NULL REFERENCES subjects(subject),
    name VARCHAR(25) NOT NULL,
    contactDetails VARCHAR(320) NOT NULL,
    CONSTRAINT tutorsFK FOREIGN KEY (name, contactDetails) REFERENCES tutors (name, contactDetails),
    PRIMARY KEY (subject, name, contactDetails)
);

CREATE TABLE studentSubjectLink (
    subject VARCHAR(30) NOT NULL REFERENCES subjects(subject),
    name VARCHAR(25) NOT NULL,
    contactDetails VARCHAR(320) NOT NULL,
    CONSTRAINT studentsFK FOREIGN KEY (name, contactDetails) REFERENCES students (name, contactDetails),
    PRIMARY KEY (subject, name, contactDetails)
);


--SQL to insert all the data into the tables

--locations
INSERT INTO locations VALUES('Aberystwyth');
INSERT INTO locations VALUES('Machynlleth');
INSERT INTO locations VALUES('Talybont');
INSERT INTO locations VALUES('Bow Street');
INSERT INTO locations VALUES('Borth');
INSERT INTO locations VALUES('Llandre');
INSERT INTO locations VALUES('Llanrhystud');

--subjects
INSERT INTO subjects VALUES('English');
INSERT INTO subjects VALUES('Maths');
INSERT INTO subjects VALUES('Science');
INSERT INTO subjects VALUES('Cymraeg');
INSERT INTO subjects VALUES('Art');

--tutors
INSERT INTO tutors VALUES('Jackie', '01970666543');
INSERT INTO tutors VALUES('Jeff', 'jeff@stemtutors.net');
INSERT INTO tutors VALUES('Ahmed', '07723456788');
INSERT INTO tutors VALUES('Dafydd', '07845333444');
INSERT INTO tutors VALUES('Peter', 'pete@languagetutors.net');
INSERT INTO tutors VALUES('Brian', 'brian@arttutors.net');

--students
INSERT INTO students VALUES('Elin Davis', 'elin@example.com', 'Machynlleth');
INSERT INTO students VALUES('Steve Smith', 'steve@example.com', 'Llanrhystud');

--tutorSubjectLink
INSERT INTO tutorSubjectLink VALUES('English', 'Jackie', '01970666543');
INSERT INTO tutorSubjectLink VALUES('Maths', 'Jackie', '01970666543');
INSERT INTO tutorSubjectLink VALUES('Science', 'Jeff', 'jeff@stemtutors.net');
INSERT INTO tutorSubjectLink VALUES('Maths', 'Jeff', 'jeff@stemtutors.net');
INSERT INTO tutorSubjectLink VALUES('Cymraeg', 'Ahmed', '07723456788');
INSERT INTO tutorSubjectLink VALUES('Art', 'Ahmed', '07723456788');
INSERT INTO tutorSubjectLink VALUES('Cymraeg', 'Dafydd', '07845333444');
INSERT INTO tutorSubjectLink VALUES('English', 'Peter', 'pete@languagetutors.net');
INSERT INTO tutorSubjectLink VALUES('Art', 'Brian', 'brian@arttutors.net');

--tutorLocationLink
INSERT INTO tutorLocationLink VALUES('Aberystwyth', 'Jackie', '01970666543');
INSERT INTO tutorLocationLink VALUES('Machynlleth', 'Jeff', 'jeff@stemtutors.net');
INSERT INTO tutorLocationLink VALUES('Talybont', 'Jeff', 'jeff@stemtutors.net');
INSERT INTO tutorLocationLink VALUES('Bow Street', 'Jeff', 'jeff@stemtutors.net');
INSERT INTO tutorLocationLink VALUES('Borth', 'Ahmed', '07723456788');
INSERT INTO tutorLocationLink VALUES('Aberystwyth', 'Ahmed', '07723456788');
INSERT INTO tutorLocationLink VALUES('Bow Street', 'Ahmed', '07723456788');
INSERT INTO tutorLocationLink VALUES('Llandre', 'Ahmed', '07723456788');
INSERT INTO tutorLocationLink VALUES('Talybont', 'Ahmed', '07723456788');
INSERT INTO tutorLocationLink VALUES('Machynlleth', 'Dafydd', '07845333444');
INSERT INTO tutorLocationLink VALUES('Bow Street', 'Peter', 'pete@languagetutors.net');
INSERT INTO tutorLocationLink VALUES('Aberystwyth', 'Brian', 'brian@arttutors.net');
INSERT INTO tutorLocationLink VALUES('Llanrhystud', 'Brian', 'brian@arttutors.net');

--studentSubjectLink
INSERT INTO studentSubjectLink VALUES('Maths', 'Elin Davis', 'elin@example.com');
INSERT INTO studentSubjectLink VALUES('Science', 'Elin Davis', 'elin@example.com');
INSERT INTO studentSubjectLink VALUES('English', 'Steve Smith', 'steve@example.com');

--populating with extra data
BEGIN;
INSERT INTO students VALUES('Ben Smith', 'benny@example.com', 'Llandre');
INSERT INTO studentSubjectLink VALUES('Cymareag', 'Ben Smith', 'benny@example.com');
COMMIT;
BEGIN;
INSERT INTO students VALUES('Bethany Johnson', 'beth@example.com', 'Borth');
INSERT INTO studentSubjectLink VALUES('Science', 'Bethany Johnson', 'beth@example.com');
COMMIT;
BEGIN;
INSERT INTO students VALUES('Shaun Dunn', 's.dunn@example.com', 'Talybont');
INSERT INTO studentSubjectLink VALUES('English', 'Shaun Dunn', 's.dunn@example.com');
INSERT INTO studentSubjectLink VALUES('Cymraeg', 'Shaun Dunn', 's.dunn@example.com');
COMMIT;
BEGIN;
INSERT INTO students VALUES('Eve Gilbert', 'eve@example.com', 'Llanrhystud');
INSERT INTO studentSubjectLink VALUES('Maths', 'Eve Gilbert', 'eve@example.com');
COMMIT;

--Sample Queries

--All tutors who study maths
SELECT name, contactDetails FROM tutorSubjectLink WHERE subject = 'Maths';

--Tutors who teach art in aber
SELECT tutors.name, tutors.contactDetails FROM tutors 
    INNER JOIN tutorSubjectLink ON tutors.name = tutorSubjectLink.name AND tutors.contactDetails = tutorSubjectLink.contactDetails
    INNER JOIN tutorLocationLink ON tutors.name = tutorLocationLink.name AND tutors.contactDetails = tutorLocationLink.contactDetails
    WHERE tutorSubjectLink.subject = 'Art' AND tutorLocationLink.location = 'Aberystwyth'
;

--Get all students who dont have matching tutors
SELECT allStudents.name, allStudents.contactDetails
    FROM 
        (SELECT students.name, students.contactDetails FROM students
            INNER JOIN studentSubjectLink
                on students.name = studentSubjectLink.name
                AND students.contactDetails = studentSubjectLink.contactDetails
        ) allStudents
    WHERE (allStudents.name, allStudents.contactDetails) NOT IN
        (SELECT fullStudents.name, fullStudents.contactDetails FROM
            (SELECT students.name, students.contactDetails, students.location, studentSubjectLink.subject 
                FROM students
                INNER JOIN studentSubjectLink 
                    ON students.name = studentSubjectLink.name
                    AND students.contactDetails = studentSubjectLink.contactDetails
            ) fullStudents
            INNER JOIN 
                (SELECT tutors.name, tutors.contactDetails, tutorLocationLink.location, tutorSubjectLink.subject 
                    FROM tutors
                    INNER JOIN tutorSubjectLink
                        ON tutors.name = tutorSubjectLink.name
                        AND tutors.contactDetails = tutorSubjectLink.contactDetails
                    INNER JOIN tutorLocationLink 
                        ON tutors.name = tutorLocationLink.name
                        AND tutors.contactDetails = tutorLocationLink.contactDetails
                ) fullTutors
            ON fullStudents.location = fullTutors.location
            AND fullStudents.subject = fullTutors.subject
        )
;