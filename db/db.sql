--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.3
-- Dumped by pg_dump version 9.6.3

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

DROP DATABASE demo;
--
-- Name: demo; Type: DATABASE; Schema: -; Owner: -
--

CREATE DATABASE demo;


\connect demo

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: bookings; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA bookings;


--
-- Name: SCHEMA bookings; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA bookings IS 'Airlines demo database schema';


--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = bookings, pg_catalog;

--
-- Name: lang(); Type: FUNCTION; Schema: bookings; Owner: -
--

CREATE FUNCTION lang() RETURNS text
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
RETURN current_setting('bookings.lang');
EXCEPTION
  WHEN undefined_object THEN
    RETURN NULL;
END;
$$;


--
-- Name: now(); Type: FUNCTION; Schema: bookings; Owner: -
--

CREATE FUNCTION now() RETURNS timestamp with time zone
    LANGUAGE sql IMMUTABLE
    AS $$SELECT '2017-08-15 18:00:00'::TIMESTAMP AT TIME ZONE 'Europe/Moscow';$$;


--
-- Name: FUNCTION now(); Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON FUNCTION now() IS 'Point in time according to which the data are generated';


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: aircrafts_data; Type: TABLE; Schema: bookings; Owner: -
--

CREATE TABLE aircrafts_data (
                                aircraft_code character(3) NOT NULL,
                                model jsonb NOT NULL,
                                range integer NOT NULL,
                                CONSTRAINT aircrafts_range_check CHECK ((range > 0))
);


--
-- Name: TABLE aircrafts_data; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON TABLE aircrafts_data IS 'Aircrafts (internal data)';


--
-- Name: COLUMN aircrafts_data.aircraft_code; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN aircrafts_data.aircraft_code IS 'Aircraft code, IATA';


--
-- Name: COLUMN aircrafts_data.model; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN aircrafts_data.model IS 'Aircraft model';


--
-- Name: COLUMN aircrafts_data.range; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN aircrafts_data.range IS 'Maximal flying distance, km';


--
-- Name: aircrafts; Type: VIEW; Schema: bookings; Owner: -
--

CREATE VIEW aircrafts AS
SELECT ml.aircraft_code,
       (ml.model ->> lang()) AS model,
       ml.range
FROM aircrafts_data ml;


--
-- Name: VIEW aircrafts; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON VIEW aircrafts IS 'Aircrafts';


--
-- Name: COLUMN aircrafts.aircraft_code; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN aircrafts.aircraft_code IS 'Aircraft code, IATA';


--
-- Name: COLUMN aircrafts.model; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN aircrafts.model IS 'Aircraft model';


--
-- Name: COLUMN aircrafts.range; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN aircrafts.range IS 'Maximal flying distance, km';


--
-- Name: airports_data; Type: TABLE; Schema: bookings; Owner: -
--

CREATE TABLE airports_data (
                               airport_code character(3) NOT NULL,
                               airport_name jsonb NOT NULL,
                               city jsonb NOT NULL,
                               coordinates point NOT NULL,
                               timezone text NOT NULL
);


--
-- Name: TABLE airports_data; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON TABLE airports_data IS 'Airports (internal data)';


--
-- Name: COLUMN airports_data.airport_code; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN airports_data.airport_code IS 'Airport code';


--
-- Name: COLUMN airports_data.airport_name; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN airports_data.airport_name IS 'Airport name';


--
-- Name: COLUMN airports_data.city; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN airports_data.city IS 'City';


--
-- Name: COLUMN airports_data.coordinates; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN airports_data.coordinates IS 'Airport coordinates (longitude and latitude)';


--
-- Name: COLUMN airports_data.timezone; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN airports_data.timezone IS 'Airport time zone';


--
-- Name: airports; Type: VIEW; Schema: bookings; Owner: -
--

CREATE VIEW airports AS
SELECT ml.airport_code,
       (ml.airport_name ->> lang()) AS airport_name,
       (ml.city ->> lang()) AS city,
       ml.coordinates,
       ml.timezone
FROM airports_data ml;


--
-- Name: VIEW airports; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON VIEW airports IS 'Airports';


--
-- Name: COLUMN airports.airport_code; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN airports.airport_code IS 'Airport code';


--
-- Name: COLUMN airports.airport_name; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN airports.airport_name IS 'Airport name';


--
-- Name: COLUMN airports.city; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN airports.city IS 'City';


--
-- Name: COLUMN airports.coordinates; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN airports.coordinates IS 'Airport coordinates (longitude and latitude)';


--
-- Name: COLUMN airports.timezone; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN airports.timezone IS 'Airport time zone';


--
-- Name: boarding_passes; Type: TABLE; Schema: bookings; Owner: -
--

CREATE TABLE boarding_passes (
                                 ticket_no character(13) NOT NULL,
                                 flight_id integer NOT NULL,
                                 boarding_no integer NOT NULL,
                                 seat_no character varying(4) NOT NULL
);


--
-- Name: TABLE boarding_passes; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON TABLE boarding_passes IS 'Boarding passes';


--
-- Name: COLUMN boarding_passes.ticket_no; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN boarding_passes.ticket_no IS 'Ticket number';


--
-- Name: COLUMN boarding_passes.flight_id; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN boarding_passes.flight_id IS 'Flight ID';


--
-- Name: COLUMN boarding_passes.boarding_no; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN boarding_passes.boarding_no IS 'Boarding pass number';


--
-- Name: COLUMN boarding_passes.seat_no; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN boarding_passes.seat_no IS 'Seat number';


--
-- Name: bookings; Type: TABLE; Schema: bookings; Owner: -
--

CREATE TABLE bookings (
                          book_ref character(6) NOT NULL,
                          book_date timestamp with time zone NOT NULL,
                          total_amount numeric(10,2) NOT NULL
);


--
-- Name: TABLE bookings; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON TABLE bookings IS 'Bookings';


--
-- Name: COLUMN bookings.book_ref; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN bookings.book_ref IS 'Booking number';


--
-- Name: COLUMN bookings.book_date; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN bookings.book_date IS 'Booking date';


--
-- Name: COLUMN bookings.total_amount; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN bookings.total_amount IS 'Total booking cost';


--
-- Name: flights; Type: TABLE; Schema: bookings; Owner: -
--

CREATE TABLE flights (
                         flight_id integer NOT NULL,
                         flight_no character(6) NOT NULL,
                         scheduled_departure timestamp with time zone NOT NULL,
                         scheduled_arrival timestamp with time zone NOT NULL,
                         departure_airport character(3) NOT NULL,
                         arrival_airport character(3) NOT NULL,
                         status character varying(20) NOT NULL,
                         aircraft_code character(3) NOT NULL,
                         actual_departure timestamp with time zone,
                         actual_arrival timestamp with time zone,
                         CONSTRAINT flights_check CHECK ((scheduled_arrival > scheduled_departure)),
                         CONSTRAINT flights_check1 CHECK (((actual_arrival IS NULL) OR ((actual_departure IS NOT NULL) AND (actual_arrival IS NOT NULL) AND (actual_arrival > actual_departure)))),
                         CONSTRAINT flights_status_check CHECK (((status)::text = ANY (ARRAY[('On Time'::character varying)::text, ('Delayed'::character varying)::text, ('Departed'::character varying)::text, ('Arrived'::character varying)::text, ('Scheduled'::character varying)::text, ('Cancelled'::character varying)::text])))
);


--
-- Name: TABLE flights; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON TABLE flights IS 'Flights';


--
-- Name: COLUMN flights.flight_id; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN flights.flight_id IS 'Flight ID';


--
-- Name: COLUMN flights.flight_no; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN flights.flight_no IS 'Flight number';


--
-- Name: COLUMN flights.scheduled_departure; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN flights.scheduled_departure IS 'Scheduled departure time';


--
-- Name: COLUMN flights.scheduled_arrival; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN flights.scheduled_arrival IS 'Scheduled arrival time';


--
-- Name: COLUMN flights.departure_airport; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN flights.departure_airport IS 'Airport of departure';


--
-- Name: COLUMN flights.arrival_airport; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN flights.arrival_airport IS 'Airport of arrival';


--
-- Name: COLUMN flights.status; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN flights.status IS 'Flight status';


--
-- Name: COLUMN flights.aircraft_code; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN flights.aircraft_code IS 'Aircraft code, IATA';


--
-- Name: COLUMN flights.actual_departure; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN flights.actual_departure IS 'Actual departure time';


--
-- Name: COLUMN flights.actual_arrival; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN flights.actual_arrival IS 'Actual arrival time';


--
-- Name: flights_flight_id_seq; Type: SEQUENCE; Schema: bookings; Owner: -
--

CREATE SEQUENCE flights_flight_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: flights_flight_id_seq; Type: SEQUENCE OWNED BY; Schema: bookings; Owner: -
--

ALTER SEQUENCE flights_flight_id_seq OWNED BY flights.flight_id;


--
-- Name: flights_v; Type: VIEW; Schema: bookings; Owner: -
--

CREATE VIEW flights_v AS
SELECT f.flight_id,
       f.flight_no,
       f.scheduled_departure,
       timezone(dep.timezone, f.scheduled_departure) AS scheduled_departure_local,
       f.scheduled_arrival,
       timezone(arr.timezone, f.scheduled_arrival) AS scheduled_arrival_local,
       (f.scheduled_arrival - f.scheduled_departure) AS scheduled_duration,
       f.departure_airport,
       dep.airport_name AS departure_airport_name,
       dep.city AS departure_city,
       f.arrival_airport,
       arr.airport_name AS arrival_airport_name,
       arr.city AS arrival_city,
       f.status,
       f.aircraft_code,
       f.actual_departure,
       timezone(dep.timezone, f.actual_departure) AS actual_departure_local,
       f.actual_arrival,
       timezone(arr.timezone, f.actual_arrival) AS actual_arrival_local,
       (f.actual_arrival - f.actual_departure) AS actual_duration
FROM flights f,
     airports dep,
     airports arr
WHERE ((f.departure_airport = dep.airport_code) AND (f.arrival_airport = arr.airport_code));


--
-- Name: VIEW flights_v; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON VIEW flights_v IS 'Flights (extended)';


--
-- Name: COLUMN flights_v.flight_id; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN flights_v.flight_id IS 'Flight ID';


--
-- Name: COLUMN flights_v.flight_no; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN flights_v.flight_no IS 'Flight number';


--
-- Name: COLUMN flights_v.scheduled_departure; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN flights_v.scheduled_departure IS 'Scheduled departure time';


--
-- Name: COLUMN flights_v.scheduled_departure_local; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN flights_v.scheduled_departure_local IS 'Scheduled departure time, local time at the point of departure';


--
-- Name: COLUMN flights_v.scheduled_arrival; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN flights_v.scheduled_arrival IS 'Scheduled arrival time';


--
-- Name: COLUMN flights_v.scheduled_arrival_local; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN flights_v.scheduled_arrival_local IS 'Scheduled arrival time, local time at the point of destination';


--
-- Name: COLUMN flights_v.scheduled_duration; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN flights_v.scheduled_duration IS 'Scheduled flight duration';


--
-- Name: COLUMN flights_v.departure_airport; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN flights_v.departure_airport IS 'Deprature airport code';


--
-- Name: COLUMN flights_v.departure_airport_name; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN flights_v.departure_airport_name IS 'Departure airport name';


--
-- Name: COLUMN flights_v.departure_city; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN flights_v.departure_city IS 'City of departure';


--
-- Name: COLUMN flights_v.arrival_airport; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN flights_v.arrival_airport IS 'Arrival airport code';


--
-- Name: COLUMN flights_v.arrival_airport_name; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN flights_v.arrival_airport_name IS 'Arrival airport name';


--
-- Name: COLUMN flights_v.arrival_city; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN flights_v.arrival_city IS 'City of arrival';


--
-- Name: COLUMN flights_v.status; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN flights_v.status IS 'Flight status';


--
-- Name: COLUMN flights_v.aircraft_code; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN flights_v.aircraft_code IS 'Aircraft code, IATA';


--
-- Name: COLUMN flights_v.actual_departure; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN flights_v.actual_departure IS 'Actual departure time';


--
-- Name: COLUMN flights_v.actual_departure_local; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN flights_v.actual_departure_local IS 'Actual departure time, local time at the point of departure';


--
-- Name: COLUMN flights_v.actual_arrival; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN flights_v.actual_arrival IS 'Actual arrival time';


--
-- Name: COLUMN flights_v.actual_arrival_local; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN flights_v.actual_arrival_local IS 'Actual arrival time, local time at the point of destination';


--
-- Name: COLUMN flights_v.actual_duration; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN flights_v.actual_duration IS 'Actual flight duration';


--
-- Name: routes; Type: VIEW; Schema: bookings; Owner: -
--

CREATE VIEW routes AS
WITH f3 AS (
    SELECT f2.flight_no,
           f2.departure_airport,
           f2.arrival_airport,
           f2.aircraft_code,
           f2.duration,
           array_agg(f2.days_of_week) AS days_of_week
    FROM ( SELECT f1.flight_no,
                  f1.departure_airport,
                  f1.arrival_airport,
                  f1.aircraft_code,
                  f1.duration,
                  f1.days_of_week
           FROM ( SELECT flights.flight_no,
                         flights.departure_airport,
                         flights.arrival_airport,
                         flights.aircraft_code,
                         (flights.scheduled_arrival - flights.scheduled_departure) AS duration,
                         (to_char(flights.scheduled_departure, 'ID'::text))::integer AS days_of_week
                  FROM flights) f1
           GROUP BY f1.flight_no, f1.departure_airport, f1.arrival_airport, f1.aircraft_code, f1.duration, f1.days_of_week
           ORDER BY f1.flight_no, f1.departure_airport, f1.arrival_airport, f1.aircraft_code, f1.duration, f1.days_of_week) f2
    GROUP BY f2.flight_no, f2.departure_airport, f2.arrival_airport, f2.aircraft_code, f2.duration
)
SELECT f3.flight_no,
       f3.departure_airport,
       dep.airport_name AS departure_airport_name,
       dep.city AS departure_city,
       f3.arrival_airport,
       arr.airport_name AS arrival_airport_name,
       arr.city AS arrival_city,
       f3.aircraft_code,
       f3.duration,
       f3.days_of_week
FROM f3,
     airports dep,
     airports arr
WHERE ((f3.departure_airport = dep.airport_code) AND (f3.arrival_airport = arr.airport_code));


--
-- Name: VIEW routes; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON VIEW routes IS 'Routes';


--
-- Name: COLUMN routes.flight_no; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN routes.flight_no IS 'Flight number';


--
-- Name: COLUMN routes.departure_airport; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN routes.departure_airport IS 'Code of airport of departure';


--
-- Name: COLUMN routes.departure_airport_name; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN routes.departure_airport_name IS 'Name of airport of departure';


--
-- Name: COLUMN routes.departure_city; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN routes.departure_city IS 'City of departure';


--
-- Name: COLUMN routes.arrival_airport; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN routes.arrival_airport IS 'Code of airport of arrival';


--
-- Name: COLUMN routes.arrival_airport_name; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN routes.arrival_airport_name IS 'Name of airport of arrival';


--
-- Name: COLUMN routes.arrival_city; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN routes.arrival_city IS 'City of arrival';


--
-- Name: COLUMN routes.aircraft_code; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN routes.aircraft_code IS 'Aircraft code, IATA';


--
-- Name: COLUMN routes.duration; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN routes.duration IS 'Scheduled duration of flight';


--
-- Name: COLUMN routes.days_of_week; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN routes.days_of_week IS 'Days of week on which flights are scheduled';


--
-- Name: seats; Type: TABLE; Schema: bookings; Owner: -
--

CREATE TABLE seats (
                       aircraft_code character(3) NOT NULL,
                       seat_no character varying(4) NOT NULL,
                       fare_conditions character varying(10) NOT NULL,
                       CONSTRAINT seats_fare_conditions_check CHECK (((fare_conditions)::text = ANY (ARRAY[('Economy'::character varying)::text, ('Comfort'::character varying)::text, ('Business'::character varying)::text])))
);


--
-- Name: TABLE seats; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON TABLE seats IS 'Seats';


--
-- Name: COLUMN seats.aircraft_code; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN seats.aircraft_code IS 'Aircraft code, IATA';


--
-- Name: COLUMN seats.seat_no; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN seats.seat_no IS 'Seat number';


--
-- Name: COLUMN seats.fare_conditions; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN seats.fare_conditions IS 'Travel class';


--
-- Name: ticket_flights; Type: TABLE; Schema: bookings; Owner: -
--

CREATE TABLE ticket_flights (
                                ticket_no character(13) NOT NULL,
                                flight_id integer NOT NULL,
                                fare_conditions character varying(10) NOT NULL,
                                amount numeric(10,2) NOT NULL,
                                CONSTRAINT ticket_flights_amount_check CHECK ((amount >= (0)::numeric)),
                                CONSTRAINT ticket_flights_fare_conditions_check CHECK (((fare_conditions)::text = ANY (ARRAY[('Economy'::character varying)::text, ('Comfort'::character varying)::text, ('Business'::character varying)::text])))
);


--
-- Name: TABLE ticket_flights; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON TABLE ticket_flights IS 'Flight segment';


--
-- Name: COLUMN ticket_flights.ticket_no; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN ticket_flights.ticket_no IS 'Ticket number';


--
-- Name: COLUMN ticket_flights.flight_id; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN ticket_flights.flight_id IS 'Flight ID';


--
-- Name: COLUMN ticket_flights.fare_conditions; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN ticket_flights.fare_conditions IS 'Travel class';


--
-- Name: COLUMN ticket_flights.amount; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN ticket_flights.amount IS 'Travel cost';


--
-- Name: tickets; Type: TABLE; Schema: bookings; Owner: -
--

CREATE TABLE tickets (
                         ticket_no character(13) NOT NULL,
                         book_ref character(6) NOT NULL,
                         passenger_id character varying(20) NOT NULL,
                         passenger_name text NOT NULL,
                         contact_data jsonb
);


--
-- Name: TABLE tickets; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON TABLE tickets IS 'Tickets';


--
-- Name: COLUMN tickets.ticket_no; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN tickets.ticket_no IS 'Ticket number';


--
-- Name: COLUMN tickets.book_ref; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN tickets.book_ref IS 'Booking number';


--
-- Name: COLUMN tickets.passenger_id; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN tickets.passenger_id IS 'Passenger ID';


--
-- Name: COLUMN tickets.passenger_name; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN tickets.passenger_name IS 'Passenger name';


--
-- Name: COLUMN tickets.contact_data; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN tickets.contact_data IS 'Passenger contact information';


--
-- Name: flights flight_id; Type: DEFAULT; Schema: bookings; Owner: -
--

ALTER TABLE ONLY flights ALTER COLUMN flight_id SET DEFAULT nextval('flights_flight_id_seq'::regclass);


--
-- Data for Name: aircrafts_data; Type: TABLE DATA; Schema: bookings; Owner: -
--

COPY aircrafts_data (aircraft_code, model, range) FROM stdin;
773	{"en": "Boeing 777-300", "ru": "Боинг 777-300"}	11100
763	{"en": "Boeing 767-300", "ru": "Боинг 767-300"}	7900
SU9	{"en": "Sukhoi Superjet-100", "ru": "Сухой Суперджет-100"}	3000
320	{"en": "Airbus A320-200", "ru": "Аэробус A320-200"}	5700
321	{"en": "Airbus A321-200", "ru": "Аэробус A321-200"}	5600
319	{"en": "Airbus A319-100", "ru": "Аэробус A319-100"}	6700
733	{"en": "Boeing 737-300", "ru": "Боинг 737-300"}	4200
CN1	{"en": "Cessna 208 Caravan", "ru": "Сессна 208 Караван"}	1200
CR2	{"en": "Bombardier CRJ-200", "ru": "Бомбардье CRJ-200"}	2700
\.


--
-- Data for Name: airports_data; Type: TABLE DATA; Schema: bookings; Owner: -
--

COPY airports_data (airport_code, airport_name, city, coordinates, timezone) FROM stdin;
YKS	{"en": "Yakutsk Airport", "ru": "Якутск"}	{"en": "Yakutsk", "ru": "Якутск"}	(129.77099609375,62.0932998657226562)	Asia/Yakutsk
MJZ	{"en": "Mirny Airport", "ru": "Мирный"}	{"en": "Mirnyj", "ru": "Мирный"}	(114.03900146484375,62.534698486328125)	Asia/Yakutsk
KHV	{"en": "Khabarovsk-Novy Airport", "ru": "Хабаровск-Новый"}	{"en": "Khabarovsk", "ru": "Хабаровск"}	(135.18800354004,48.5279998779300001)	Asia/Vladivostok
PKC	{"en": "Yelizovo Airport", "ru": "Елизово"}	{"en": "Petropavlovsk", "ru": "Петропавловск-Камчатский"}	(158.453994750976562,53.1679000854492188)	Asia/Kamchatka
UUS	{"en": "Yuzhno-Sakhalinsk Airport", "ru": "Хомутово"}	{"en": "Yuzhno-Sakhalinsk", "ru": "Южно-Сахалинск"}	(142.718002319335938,46.8886985778808594)	Asia/Sakhalin
VVO	{"en": "Vladivostok International Airport", "ru": "Владивосток"}	{"en": "Vladivostok", "ru": "Владивосток"}	(132.147994995117188,43.3989982604980469)	Asia/Vladivostok
LED	{"en": "Pulkovo Airport", "ru": "Пулково"}	{"en": "St. Petersburg", "ru": "Санкт-Петербург"}	(30.2625007629394531,59.8003005981445312)	Europe/Moscow
KGD	{"en": "Khrabrovo Airport", "ru": "Храброво"}	{"en": "Kaliningrad", "ru": "Калининград"}	(20.5925998687744141,54.8899993896484375)	Europe/Kaliningrad
KEJ	{"en": "Kemerovo Airport", "ru": "Кемерово"}	{"en": "Kemorovo", "ru": "Кемерово"}	(86.1072006225585938,55.2700996398925781)	Asia/Novokuznetsk
CEK	{"en": "Chelyabinsk Balandino Airport", "ru": "Челябинск"}	{"en": "Chelyabinsk", "ru": "Челябинск"}	(61.503300000000003,55.3058010000000024)	Asia/Yekaterinburg
MQF	{"en": "Magnitogorsk International Airport", "ru": "Магнитогорск"}	{"en": "Magnetiogorsk", "ru": "Магнитогорск"}	(58.7556991577148438,53.3931007385253906)	Asia/Yekaterinburg
PEE	{"en": "Bolshoye Savino Airport", "ru": "Пермь"}	{"en": "Perm", "ru": "Пермь"}	(56.021198272705,57.9145011901860016)	Asia/Yekaterinburg
SGC	{"en": "Surgut Airport", "ru": "Сургут"}	{"en": "Surgut", "ru": "Сургут"}	(73.4018020629882812,61.3437004089355469)	Asia/Yekaterinburg
BZK	{"en": "Bryansk Airport", "ru": "Брянск"}	{"en": "Bryansk", "ru": "Брянск"}	(34.1763992309999978,53.2141990661999955)	Europe/Moscow
MRV	{"en": "Mineralnyye Vody Airport", "ru": "Минеральные Воды"}	{"en": "Mineralnye Vody", "ru": "Минеральные Воды"}	(43.0819015502929688,44.2251014709472656)	Europe/Moscow
STW	{"en": "Stavropol Shpakovskoye Airport", "ru": "Ставрополь"}	{"en": "Stavropol", "ru": "Ставрополь"}	(42.1128005981445312,45.1091995239257812)	Europe/Moscow
ASF	{"en": "Astrakhan Airport", "ru": "Астрахань"}	{"en": "Astrakhan", "ru": "Астрахань"}	(48.0063018799000005,46.2832984924000002)	Europe/Samara
NJC	{"en": "Nizhnevartovsk Airport", "ru": "Нижневартовск"}	{"en": "Nizhnevartovsk", "ru": "Нижневартовск"}	(76.4835968017578125,60.9492988586425781)	Asia/Yekaterinburg
SVX	{"en": "Koltsovo Airport", "ru": "Кольцово"}	{"en": "Yekaterinburg", "ru": "Екатеринбург"}	(60.8027000427250002,56.7430992126460012)	Asia/Yekaterinburg
SVO	{"en": "Sheremetyevo International Airport", "ru": "Шереметьево"}	{"en": "Moscow", "ru": "Москва"}	(37.4146000000000001,55.9725990000000024)	Europe/Moscow
VOZ	{"en": "Voronezh International Airport", "ru": "Воронеж"}	{"en": "Voronezh", "ru": "Воронеж"}	(39.2295989990234375,51.8142013549804688)	Europe/Moscow
VKO	{"en": "Vnukovo International Airport", "ru": "Внуково"}	{"en": "Moscow", "ru": "Москва"}	(37.2615013122999983,55.5914993286000012)	Europe/Moscow
SCW	{"en": "Syktyvkar Airport", "ru": "Сыктывкар"}	{"en": "Syktyvkar", "ru": "Сыктывкар"}	(50.8451004028320312,61.6469993591308594)	Europe/Moscow
KUF	{"en": "Kurumoch International Airport", "ru": "Курумоч"}	{"en": "Samara", "ru": "Самара"}	(50.1642990112299998,53.5049018859860013)	Europe/Samara
DME	{"en": "Domodedovo International Airport", "ru": "Домодедово"}	{"en": "Moscow", "ru": "Москва"}	(37.9062995910644531,55.4087982177734375)	Europe/Moscow
TJM	{"en": "Roshchino International Airport", "ru": "Рощино"}	{"en": "Tyumen", "ru": "Тюмень"}	(65.3243026732999965,57.1896018981999958)	Asia/Yekaterinburg
GOJ	{"en": "Nizhny Novgorod Strigino International Airport", "ru": "Стригино"}	{"en": "Nizhniy Novgorod", "ru": "Нижний Новгород"}	(43.7840003967289988,56.2300987243649999)	Europe/Moscow
TOF	{"en": "Bogashevo Airport", "ru": "Богашёво"}	{"en": "Tomsk", "ru": "Томск"}	(85.2082977294920028,56.3802986145020029)	Asia/Krasnoyarsk
UIK	{"en": "Ust-Ilimsk Airport", "ru": "Усть-Илимск"}	{"en": "Ust Ilimsk", "ru": "Усть-Илимск"}	(102.56500244140625,58.1361007690429688)	Asia/Irkutsk
NSK	{"en": "Norilsk-Alykel Airport", "ru": "Норильск"}	{"en": "Norilsk", "ru": "Норильск"}	(87.3321990966796875,69.31109619140625)	Asia/Krasnoyarsk
ARH	{"en": "Talagi Airport", "ru": "Талаги"}	{"en": "Arkhangelsk", "ru": "Архангельск"}	(40.7167015075683594,64.6003036499023438)	Europe/Moscow
RTW	{"en": "Saratov Central Airport", "ru": "Саратов-Центральный"}	{"en": "Saratov", "ru": "Саратов"}	(46.0466995239257812,51.5649986267089844)	Europe/Volgograd
NUX	{"en": "Novy Urengoy Airport", "ru": "Новый Уренгой"}	{"en": "Novy Urengoy", "ru": "Новый Уренгой"}	(76.5203018188476562,66.06939697265625)	Asia/Yekaterinburg
NOJ	{"en": "Noyabrsk Airport", "ru": "Ноябрьск"}	{"en": "Noyabrsk", "ru": "Ноябрьск"}	(75.2699966430664062,63.1833000183105469)	Asia/Yekaterinburg
UCT	{"en": "Ukhta Airport", "ru": "Ухта"}	{"en": "Ukhta", "ru": "Ухта"}	(53.8046989440917969,63.5668983459472656)	Europe/Moscow
USK	{"en": "Usinsk Airport", "ru": "Усинск"}	{"en": "Usinsk", "ru": "Усинск"}	(57.3671989440917969,66.00469970703125)	Europe/Moscow
NNM	{"en": "Naryan Mar Airport", "ru": "Нарьян-Мар"}	{"en": "Naryan-Mar", "ru": "Нарьян-Мар"}	(53.1218986511230469,67.6399993896484375)	Europe/Moscow
PKV	{"en": "Pskov Airport", "ru": "Псков"}	{"en": "Pskov", "ru": "Псков"}	(28.395599365234375,57.7839012145996094)	Europe/Moscow
KGP	{"en": "Kogalym International Airport", "ru": "Когалым"}	{"en": "Kogalym", "ru": "Когалым"}	(74.5337982177734375,62.190399169921875)	Asia/Yekaterinburg
KJA	{"en": "Yemelyanovo Airport", "ru": "Емельяново"}	{"en": "Krasnoyarsk", "ru": "Красноярск"}	(92.493301391602003,56.1729011535639984)	Asia/Krasnoyarsk
URJ	{"en": "Uray Airport", "ru": "Петрозаводск"}	{"en": "Uraj", "ru": "Урай"}	(64.8266983032226562,60.1032981872558594)	Asia/Yekaterinburg
IWA	{"en": "Ivanovo South Airport", "ru": "Иваново-Южный"}	{"en": "Ivanovo", "ru": "Иваново"}	(40.9407997131347656,56.9393997192382812)	Europe/Moscow
PYJ	{"en": "Polyarny Airport", "ru": "Полярный"}	{"en": "Yakutia", "ru": "Удачный"}	(112.029998778999996,66.4003982544000024)	Asia/Yakutsk
KXK	{"en": "Komsomolsk-on-Amur Airport", "ru": "Хурба"}	{"en": "Komsomolsk-on-Amur", "ru": "Комсомольск-на-Амуре"}	(136.934005737304688,50.4090003967285156)	Asia/Vladivostok
DYR	{"en": "Ugolny Airport", "ru": "Анадырь"}	{"en": "Anadyr", "ru": "Анадырь"}	(177.740997314453125,64.7349014282226562)	Asia/Anadyr
PES	{"en": "Petrozavodsk Airport", "ru": "Бесовец"}	{"en": "Petrozavodsk", "ru": "Петрозаводск"}	(34.1547012329101562,61.8852005004882812)	Europe/Moscow
KYZ	{"en": "Kyzyl Airport", "ru": "Кызыл"}	{"en": "Kyzyl", "ru": "Кызыл"}	(94.4005966186523438,51.6693992614746094)	Asia/Krasnoyarsk
NOZ	{"en": "Spichenkovo Airport", "ru": "Спиченково"}	{"en": "Novokuznetsk", "ru": "Новокузнецк"}	(86.877197265625,53.8114013671875)	Asia/Novokuznetsk
GRV	{"en": "Khankala Air Base", "ru": "Грозный"}	{"en": "Grozny", "ru": "Грозный"}	(45.7840995788574219,43.2980995178222656)	Europe/Moscow
NAL	{"en": "Nalchik Airport", "ru": "Нальчик"}	{"en": "Nalchik", "ru": "Нальчик"}	(43.6366004943847656,43.5129013061523438)	Europe/Moscow
OGZ	{"en": "Beslan Airport", "ru": "Беслан"}	{"en": "Beslan", "ru": "Владикавказ"}	(44.6066017150999983,43.2051010132000002)	Europe/Moscow
ESL	{"en": "Elista Airport", "ru": "Элиста"}	{"en": "Elista", "ru": "Элиста"}	(44.3308982849121094,46.3739013671875)	Europe/Moscow
SLY	{"en": "Salekhard Airport", "ru": "Салехард"}	{"en": "Salekhard", "ru": "Салехард"}	(66.6110000610351562,66.5907974243164062)	Asia/Yekaterinburg
HMA	{"en": "Khanty Mansiysk Airport", "ru": "Ханты-Мансийск"}	{"en": "Khanty-Mansiysk", "ru": "Ханты-Мансийск"}	(69.0860977172851562,61.0284996032714844)	Asia/Yekaterinburg
NYA	{"en": "Nyagan Airport", "ru": "Нягань"}	{"en": "Nyagan", "ru": "Нягань"}	(65.6149978637695312,62.1100006103515625)	Asia/Yekaterinburg
OVS	{"en": "Sovetskiy Airport", "ru": "Советский"}	{"en": "Sovetskiy", "ru": "Советский"}	(63.6019134521484375,61.3266220092773438)	Asia/Yekaterinburg
IJK	{"en": "Izhevsk Airport", "ru": "Ижевск"}	{"en": "Izhevsk", "ru": "Ижевск"}	(53.4575004577636719,56.8280982971191406)	Europe/Samara
KVX	{"en": "Pobedilovo Airport", "ru": "Победилово"}	{"en": "Kirov", "ru": "Киров"}	(49.3483009338379972,58.5032997131350001)	Europe/Moscow
NYM	{"en": "Nadym Airport", "ru": "Надым"}	{"en": "Nadym", "ru": "Надым"}	(72.6988983154296875,65.4809036254882812)	Asia/Yekaterinburg
NFG	{"en": "Nefteyugansk Airport", "ru": "Нефтеюганск"}	{"en": "Nefteyugansk", "ru": "Нефтеюганск"}	(72.6500015258789062,61.1082992553710938)	Asia/Yekaterinburg
KRO	{"en": "Kurgan Airport", "ru": "Курган"}	{"en": "Kurgan", "ru": "Курган"}	(65.4156036376953125,55.4752998352050781)	Asia/Yekaterinburg
EGO	{"en": "Belgorod International Airport", "ru": "Белгород"}	{"en": "Belgorod", "ru": "Белгород"}	(36.5900993347167969,50.643798828125)	Europe/Moscow
URS	{"en": "Kursk East Airport", "ru": "Курск-Восточный"}	{"en": "Kursk", "ru": "Курск"}	(36.2956008911132812,51.7505989074707031)	Europe/Moscow
LPK	{"en": "Lipetsk Airport", "ru": "Липецк"}	{"en": "Lipetsk", "ru": "Липецк"}	(39.5377998352050781,52.7028007507324219)	Europe/Moscow
VKT	{"en": "Vorkuta Airport", "ru": "Воркута"}	{"en": "Vorkuta", "ru": "Воркута"}	(63.9930992126464844,67.4886016845703125)	Europe/Moscow
UUA	{"en": "Bugulma Airport", "ru": "Бугульма"}	{"en": "Bugulma", "ru": "Бугульма"}	(52.8017005920410156,54.6399993896484375)	Europe/Moscow
JOK	{"en": "Yoshkar-Ola Airport", "ru": "Йошкар-Ола"}	{"en": "Yoshkar-Ola", "ru": "Йошкар-Ола"}	(47.9047012329101562,56.7005996704101562)	Europe/Moscow
CSY	{"en": "Cheboksary Airport", "ru": "Чебоксары"}	{"en": "Cheboksary", "ru": "Чебоксары"}	(47.3473014831542969,56.090301513671875)	Europe/Moscow
ULY	{"en": "Ulyanovsk East Airport", "ru": "Ульяновск-Восточный"}	{"en": "Ulyanovsk", "ru": "Ульяновск"}	(48.8027000427246094,54.4010009765625)	Europe/Samara
OSW	{"en": "Orsk Airport", "ru": "Орск"}	{"en": "Orsk", "ru": "Орск"}	(58.5956001281738281,51.0724983215332031)	Asia/Yekaterinburg
PEZ	{"en": "Penza Airport", "ru": "Пенза"}	{"en": "Penza", "ru": "Пенза"}	(45.0210990905761719,53.1105995178222656)	Europe/Moscow
SKX	{"en": "Saransk Airport", "ru": "Саранск"}	{"en": "Saransk", "ru": "Саранск"}	(45.2122573852539062,54.1251296997070312)	Europe/Moscow
TBW	{"en": "Donskoye Airport", "ru": "Донское"}	{"en": "Tambow", "ru": "Тамбов"}	(41.4827995300289984,52.806098937987997)	Europe/Moscow
UKX	{"en": "Ust-Kut Airport", "ru": "Усть-Кут"}	{"en": "Ust-Kut", "ru": "Усть-Кут"}	(105.730003356933594,56.8567008972167969)	Asia/Irkutsk
GDZ	{"en": "Gelendzhik Airport", "ru": "Геленджик"}	{"en": "Gelendzhik", "ru": "Геленджик"}	(38.012480735799997,44.5820926295000035)	Europe/Moscow
IAR	{"en": "Tunoshna Airport", "ru": "Туношна"}	{"en": "Yaroslavl", "ru": "Ярославль"}	(40.1573982238769531,57.560699462890625)	Europe/Moscow
NBC	{"en": "Begishevo Airport", "ru": "Бегишево"}	{"en": "Nizhnekamsk", "ru": "Нижнекамск"}	(52.092498779296875,55.5647010803222656)	Europe/Moscow
ULV	{"en": "Ulyanovsk Baratayevka Airport", "ru": "Баратаевка"}	{"en": "Ulyanovsk", "ru": "Ульяновск"}	(48.2266998291000064,54.2682991027999932)	Europe/Samara
SWT	{"en": "Strezhevoy Airport", "ru": "Стрежевой"}	{"en": "Strezhevoy", "ru": "Стрежевой"}	(77.66000366210001,60.7094001769999991)	Asia/Krasnoyarsk
EYK	{"en": "Beloyarskiy Airport", "ru": "Белоярский"}	{"en": "Beloyarsky", "ru": "Белоярский"}	(66.6986007689999951,63.6869010924999941)	Asia/Yekaterinburg
KLF	{"en": "Grabtsevo Airport", "ru": "Калуга"}	{"en": "Kaluga", "ru": "Калуга"}	(36.3666687011999983,54.5499992371000033)	Europe/Moscow
RGK	{"en": "Gorno-Altaysk Airport", "ru": "Горно-Алтайск"}	{"en": "Gorno-Altaysk", "ru": "Горно-Алтайск"}	(85.8332977295000035,51.9667015075999998)	Asia/Krasnoyarsk
KRR	{"en": "Krasnodar Pashkovsky International Airport", "ru": "Краснодар"}	{"en": "Krasnodar", "ru": "Краснодар"}	(39.1705017089839984,45.0346984863279971)	Europe/Moscow
MCX	{"en": "Uytash Airport", "ru": "Уйташ"}	{"en": "Makhachkala", "ru": "Махачкала"}	(47.6523017883300781,42.8167991638183594)	Europe/Moscow
KZN	{"en": "Kazan International Airport", "ru": "Казань"}	{"en": "Kazan", "ru": "Казань"}	(49.278701782227003,55.606201171875)	Europe/Moscow
REN	{"en": "Orenburg Central Airport", "ru": "Оренбург-Центральный"}	{"en": "Orenburg", "ru": "Оренбург"}	(55.4566993713378906,51.7957992553710938)	Asia/Yekaterinburg
UFA	{"en": "Ufa International Airport", "ru": "Уфа"}	{"en": "Ufa", "ru": "Уфа"}	(55.8744010925289984,54.5574989318850001)	Asia/Yekaterinburg
OVB	{"en": "Tolmachevo Airport", "ru": "Толмачёво"}	{"en": "Novosibirsk", "ru": "Новосибирск"}	(82.6507034301759944,55.012599945067997)	Asia/Novosibirsk
CEE	{"en": "Cherepovets Airport", "ru": "Череповец"}	{"en": "Cherepovets", "ru": "Череповец"}	(38.0158004761000043,59.2736015320000007)	Europe/Moscow
OMS	{"en": "Omsk Central Airport", "ru": "Омск-Центральный"}	{"en": "Omsk", "ru": "Омск"}	(73.3105010986328125,54.9669990539550781)	Asia/Omsk
ROV	{"en": "Rostov-on-Don Airport", "ru": "Ростов-на-Дону"}	{"en": "Rostov", "ru": "Ростов-на-Дону"}	(39.8180999755999991,47.2582015990999977)	Europe/Moscow
AER	{"en": "Sochi International Airport", "ru": "Сочи"}	{"en": "Sochi", "ru": "Сочи"}	(39.9566001892089986,43.4499015808110016)	Europe/Moscow
VOG	{"en": "Volgograd International Airport", "ru": "Гумрак"}	{"en": "Volgograd", "ru": "Волгоград"}	(44.3455009460449219,48.782501220703125)	Europe/Volgograd
BQS	{"en": "Ignatyevo Airport", "ru": "Игнатьево"}	{"en": "Blagoveschensk", "ru": "Благовещенск"}	(127.412002563476562,50.4253997802734375)	Asia/Yakutsk
GDX	{"en": "Sokol Airport", "ru": "Магадан"}	{"en": "Magadan", "ru": "Магадан"}	(150.720001220703125,59.9109992980957031)	Asia/Magadan
HTA	{"en": "Chita-Kadala Airport", "ru": "Чита"}	{"en": "Chita", "ru": "Чита"}	(113.305999999999997,52.0262990000000016)	Asia/Chita
BTK	{"en": "Bratsk Airport", "ru": "Братск"}	{"en": "Bratsk", "ru": "Братск"}	(101.697998046875,56.3706016540527344)	Asia/Irkutsk
IKT	{"en": "Irkutsk Airport", "ru": "Иркутск"}	{"en": "Irkutsk", "ru": "Иркутск"}	(104.388999938959998,52.2680015563960012)	Asia/Irkutsk
UUD	{"en": "Ulan-Ude Airport (Mukhino)", "ru": "Байкал"}	{"en": "Ulan-ude", "ru": "Улан-Удэ"}	(107.438003540039062,51.80780029296875)	Asia/Irkutsk
MMK	{"en": "Murmansk Airport", "ru": "Мурманск"}	{"en": "Murmansk", "ru": "Мурманск"}	(32.7508010864257812,68.7817001342773438)	Europe/Moscow
ABA	{"en": "Abakan Airport", "ru": "Абакан"}	{"en": "Abakan", "ru": "Абакан"}	(91.3850021362304688,53.7400016784667969)	Asia/Krasnoyarsk
BAX	{"en": "Barnaul Airport", "ru": "Барнаул"}	{"en": "Barnaul", "ru": "Барнаул"}	(83.5384979248046875,53.363800048828125)	Asia/Krasnoyarsk
AAQ	{"en": "Anapa Vityazevo Airport", "ru": "Витязево"}	{"en": "Anapa", "ru": "Анапа"}	(37.3473014831539984,45.002101898192997)	Europe/Moscow
CNN	{"en": "Chulman Airport", "ru": "Чульман"}	{"en": "Neryungri", "ru": "Нерюнгри"}	(124.914001464839998,56.9138984680179973)	Asia/Yakutsk
\.


--
-- Data for Name: boarding_passes; Type: TABLE DATA; Schema: bookings; Owner: -
--

COPY boarding_passes (ticket_no, flight_id, boarding_no, seat_no) FROM stdin;
0005435189093	198393	1	27G
0005435189119	198393	2	2D
0005435189096	198393	3	18E
0005435189117	198393	4	31B
0005432208788	198393	5	28C
0005435189151	198393	6	32A
0005433655456	198393	7	31J
0005435189129	198393	8	30C
0005435629876	198393	9	30E
0005435189100	198393	10	30F
0005435189112	198393	11	28G
0005435189152	198393	12	30K
0005435189102	198393	13	31A
0005435189146	198393	14	29G
0005435189132	198393	15	29D
0005435189142	198393	16	20G
0005432208786	198393	17	20C
0005435189104	198393	18	21B
0005435189135	198393	19	22A
0005435189130	198393	20	26J
0005435189145	198393	21	22C
0005435189123	198393	22	23F
0005435189088	198393	23	23J
0005435189121	198393	24	25D
0005435189134	198393	25	26D
0005432208790	198393	26	24F
0005435189107	198393	27	25C
0005435723806	198393	28	22D
0005435189087	198393	29	22E
0005435189154	198393	30	22K
0005435189139	198393	31	22B
0005435723803	198393	32	20K
0005435189148	198393	33	21K
0005435723805	198393	34	19G
0005433655457	198393	35	19K
0005432158191	198393	36	5A
0005435189147	198393	37	5D
0005432158194	198393	38	5G
0005435189118	198393	39	5H
0005435189103	198393	40	11C
0005432208787	198393	41	11G
0005435189153	198393	42	17H
0005435189097	198393	43	18C
0005435189144	198393	44	16F
0005435189127	198393	45	18A
0005435189137	198393	46	16A
0005435189091	198393	47	12G
0005435189109	198393	48	13A
0005435189140	198393	49	4A
0005435189115	198393	50	4K
0005435189111	198393	51	46J
0005432208789	198393	52	49K
0005435189120	198393	53	1K
0005435723804	198393	54	2A
0005435189101	198393	55	32C
0005435189126	198393	56	51E
0005432158190	198393	57	50A
0005435189150	198393	58	44F
0005433655458	198393	59	44H
0005435189124	198393	60	45C
0005432158192	198393	61	45A
0005435189108	198393	62	33J
0005435189131	198393	63	45F
0005435189138	198393	64	46G
0005435189090	198393	65	33C
0005435189141	198393	66	43K
0005435189110	198393	67	39J
0005435629874	198393	68	43A
0005435189098	198393	69	40K
0005432208784	198393	70	43G
0005435189113	198393	71	41E
0005435189089	198393	72	42C
0005435189092	198393	73	42B
0005435189116	198393	74	41K
0005435189143	198393	75	42A
0005435189105	198393	76	34E
0005435189095	198393	77	34K
0005435189122	198393	78	34G
0005435189136	198393	79	37J
0005432158193	198393	80	37K
0005435189094	198393	81	38A
0005435189114	198393	82	39D
0005435189128	198393	83	39C
0005435189155	198393	84	35E
0005435189099	198393	85	37E
0005435189125	198393	86	37F
0005435189133	198393	87	35K
0005432208785	198393	88	36D
0005435629875	198393	89	37A
0005435189106	198393	90	36K
0005435189149	198393	91	33G
0005433354369	161045	1	17F
0005433354357	161045	2	19E
0005433354384	161045	3	19F
0005433354360	161045	4	3F
0005433354353	161045	5	18C
0005433354381	161045	6	20C
0005433354377	161045	7	4C
0005433354382	161045	8	10A
0005433354362	161045	9	9A
0005433354371	161045	10	13E
0005433354375	161045	11	13F
0005433354364	161045	12	13D
0005433354354	161045	13	12E
0005433354383	161045	14	13C
0005433354365	161045	15	11D
0005433354361	161045	16	11F
0005433354385	161045	17	9E
0005433354379	161045	18	6F
0005433354389	161045	19	8D
0005433354372	161045	20	8F
0005433354355	161045	21	20E
0005433354387	161045	22	3D
0005433354380	161045	23	19A
0005433354370	161045	24	3A
0005433354388	161045	25	2D
0005433354386	161045	26	20F
0005433354378	161045	27	2A
0005433354373	161045	28	16D
0005433354356	161045	29	16E
0005433354390	161045	30	17D
0005433354374	161045	31	16F
0005433354368	161045	32	17E
0005433354367	161045	33	17A
0005433354376	161045	34	15D
0005433354363	161045	35	16C
0005433354366	161045	36	14E
0005433354359	161045	37	15F
0005433354358	161045	38	16A
0005434968966	13369	1	21C
0005434968945	13369	2	21D
0005434968956	13369	3	23B
0005435800600	13369	4	6C
0005434968967	13369	5	22A
0005434968954	13369	6	22D
0005435800597	13369	7	23A
0005434968959	13369	8	22C
0005434968951	13369	9	7A
0005435800599	13369	10	6D
0005434968963	13369	11	7B
0005434968964	13369	12	7D
0005434968974	13369	13	18C
0005434968953	13369	14	19A
0005434968960	13369	15	19B
0005434968975	13369	16	21B
0005434968970	13369	17	19D
0005434968971	13369	18	20A
0005434968947	13369	19	20C
0005434968965	13369	20	21A
0005434968961	13369	21	20D
0005434968955	13369	22	1C
0005434968958	13369	23	1D
0005434968949	13369	24	4B
0005434968946	13369	25	4C
0005434968948	13369	26	5D
0005434968968	13369	27	6B
0005434968950	13369	28	5B
0005434968962	13369	29	3D
0005434968957	13369	30	3C
0005435800598	13369	31	2D
0005434968972	13369	32	3B
0005434968973	13369	33	2C
0005434968952	13369	34	1B
0005434968969	13369	35	1A
0005434951183	17140	1	3B
0005434951182	17140	2	1B
0005433255597	182960	1	3A
0005433255596	182960	2	3B
0005433110705	127967	1	2B
0005433110703	127967	2	5A
0005433110704	127967	3	6A
0005433111795	127967	4	2A
0005433533722	43971	1	3A
0005433535760	43971	2	4A
0005433535758	43971	3	6A
0005433535762	43971	4	6C
0005433533723	43971	5	18A
0005433535759	43971	6	19D
0005433535763	43971	7	22A
0005433535757	43971	8	1B
0005433535761	43971	9	2B
0005433535764	43971	10	22B
0005435258163	162193	1	20D
0005435258162	162193	2	7C
0005435258161	162193	3	19B
0005435258164	162193	4	2C
0005433508902	5163	1	18D
0005433508909	5163	2	19A
0005433508905	5163	3	1C
0005433508903	5163	4	19C
0005433508907	5163	5	20C
0005433508906	5163	6	2C
0005433508908	5163	7	22A
0005433508910	5163	8	23B
0005433508904	5163	9	7A
0005432921050	104671	1	6C
0005432921052	104671	2	21D
0005432921049	104671	3	1C
0005432921051	104671	4	3D
0005435687226	23867	1	19B
0005435687239	23867	2	19C
0005434948896	23867	3	20A
0005435687218	23867	4	20D
0005435687235	23867	5	21A
0005434948897	23867	6	21C
0005435687219	23867	7	21B
0005435687225	23867	8	20B
0005435687234	23867	9	20C
0005435687230	23867	10	3B
0005435687238	23867	11	7D
0005435687240	23867	12	18A
0005435687237	23867	13	18B
0005434948898	23867	14	18D
0005435687233	23867	15	5D
0005435687224	23867	16	6C
0005435687242	23867	17	3C
0005434948899	23867	18	7C
0005435687223	23867	19	6A
0005434948895	23867	20	6B
0005435687229	23867	21	3D
0005435687241	23867	22	4A
0005435687231	23867	23	5C
0005435687227	23867	24	4B
0005435687243	23867	25	5A
0005435687222	23867	26	4C
0005435687232	23867	27	4D
0005435687221	23867	28	3A
0005435687228	23867	29	2A
0005435687216	23867	30	2B
0005435687220	23867	31	1C
0005435687244	23867	32	1D
0005435687217	23867	33	21D
0005435687236	23867	34	22C
0005435915159	105801	1	4B
0005434605513	25568	1	3A
0005432608252	25568	2	4B
0005432608249	25568	3	4A
0005432608251	25568	4	6D
0005433517807	25568	5	4C
0005432608250	25568	6	3C
0005434605511	25568	7	5A
0005432606087	25568	8	6C
0005433517804	25568	9	5D
0005434605512	25568	10	5C
0005433517806	25568	11	3D
0005434605514	25568	12	3B
0005432606088	25568	13	1B
0005432606089	25568	14	2C
0005434603545	25568	15	19D
0005434603542	25568	16	20A
0005432606090	25568	17	21B
0005434603543	25568	18	23B
0005434603541	25568	19	18A
0005433517805	25568	20	19A
0005434603544	25568	21	18B
0005434605510	25568	22	7D
0005435627602	4604	1	3A
0005435627604	4604	2	4A
0005435627603	4604	3	4B
0005435627601	4604	4	5A
0005433346900	103534	1	1A
0005433346899	103534	2	3A
0005433346901	103534	3	4B
0005433346902	103534	4	5A
0005433346898	103534	5	5B
0005433346897	103534	6	6B
0005433158514	113947	1	2B
0005433158515	113947	2	5A
0005433158513	113947	3	2A
0005435129066	51007	1	23A
0005435129060	51007	2	20B
0005435129064	51007	3	5D
0005435129061	51007	4	21A
0005435129063	51007	5	20D
0005435129057	51007	6	6C
0005435129062	51007	7	19A
0005435129059	51007	8	19C
0005435129065	51007	9	1C
0005435129058	51007	10	3A
0005435129067	51007	11	3B
0005435381195	214785	1	6D
0005435381200	214785	2	7C
0005435381196	214785	3	20A
0005435381198	214785	4	20C
0005435381199	214785	5	21A
0005435381197	214785	6	1B
0005435809240	28521	1	11D
0005435809241	28521	2	11B
0005435809238	28521	3	8D
0005435809243	28521	4	9E
0005435809239	28521	5	12D
0005435809242	28521	6	12A
0005435809244	28521	7	16B
0005435937941	191101	1	1A
0005435937940	191101	2	3F
0005435156264	48595	1	22A
0005435156265	48595	2	22B
0005435156260	48595	3	1D
0005435156267	48595	4	3A
0005435156262	48595	5	2C
0005435156261	48595	6	4B
0005435156266	48595	7	7B
0005435156263	48595	8	18B
0005435156259	48595	9	3C
0005435156268	48595	10	19B
0005435156269	48595	11	19D
0005435387729	191805	1	20A
0005435387728	191805	2	20D
0005435387730	191805	3	21A
0005435387734	191805	4	2C
0005435387732	191805	5	2D
0005435387733	191805	6	4B
0005435387731	191805	7	5A
0005435178682	119841	1	6B
0005435178681	119841	2	1A
0005435178049	119841	3	2B
0005435178050	119841	4	5A
0005434490023	42420	1	15A
0005435101371	42420	2	2A
0005434490015	42420	3	6E
0005434490019	42420	4	7C
0005434490005	42420	5	9D
0005435101375	42420	6	7F
0005435101370	42420	7	8A
0005434490021	42420	8	6F
0005434490010	42420	9	7A
0005435101366	42420	10	16E
0005434490009	42420	11	4C
0005435101368	42420	12	3F
0005434489988	42420	13	6C
0005434490017	42420	14	4E
0005435101369	42420	15	4D
0005434489989	42420	16	6A
0005434489992	42420	17	5A
0005435101367	42420	18	5E
0005434490004	42420	19	1D
0005434490011	42420	20	1F
0005434489997	42420	21	17C
0005434489994	42420	22	19E
0005434490002	42420	23	20D
0005434490016	42420	24	1A
0005434490018	42420	25	19F
0005435101372	42420	26	20C
0005434490001	42420	27	18F
0005434490006	42420	28	18E
0005434490025	42420	29	19C
0005434490024	42420	30	17A
0005434490003	42420	31	18D
0005434489998	42420	32	18C
0005434490022	42420	33	17E
0005435101373	42420	34	16A
0005434490008	42420	35	16D
0005434490026	42420	36	14F
0005435101365	42420	37	15E
0005434490014	42420	38	9E
0005434489987	42420	39	10D
0005434490007	42420	40	10A
0005434489995	42420	41	13C
0005434490013	42420	42	11C
0005434489999	42420	43	11E
0005434489990	42420	44	12E
0005434489991	42420	45	12F
0005434490020	42420	46	13A
0005434490012	42420	47	14A
0005434489993	42420	48	8E
0005435101374	42420	49	9A
0005434489996	42420	50	8F
0005434490000	42420	51	8C
0005435637365	10784	1	14D
0005435637370	10784	2	16D
0005435637364	10784	3	15F
0005435637375	10784	4	14E
0005435637368	10784	5	2C
0005435637382	10784	6	15C
0005435637362	10784	7	14A
0005435637386	10784	8	1F
0005435637374	10784	9	1D
0005435637390	10784	10	10E
0005435637367	10784	11	9E
0005435637391	10784	12	8E
0005435637384	10784	13	7A
0005435637388	10784	14	7D
0005435637385	10784	15	6F
0005435637378	10784	16	6E
0005435637369	10784	17	4F
0005435637377	10784	18	3C
0005435637371	10784	19	6C
0005435637380	10784	20	6A
0005435637387	10784	21	8D
0005435637389	10784	22	10D
0005435637376	10784	23	8F
0005435637381	10784	24	12F
0005435637394	10784	25	11E
0005435637361	10784	26	13E
0005435637383	10784	27	13C
0005435637366	10784	28	13A
0005435637363	10784	29	17A
0005435637372	10784	30	17D
0005435637392	10784	31	18A
0005435637393	10784	32	19F
0005435637373	10784	33	20D
0005435637379	10784	34	20E
0005433354370	140798	1	7D
0005433354369	140798	2	7F
0005433354367	140798	3	8D
0005433354357	140798	4	8A
0005433354388	140798	5	8E
0005433354387	140798	6	1A
0005433354373	140798	7	4D
0005433354381	140798	8	6F
0005433354363	140798	9	4E
0005433354365	140798	10	5F
0005433354362	140798	11	5E
0005433354376	140798	12	2F
0005433354383	140798	13	5A
0005433354355	140798	14	5D
0005433354382	140798	15	3F
0005433354358	140798	16	3A
0005433354385	140798	17	4A
0005433354379	140798	18	4C
0005433354371	140798	19	3C
0005433354380	140798	20	15F
0005433354354	140798	21	16F
0005433354360	140798	22	20D
0005433354361	140798	23	17F
0005433354378	140798	24	17A
0005433354384	140798	25	18F
0005433354368	140798	26	20C
0005433354372	140798	27	19D
0005433354366	140798	28	15C
0005433354386	140798	29	14F
0005433354374	140798	30	9D
0005433354353	140798	31	8F
0005433354377	140798	32	10E
0005433354389	140798	33	10F
0005433354356	140798	34	12D
0005433354390	140798	35	13C
0005433354375	140798	36	12A
0005433354359	140798	37	13F
0005433354364	140798	38	12E
0005433969136	26956	1	12F
0005433969132	26956	2	13C
0005433969145	26956	3	11D
0005433969131	26956	4	12D
0005433969161	26956	5	12E
0005433969141	26956	6	11A
0005433969148	26956	7	16D
0005435787839	26956	8	16F
0005433969144	26956	9	2C
0005433969158	26956	10	19E
0005433969139	26956	11	5C
0005433969155	26956	12	3A
0005435787838	26956	13	6C
0005433969154	26956	14	7F
0005433969134	26956	15	6F
0005435787840	26956	16	9D
0005433969133	26956	17	10C
0005433969150	26956	18	8A
0005433969152	26956	19	8F
0005433969135	26956	20	3C
0005433969151	26956	21	4C
0005433969142	26956	22	4D
0005433969140	26956	23	3D
0005433969130	26956	24	20E
0005433969156	26956	25	20A
0005433969146	26956	26	1C
0005433969143	26956	27	1D
0005433969149	26956	28	19A
0005433969157	26956	29	17E
0005433969147	26956	30	17F
0005433969137	26956	31	18D
0005433969159	26956	32	14C
0005433969153	26956	33	14F
0005433969138	26956	34	16A
0005433969160	26956	35	14D
0005434506392	10561	1	2B
0005434506388	10561	2	2C
0005434506390	10561	3	5B
0005434506393	10561	4	5D
0005434506389	10561	5	6D
0005434506387	10561	6	7D
0005434506386	10561	7	20C
0005434506391	10561	8	21C
0005432867139	115681	1	20C
0005434150646	115681	2	19A
0005434150645	115681	3	17F
0005434150647	115681	4	17A
0005432867140	115681	5	15D
0005432867138	115681	6	14E
0005432867144	115681	7	2F
0005432867141	115681	8	7F
0005432867143	115681	9	9E
0005432867142	115681	10	11A
0005432863501	162632	1	16A
0005432863499	162632	2	3A
0005432863498	162632	3	10C
0005432863496	162632	4	10F
0005432863497	162632	5	13F
0005432863502	162632	6	20E
0005432863500	162632	7	2C
0005432312201	19976	1	11A
0005432312191	19976	2	12F
0005432312184	19976	3	13A
0005432312181	19976	4	13F
0005433436543	19976	5	12A
0005433436546	19976	6	13C
0005432312199	19976	7	12C
0005433436542	19976	8	11D
0005432312174	19976	9	11C
0005432285351	19976	10	10E
0005432312165	19976	11	19D
0005432312172	19976	12	3F
0005432312203	19976	13	10F
0005433436548	19976	14	4C
0005432312193	19976	15	4D
0005432312200	19976	16	4E
0005433436544	19976	17	4F
0005432312206	19976	18	5F
0005432312192	19976	19	9C
0005432312208	19976	20	9D
0005432285353	19976	21	9E
0005432312187	19976	22	10C
0005432312177	19976	23	9F
0005432312164	19976	24	10A
0005432312185	19976	25	7D
0005432312197	19976	26	9A
0005432312198	19976	27	7F
0005432312175	19976	28	8E
0005432312176	19976	29	8A
0005432312207	19976	30	7A
0005432312166	19976	31	7C
0005433436547	19976	32	5E
0005432285355	19976	33	6A
0005432312182	19976	34	6D
0005432312196	19976	35	6E
0005432285352	19976	36	5A
0005432312189	19976	37	5D
0005432285356	19976	38	20A
0005432312178	19976	39	2D
0005432312186	19976	40	1A
0005432312183	19976	41	20F
0005432312195	19976	42	1C
0005432312188	19976	43	19A
0005432312190	19976	44	19C
0005432312167	19976	45	17A
0005432312163	19976	46	18D
0005432312204	19976	47	17D
0005432312205	19976	48	17E
0005433436549	19976	49	16A
0005432312168	19976	50	17F
0005433436545	19976	51	18C
0005432312194	19976	52	16D
0005432312209	19976	53	16C
0005432312170	19976	54	16F
0005432312179	19976	55	15C
0005432285354	19976	56	15D
0005432312202	19976	57	15F
0005432312169	19976	58	15E
0005432312171	19976	59	14D
0005432312173	19976	60	14E
0005432312180	19976	61	14A
0005432902969	201988	1	18A
0005432053241	201988	2	19A
0005432902968	201988	3	13D
0005432902973	201988	4	11A
0005432902970	201988	5	9D
0005432902971	201988	6	11F
0005432053242	201988	7	3A
0005432902972	201988	8	16E
0005432053243	201988	9	10D
0005432902974	201988	10	14A
0005435993296	40096	1	4A
0005434304815	40096	2	4E
0005435993277	40096	3	5C
0005434304806	40096	4	5F
0005434304814	40096	5	6C
0005435993290	40096	6	6E
0005434304812	40096	7	7F
0005435993278	40096	8	8D
0005434304810	40096	9	9E
0005435993295	40096	10	10B
0005435993286	40096	11	10E
0005435993281	40096	12	11C
0005435993294	40096	13	13B
0005435993291	40096	14	13C
0005434304807	40096	15	14A
0005435993284	40096	16	14C
0005435993289	40096	17	16B
0005434304816	40096	18	16D
0005434304811	40096	19	17C
0005435993285	40096	20	17D
0005435993287	40096	21	17E
0005435993279	40096	22	18C
0005435993283	40096	23	19B
0005435993276	40096	24	19C
0005435993293	40096	25	23F
0005434304808	40096	26	23E
0005435993282	40096	27	22C
0005434304805	40096	28	22A
0005434304804	40096	29	21A
0005434304813	40096	30	1A
0005434304817	40096	31	1F
0005435993292	40096	32	2D
0005435993288	40096	33	2F
0005434304809	40096	34	3C
0005435993280	40096	35	3D
0005435294584	126693	1	16B
0005435294581	126693	2	13C
0005435294583	126693	3	13B
0005435294586	126693	4	11C
0005435294582	126693	5	22F
0005435294580	126693	6	2C
0005435294585	126693	7	7A
0005435511404	10060	1	7A
0005435494516	10060	2	9E
0005435494509	10060	3	9F
0005435494506	10060	4	10D
0005435494519	10060	5	10F
0005435494508	10060	6	11E
0005435504512	10060	7	11A
0005435511391	10060	8	14D
0005434561066	10060	9	19D
0005435511402	10060	10	20C
0005435511390	10060	11	20F
0005435504508	10060	12	19F
0005435504503	10060	13	20E
0005434561059	10060	14	20D
0005435504511	10060	15	17D
0005435504507	10060	16	18E
0005435494521	10060	17	18F
0005435511403	10060	18	17E
0005435494518	10060	19	18D
0005435511399	10060	20	18A
0005435494512	10060	21	18C
0005434561063	10060	22	11F
0005434561069	10060	23	14E
0005435511401	10060	24	16F
0005434561065	10060	25	17C
0005435511405	10060	26	15A
0005434561068	10060	27	17A
0005435511397	10060	28	15E
0005435494527	10060	29	16C
0005435494520	10060	30	15F
0005435494517	10060	31	16A
0005435504504	10060	32	13E
0005435511395	10060	33	14A
0005435504505	10060	34	14C
0005432291062	10060	35	12E
0005434561071	10060	36	13C
0005434561072	10060	37	12F
0005435511394	10060	38	12A
0005435494526	10060	39	12D
0005435494523	10060	40	11D
0005435494524	10060	41	12C
0005435494514	10060	42	11C
0005435494505	10060	43	10E
0005435511400	10060	44	7C
0005435504506	10060	45	7D
0005435504513	10060	46	9D
0005435504502	10060	47	8F
0005435511392	10060	48	9A
0005435511388	10060	49	9C
0005435494507	10060	50	8D
0005435494525	10060	51	8C
0005434561070	10060	52	8A
0005435494515	10060	53	7E
0005435511406	10060	54	6F
0005435511408	10060	55	6A
0005435504509	10060	56	3F
0005435504510	10060	57	6C
0005435504514	10060	58	6D
0005435494513	10060	59	6E
0005432291063	10060	60	5A
0005434561064	10060	61	4A
0005435504500	10060	62	5D
0005435494511	10060	63	5E
0005434561060	10060	64	4C
0005434561058	10060	65	4F
0005434561061	10060	66	4D
0005435511407	10060	67	4E
0005435511396	10060	68	3D
0005435504501	10060	69	2C
0005435511398	10060	70	2D
0005434561062	10060	71	3C
0005434561067	10060	72	2F
0005435511389	10060	73	3A
0005435494522	10060	74	1C
0005435511393	10060	75	1D
0005435494510	10060	76	1A
0005433183036	135525	1	5D
0005433183030	135525	2	15A
0005433183034	135525	3	2A
0005433183031	135525	4	17A
0005433183032	135525	5	4C
0005433183033	135525	6	13E
0005433183035	135525	7	12C
0005433183029	135525	8	7F
0005433183028	135525	9	13F
0005435151355	25486	1	22D
0005435151360	25486	2	19D
0005435151357	25486	3	18C
0005435151359	25486	4	5C
0005435151358	25486	5	2D
0005435151356	25486	6	6B
0005435930245	141889	1	5A
0005435930247	141889	2	21D
0005435930246	141889	3	23B
0005432623520	46530	1	20D
0005432623514	46530	2	21C
0005432623521	46530	3	22B
0005432623512	46530	4	23A
0005432623519	46530	5	7C
0005432623518	46530	6	20B
0005432623517	46530	7	7D
0005432623516	46530	8	19C
0005432623508	46530	9	18A
0005432623513	46530	10	3C
0005432623509	46530	11	6B
0005432623510	46530	12	4C
0005432623511	46530	13	2C
0005432623515	46530	14	1C
0005435222682	182582	1	23B
0005435222680	182582	2	22B
0005435222673	182582	3	18A
0005435222677	182582	4	22D
0005435222675	182582	5	20A
0005435222679	182582	6	3A
0005435222674	182582	7	7B
0005435222681	182582	8	7A
0005435222676	182582	9	5C
0005435222678	182582	10	19A
0005435958668	56836	1	21B
0005435958667	56836	2	19A
0005435958666	56836	3	6B
0005435958664	56836	4	4B
0005435958665	56836	5	1A
0005434266582	98733	1	1B
0005434266583	98733	2	2D
0005434266584	98733	3	5C
0005434266585	98733	4	20C
0005432669639	7871	1	7E
0005432669636	7871	2	7B
0005432669635	7871	3	6E
0005432669633	7871	4	3F
0005432669628	7871	5	19B
0005432669634	7871	6	7F
0005432669637	7871	7	10C
0005432669627	7871	8	9D
0005432669641	7871	9	8F
0005432669643	7871	10	9B
0005432669642	7871	11	18C
0005432669638	7871	12	12C
0005432669632	7871	13	12A
0005432669630	7871	14	17E
0005432669629	7871	15	16D
0005432669631	7871	16	17C
0005432669640	7871	17	20F
0005432870719	113340	1	8D
0005432870716	113340	2	6D
0005432870718	113340	3	3C
0005432870717	113340	4	1C
0005432870720	113340	5	14A
0005432870722	113340	6	12D
0005432870721	113340	7	11D
0005434429618	7483	1	1D
0005434429612	7483	2	2D
0005434429624	7483	3	3B
0005434429613	7483	4	5C
0005434429620	7483	5	6C
0005434429619	7483	6	18A
0005434429625	7483	7	21C
0005434429611	7483	8	22D
0005434429626	7483	9	23B
0005434429615	7483	10	18D
0005434429622	7483	11	20C
0005434429617	7483	12	21A
0005434429621	7483	13	18B
0005434429623	7483	14	5B
0005434429616	7483	15	1A
0005434429614	7483	16	1C
0005433153621	112220	1	6C
0005433153626	112220	2	18B
0005433153625	112220	3	22B
0005433153620	112220	4	22A
0005433153622	112220	5	3C
0005433153619	112220	6	4B
0005433153623	112220	7	4A
0005433153624	112220	8	1D
0005433153618	112220	9	1A
0005435084096	26365	1	3C
0005435084092	26365	2	19D
0005435084095	26365	3	20A
0005435084098	26365	4	21C
0005435084099	26365	5	21A
0005435084094	26365	6	1B
0005435084093	26365	7	18C
0005435084097	26365	8	2D
0005435926398	158332	1	6B
0005435926399	158332	2	7B
0005435926400	158332	3	19D
0005435926401	158332	4	20B
0005435926397	158332	5	23A
0005432278505	8550	1	15E
0005434957362	8550	2	15G
0005434957371	8550	3	23D
0005434957363	8550	4	19A
0005434957375	8550	5	18A
0005434957359	8550	6	24H
0005434957366	8550	7	29F
0005434957361	8550	8	29H
0005434957370	8550	9	39D
0005434957372	8550	10	34H
0005434957357	8550	11	35E
0005434957367	8550	12	31D
0005434957373	8550	13	31G
0005434957358	8550	14	27F
0005434957369	8550	15	28H
0005434957360	8550	16	18F
0005432278507	8550	17	21H
0005434957365	8550	18	16H
0005434957374	8550	19	14H
0005434957368	8550	20	2A
0005434957376	8550	21	14A
0005434957364	8550	22	11G
0005432278506	8550	23	12A
0005433257908	118426	1	5A
0005433257902	118426	2	12B
0005433257904	118426	3	31G
0005433257906	118426	4	20G
0005433257907	118426	5	36H
0005433257903	118426	6	24D
0005433257910	118426	7	27H
0005433257911	118426	8	28F
0005433257909	118426	9	30D
0005433257905	118426	10	31A
0005434622512	31522	1	14D
0005434622515	31522	2	13D
0005434622511	31522	3	12E
0005434622513	31522	4	11D
0005434622509	31522	5	12A
0005434622514	31522	6	6A
0005434622517	31522	7	8D
0005434622510	31522	8	2C
0005434622516	31522	9	5E
0005435905641	213487	1	10C
0005435905640	213487	2	10D
0005435905637	213487	3	6A
0005435905638	213487	4	6D
0005435905639	213487	5	3F
0005432194933	89353	1	1B
0005435935842	89353	2	3A
0005432194934	89353	3	6A
0005435935843	89353	4	22C
0005432194932	89353	5	23A
0005435306868	131399	1	15C
0005432056957	131399	2	15D
0005435306871	131399	3	15E
0005435306874	131399	4	17F
0005435306876	131399	5	18C
0005432056956	131399	6	20D
0005435306873	131399	7	7E
0005435306875	131399	8	13E
0005432056958	131399	9	13F
0005435306872	131399	10	14F
0005435306864	131399	11	7F
0005435306863	131399	12	12A
0005435306865	131399	13	12C
0005435306869	131399	14	8C
0005432056959	131399	15	10A
0005435306861	131399	16	9A
0005435306870	131399	17	3C
0005435306860	131399	18	5D
0005435306866	131399	19	7A
0005432056955	131399	20	3F
0005435306862	131399	21	4C
0005435306867	131399	22	4A
0005435306859	131399	23	1D
0005434385002	174935	1	9C
0005434385003	174935	2	9F
0005432151404	174935	3	9D
0005434385033	174935	4	19D
0005434384978	174935	5	12C
0005434385037	174935	6	19E
0005434385025	174935	7	20F
0005434385009	174935	8	20A
0005432151406	174935	9	20C
0005434384989	174935	10	20E
0005434385027	174935	11	20D
0005434385015	174935	12	12D
0005434385039	174935	13	15E
0005434385036	174935	14	19C
0005434385017	174935	15	17F
0005434384983	174935	16	18A
0005434385030	174935	17	19A
0005434384985	174935	18	18C
0005432151410	174935	19	15F
0005434384993	174935	20	17D
0005434384999	174935	21	17E
0005434385006	174935	22	16A
0005434385008	174935	23	17C
0005434384982	174935	24	17A
0005434385020	174935	25	12E
0005434385000	174935	26	14D
0005434385031	174935	27	15D
0005434385016	174935	28	14F
0005434385038	174935	29	15C
0005434385010	174935	30	15A
0005434385018	174935	31	13A
0005434385001	174935	32	13F
0005434384986	174935	33	14C
0005434384981	174935	34	14A
0005434385021	174935	35	13C
0005434385024	174935	36	13E
0005434385029	174935	37	13D
0005434385040	174935	38	12A
0005434385011	174935	39	11F
0005434384980	174935	40	11C
0005434385012	174935	41	11E
0005434384979	174935	42	10F
0005434385032	174935	43	10E
0005434384997	174935	44	10A
0005434385022	174935	45	7A
0005434384995	174935	46	7C
0005434385026	174935	47	7E
0005434384996	174935	48	9A
0005434384976	174935	49	8A
0005434384994	174935	50	8E
0005434384984	174935	51	8C
0005434385005	174935	52	6C
0005434385019	174935	53	4F
0005432151409	174935	54	6D
0005434384998	174935	55	6F
0005434385035	174935	56	6E
0005434385014	174935	57	5A
0005434384987	174935	58	5F
0005434385013	174935	59	6A
0005432151405	174935	60	5C
0005434384977	174935	61	5E
0005434385007	174935	62	5D
0005434384991	174935	63	4D
0005434385028	174935	64	2F
0005434385004	174935	65	3C
0005432151408	174935	66	4A
0005434385023	174935	67	3D
0005432151407	174935	68	2C
0005434384992	174935	69	2D
0005434385034	174935	70	1C
0005434384988	174935	71	2A
0005434384990	174935	72	1F
0005434310469	37015	1	19D
0005434314434	37015	2	14C
0005434314431	37015	3	1D
0005434314432	37015	4	2C
0005434314436	37015	5	3F
0005434314435	37015	6	5C
0005432108708	37015	7	7E
0005432108709	37015	8	7F
0005434310470	37015	9	10F
0005434314433	37015	10	11F
0005433116476	101898	1	10D
0005433116491	101898	2	11E
0005433116492	101898	3	12D
0005433116484	101898	4	7D
0005433116490	101898	5	7E
0005433116486	101898	6	8F
0005433116494	101898	7	3A
0005433116489	101898	8	4E
0005433116478	101898	9	2C
0005433116475	101898	10	3F
0005433116474	101898	11	4D
0005433116479	101898	12	12E
0005433116487	101898	13	13A
0005433116493	101898	14	15C
0005433116482	101898	15	15D
0005433116480	101898	16	15E
0005433116481	101898	17	16E
0005433116488	101898	18	13D
0005433116477	101898	19	17A
0005433116485	101898	20	18D
0005433116495	101898	21	18E
0005433116483	101898	22	12F
0005434481975	58442	1	18A
0005434481971	58442	2	7D
0005434481972	58442	3	6C
0005434481973	58442	4	18D
0005434481970	58442	5	19D
0005434481969	58442	6	4C
0005434481974	58442	7	1D
0005434187091	107917	1	5D
0005434187090	107917	2	18B
0005434187089	107917	3	18D
0005434187092	107917	4	19C
0005434187094	107917	5	20A
0005434187093	107917	6	1C
0005433116475	49365	1	12F
0005433116495	49365	2	13E
0005433116480	49365	3	9F
0005433116488	49365	4	11D
0005433116494	49365	5	8E
0005433116478	49365	6	9E
0005433116492	49365	7	7D
0005433116491	49365	8	9D
0005433116477	49365	9	14E
0005433116479	49365	10	6E
0005433116476	49365	11	18F
0005433116490	49365	12	6A
0005433116481	49365	13	19C
0005433116484	49365	14	3F
0005433116489	49365	15	20F
0005433116485	49365	16	1D
0005433116486	49365	17	2D
0005433116474	49365	18	3D
0005433116487	49365	19	18C
0005433116483	49365	20	16D
0005433116493	49365	21	14D
0005433116482	49365	22	13F
0005432711247	49898	1	10F
0005432681972	49898	2	16D
0005432681983	49898	3	3F
0005432681970	49898	4	8F
0005432711237	49898	5	11A
0005432711242	49898	6	11D
0005432681979	49898	7	12A
0005432681959	49898	8	12C
0005433442135	49898	9	13F
0005433442138	49898	10	13A
0005432711243	49898	11	11F
0005432711245	49898	12	13D
0005432681969	49898	13	13E
0005433442144	49898	14	13C
0005432711248	49898	15	12E
0005432711235	49898	16	12D
0005433442126	49898	17	12F
0005432711224	49898	18	10D
0005433442127	49898	19	9A
0005432711239	49898	20	10E
0005433442137	49898	21	9C
0005432070499	49898	22	10A
0005432681984	49898	23	9D
0005432681985	49898	24	10C
0005433442129	49898	25	9F
0005433442141	49898	26	8D
0005432681958	49898	27	8E
0005432681976	49898	28	7E
0005433442142	49898	29	7C
0005432681957	49898	30	8A
0005433442140	49898	31	7F
0005432711228	49898	32	5A
0005433442128	49898	33	5E
0005432681968	49898	34	6E
0005432681955	49898	35	5F
0005433442131	49898	36	6F
0005432681974	49898	37	7A
0005432681964	49898	38	6C
0005432681980	49898	39	6A
0005432681982	49898	40	4A
0005432711246	49898	41	5C
0005432681981	49898	42	5D
0005432711233	49898	43	4C
0005432711225	49898	44	4D
0005432681973	49898	45	4E
0005433442125	49898	46	16F
0005432681965	49898	47	16E
0005433442123	49898	48	3A
0005432711238	49898	49	2F
0005432711234	49898	50	3C
0005432681977	49898	51	3D
0005432681978	49898	52	17A
0005433442133	49898	53	18A
0005432681966	49898	54	17C
0005433442130	49898	55	20C
0005432711232	49898	56	18C
0005432681962	49898	57	20D
0005432711229	49898	58	2C
0005433442124	49898	59	20E
0005432711230	49898	60	1D
0005433442143	49898	61	20F
0005432070498	49898	62	1F
0005432711244	49898	63	1A
0005432681960	49898	64	20A
0005433442132	49898	65	19C
0005432711222	49898	66	19F
0005432711227	49898	67	19E
0005432681975	49898	68	18D
0005432681961	49898	69	18F
0005433442139	49898	70	19A
0005432681956	49898	71	18E
0005432681967	49898	72	17D
0005432711221	49898	73	17F
0005432711241	49898	74	15C
0005432711231	49898	75	14A
0005432711236	49898	76	15D
0005432711223	49898	77	15E
0005432070497	49898	78	15F
0005432711240	49898	79	16A
0005432681971	49898	80	16C
0005432681963	49898	81	14E
0005433442136	49898	82	15A
0005433442134	49898	83	14D
0005432711226	49898	84	14C
0005433720098	196866	1	2C
0005433720096	196866	2	5D
0005433720094	196866	3	12A
0005433720097	196866	4	13D
0005433720093	196866	5	18C
0005433720092	196866	6	17F
0005433720091	196866	7	5A
0005433720095	196866	8	5C
0005433521104	9078	1	20E
0005433521109	9078	2	9C
0005434577355	9078	3	9D
0005434577359	9078	4	20F
0005433723152	9078	5	5E
0005432269972	9078	6	9E
0005434512628	9078	7	9A
0005434577335	9078	8	10A
0005434577357	9078	9	1A
0005434577344	9078	10	5C
0005434577341	9078	11	2C
0005434577339	9078	12	10C
0005433521112	9078	13	11F
0005434577358	9078	14	11E
0005434577352	9078	15	3F
0005433723151	9078	16	13D
0005434577345	9078	17	12E
0005434577354	9078	18	4C
0005434577343	9078	19	13F
0005433521108	9078	20	13E
0005432269973	9078	21	13A
0005434577338	9078	22	13C
0005433521111	9078	23	5A
0005434577348	9078	24	12F
0005434577350	9078	25	1F
0005434577340	9078	26	3C
0005434577349	9078	27	2D
0005434577337	9078	28	10F
0005433521110	9078	29	2A
0005434577347	9078	30	19C
0005434577336	9078	31	15A
0005433723149	9078	32	17F
0005434512627	9078	33	18A
0005434577360	9078	34	19A
0005434512629	9078	35	15F
0005433521102	9078	36	16A
0005434577353	9078	37	16F
0005434577351	9078	38	17C
0005434577346	9078	39	14C
0005434577342	9078	40	14D
0005433723150	9078	41	14E
0005433521107	9078	42	5F
0005433521105	9078	43	7A
0005434577356	9078	44	6E
0005433521103	9078	45	7F
0005432269974	9078	46	7D
0005434514029	9078	47	8C
0005433521106	9078	48	8D
0005434577361	9078	49	7E
0005433188227	120141	1	18F
0005433188225	120141	2	16E
0005433188230	120141	3	10F
0005433188232	120141	4	17E
0005433188234	120141	5	16C
0005433188231	120141	6	11A
0005433188229	120141	7	11C
0005433188236	120141	8	13F
0005433188233	120141	9	8E
0005433188235	120141	10	9C
0005433188228	120141	11	9D
0005433188226	120141	12	6F
0005433188237	120141	13	3A
0005434141181	74426	1	3B
0005434141179	74426	2	3D
0005434141180	74426	3	21D
0005434141178	74426	4	22C
0005435304512	193285	1	3B
0005435304508	193285	2	18D
0005435302867	193285	3	2A
0005435302870	193285	4	20C
0005435302871	193285	5	18C
0005435304511	193285	6	7C
0005435304509	193285	7	5C
0005435302869	193285	8	3D
0005435302868	193285	9	21A
0005435304510	193285	10	22D
0005435814960	8422	1	16F
0005435814956	8422	2	16A
0005435814967	8422	3	18A
0005432283484	8422	4	17F
0005435814953	8422	5	21A
0005435814944	8422	6	17E
0005432283483	8422	7	20E
0005435814949	8422	8	18D
0005435814965	8422	9	20A
0005435814946	8422	10	19A
0005435814947	8422	11	15F
0005435814964	8422	12	15E
0005435814970	8422	13	14F
0005435814971	8422	14	13C
0005435814959	8422	15	7E
0005435814969	8422	16	7B
0005435814951	8422	17	6E
0005435814954	8422	18	3A
0005435814963	8422	19	6D
0005435814952	8422	20	4C
0005435814957	8422	21	6A
0005435814962	8422	22	6C
0005435814945	8422	23	10E
0005435814968	8422	24	13B
0005435814948	8422	25	11D
0005435814958	8422	26	9E
0005435814961	8422	27	9C
0005435814966	8422	28	11E
0005435814955	8422	29	10D
0005435814950	8422	30	10C
0005433409919	116702	1	3F
0005433409926	116702	2	4A
0005433409916	116702	3	8B
0005433409930	116702	4	9D
0005433409922	116702	5	9E
0005433409923	116702	6	10C
0005433409927	116702	7	11A
0005433409920	116702	8	11B
0005433409929	116702	9	13A
0005433409925	116702	10	14B
0005433409917	116702	11	15B
0005433409918	116702	12	15D
0005433409921	116702	13	15F
0005433409928	116702	14	17E
0005433409915	116702	15	18C
0005433409924	116702	16	21D
0005432764392	36486	1	20A
0005432764412	36486	2	20F
0005432764437	36486	3	20C
0005432764407	36486	4	20D
0005432764434	36486	5	2F
0005432764400	36486	6	5F
0005432142804	36486	7	6D
0005432764427	36486	8	6E
0005432764396	36486	9	8F
0005432764401	36486	10	13F
0005432764390	36486	11	13D
0005432764428	36486	12	18F
0005432764399	36486	13	14C
0005432764385	36486	14	19A
0005432764420	36486	15	19C
0005432764397	36486	16	19D
0005432764394	36486	17	19F
0005432764410	36486	18	14F
0005432764439	36486	19	15C
0005432764395	36486	20	18C
0005432764414	36486	21	15F
0005432764389	36486	22	18D
0005432764422	36486	23	16D
0005432764435	36486	24	17D
0005432142803	36486	25	17E
0005432764391	36486	26	16E
0005432764425	36486	27	17A
0005432764430	36486	28	16F
0005432764388	36486	29	15A
0005432764416	36486	30	14D
0005432764415	36486	31	13E
0005432764411	36486	32	9F
0005432764433	36486	33	10E
0005432764421	36486	34	12C
0005432764417	36486	35	12D
0005432764418	36486	36	11E
0005432764424	36486	37	11D
0005432764402	36486	38	11F
0005432764431	36486	39	10F
0005432764426	36486	40	11C
0005432764384	36486	41	10D
0005432764423	36486	42	10C
0005432764387	36486	43	6F
0005432764419	36486	44	7C
0005432764432	36486	45	7D
0005432764409	36486	46	7E
0005432764405	36486	47	7F
0005432764386	36486	48	3C
0005432764413	36486	49	5A
0005432764393	36486	50	5E
0005432142802	36486	51	3D
0005432764404	36486	52	4C
0005432764429	36486	53	4F
0005432764403	36486	54	4E
0005432764438	36486	55	4D
0005432764408	36486	56	3F
0005432764436	36486	57	1D
0005432764406	36486	58	2D
0005432764398	36486	59	1C
0005435474309	99670	1	1D
0005435474307	99670	2	6A
0005435474308	99670	3	13A
0005435474311	99670	4	17E
0005435474312	99670	5	7E
0005435474310	99670	6	10D
0005435474306	99670	7	8A
0005432843091	28321	1	18A
0005432843089	28321	2	23A
0005432843082	28321	3	18B
0005434462015	28321	4	19D
0005432843090	28321	5	20C
0005432843088	28321	6	21A
0005432843081	28321	7	20D
0005432843094	28321	8	22C
0005432843092	28321	9	5D
0005432843093	28321	10	7B
0005434462014	28321	11	6A
0005434463158	28321	12	1C
0005432843085	28321	13	4D
0005434463157	28321	14	2C
0005432843084	28321	15	2D
0005432843080	28321	16	4B
0005432843087	28321	17	3A
0005434463156	28321	18	4A
0005432843083	28321	19	2B
0005432843086	28321	20	2A
0005435847625	187342	1	1B
0005435847629	187342	2	1C
0005435847624	187342	3	2A
0005435847632	187342	4	3D
0005435847627	187342	5	6D
0005435847628	187342	6	7A
0005435847626	187342	7	18B
0005435847630	187342	8	19A
0005435847633	187342	9	21B
0005435847631	187342	10	22C
0005434914558	40749	1	20F
0005434437888	40749	2	17A
0005434437891	40749	3	20E
0005433485717	40749	4	16F
0005434914563	40749	5	20C
0005433485731	40749	6	16C
0005434914560	40749	7	9E
0005433485714	40749	8	18C
0005434914557	40749	9	17D
0005434914543	40749	10	16D
0005433485706	40749	11	18F
0005433485712	40749	12	19D
0005433485730	40749	13	19C
0005434914553	40749	14	19A
0005433485719	40749	15	18E
0005434914567	40749	16	19E
0005432073981	40749	17	17E
0005433485727	40749	18	20A
0005434437885	40749	19	7D
0005434914559	40749	20	15D
0005434914547	40749	21	17F
0005433485718	40749	22	17C
0005434914564	40749	23	15C
0005434914551	40749	24	18D
0005432073978	40749	25	16A
0005434437889	40749	26	16E
0005433485735	40749	27	8D
0005432073980	40749	28	9F
0005433485720	40749	29	4E
0005434914552	40749	30	15F
0005434914544	40749	31	9D
0005433485724	40749	32	10D
0005434914540	40749	33	2F
0005434914556	40749	34	11C
0005434437877	40749	35	4F
0005434437878	40749	36	7E
0005433485710	40749	37	15E
0005433485713	40749	38	8C
0005433485707	40749	39	8E
0005434437876	40749	40	9C
0005433485734	40749	41	8F
0005433485711	40749	42	5A
0005434914550	40749	43	5F
0005434914545	40749	44	7C
0005434914562	40749	45	7F
0005433485733	40749	46	7A
0005434914561	40749	47	6C
0005434437886	40749	48	6F
0005432073979	40749	49	6D
0005434437880	40749	50	5E
0005434914541	40749	51	5D
0005434437887	40749	52	3A
0005434914546	40749	53	12D
0005434437890	40749	54	2A
0005434914549	40749	55	4D
0005434914548	40749	56	1D
0005434914539	40749	57	4A
0005434914555	40749	58	3C
0005434437881	40749	59	2D
0005433485732	40749	60	3D
0005433485716	40749	61	11D
0005433485726	40749	62	2C
0005434437879	40749	63	13C
0005434437882	40749	64	12F
0005434437883	40749	65	1C
0005434914542	40749	66	1A
0005434437875	40749	67	13E
0005434914566	40749	68	11E
0005433485725	40749	69	12A
0005434914554	40749	70	11F
0005434914568	40749	71	14E
0005433485708	40749	72	13A
0005434437884	40749	73	15A
0005433485722	40749	74	13D
0005433485709	40749	75	12E
0005434914565	40749	76	14A
0005433485729	40749	77	14D
0005433485728	40749	78	14C
0005433485736	40749	79	12C
0005433485723	40749	80	10E
0005433485715	40749	81	11A
0005433485721	40749	82	10F
0005435233352	79076	1	20A
0005435233350	79076	2	19E
0005435233346	79076	3	17F
0005435233335	79076	4	16F
0005435233341	79076	5	15C
0005435233348	79076	6	11D
0005435233344	79076	7	8C
0005435233342	79076	8	18E
0005435233357	79076	9	19A
0005435233347	79076	10	18C
0005435233333	79076	11	19D
0005435233340	79076	12	19C
0005435233331	79076	13	12A
0005435233334	79076	14	9E
0005435233354	79076	15	13F
0005435233355	79076	16	12F
0005435233351	79076	17	8F
0005435233356	79076	18	13D
0005435233332	79076	19	9C
0005435233353	79076	20	10F
0005435233349	79076	21	4A
0005435233339	79076	22	7A
0005435233336	79076	23	1F
0005435233345	79076	24	3D
0005435233338	79076	25	2C
0005435233337	79076	26	6F
0005435233343	79076	27	2F
0005434844354	95074	1	1F
0005434844279	95074	2	1A
0005434844318	95074	3	5A
0005434844357	95074	4	4D
0005434844308	95074	5	6A
0005434844325	95074	6	6E
0005434844360	95074	7	6C
0005434844337	95074	8	7F
0005434844307	95074	9	8B
0005434844290	95074	10	16A
0005434844326	95074	11	6D
0005434844299	95074	12	15E
0005434844312	95074	13	14E
0005434844281	95074	14	9B
0005434844313	95074	15	5F
0005434758039	95074	16	13C
0005434844292	95074	17	14B
0005434844327	95074	18	13E
0005434844323	95074	19	14F
0005434844284	95074	20	13F
0005434844342	95074	21	16D
0005434844274	95074	22	15B
0005434844338	95074	23	15C
0005434844359	95074	24	15A
0005434844334	95074	25	15F
0005434844282	95074	26	17A
0005434844347	95074	27	15D
0005434844300	95074	28	16F
0005434844272	95074	29	12B
0005434844273	95074	30	10A
0005434844315	95074	31	16B
0005434844344	95074	32	18F
0005434844289	95074	33	8D
0005434844320	95074	34	14D
0005434844298	95074	35	8C
0005434844356	95074	36	9C
0005434844287	95074	37	12F
0005434844306	95074	38	13A
0005434844293	95074	39	12C
0005434844346	95074	40	10C
0005434844332	95074	41	12E
0005434844304	95074	42	13B
0005434844302	95074	43	12D
0005434844353	95074	44	13D
0005434844286	95074	45	5D
0005434844361	95074	46	11B
0005434844339	95074	47	12A
0005434844277	95074	48	4F
0005434844314	95074	49	11E
0005434844368	95074	50	11A
0005434844328	95074	51	11F
0005434844367	95074	52	10E
0005434844295	95074	53	10D
0005434844348	95074	54	5C
0005434844324	95074	55	9F
0005434844336	95074	56	11C
0005434844297	95074	57	9D
0005434844294	95074	58	9A
0005434844333	95074	59	9E
0005434844311	95074	60	8F
0005434844309	95074	61	8E
0005434844278	95074	62	7E
0005434844349	95074	63	8A
0005434844341	95074	64	6F
0005434844340	95074	65	17B
0005434844301	95074	66	7B
0005434844291	95074	67	7C
0005434844365	95074	68	7A
0005434844316	95074	69	2C
0005434844358	95074	70	3A
0005434844330	95074	71	2F
0005434844322	95074	72	3D
0005434844321	95074	73	3F
0005434844335	95074	74	4C
0005434844369	95074	75	2A
0005434844355	95074	76	4A
0005434844350	95074	77	3C
0005434844366	95074	78	19A
0005434844296	95074	79	1D
0005434844285	95074	80	21C
0005434844319	95074	81	1C
0005434844288	95074	82	2D
0005434844283	95074	83	21B
0005434844305	95074	84	20B
0005434844352	95074	85	19F
0005434844310	95074	86	19D
0005434844364	95074	87	20D
0005434844362	95074	88	21A
0005434758041	95074	89	21F
0005434844329	95074	90	20E
0005434844280	95074	91	20C
0005434844303	95074	92	21E
0005434844345	95074	93	17E
0005434758040	95074	94	20A
0005434844370	95074	95	17D
0005434844317	95074	96	19B
0005434844343	95074	97	19E
0005434844363	95074	98	18E
0005434844276	95074	99	18B
0005434844351	95074	100	17F
0005434844331	95074	101	18C
0005434844275	95074	102	18D
0005435656089	59925	1	20B
0005435656086	59925	2	19B
0005435656079	59925	3	2B
0005435656081	59925	4	4A
0005435656083	59925	5	19A
0005435656085	59925	6	23B
0005435656087	59925	7	22D
0005435656090	59925	8	21A
0005435656084	59925	9	7B
0005435656080	59925	10	18A
0005435656082	59925	11	18D
0005435656088	59925	12	5A
0005434248539	159713	1	5C
0005434248538	159713	2	5B
0005434248546	159713	3	4D
0005434248542	159713	4	18A
0005434248545	159713	5	2B
0005434248541	159713	6	7C
0005434248540	159713	7	20D
0005434248543	159713	8	3D
0005434248544	159713	9	7B
0005433663373	18225	1	12F
0005433663389	18225	2	16E
0005433663401	18225	3	17E
0005433663382	18225	4	16D
0005433663376	18225	5	14E
0005433663396	18225	6	18C
0005433663398	18225	7	18F
0005433663366	18225	8	19E
0005433663384	18225	9	12D
0005433663374	18225	10	20D
0005432220867	18225	11	12E
0005433663387	18225	12	11A
0005433663365	18225	13	11E
0005433663377	18225	14	20C
0005433663381	18225	15	17F
0005432220869	18225	16	19F
0005433663383	18225	17	20A
0005433663361	18225	18	14C
0005433663364	18225	19	13A
0005433663395	18225	20	19A
0005433663359	18225	21	13E
0005433663375	18225	22	13C
0005433663370	18225	23	16C
0005433663362	18225	24	14D
0005433663394	18225	25	13F
0005433663391	18225	26	15C
0005433663392	18225	27	6C
0005433663397	18225	28	10F
0005433663380	18225	29	10D
0005433663393	18225	30	10E
0005433663372	18225	31	10A
0005433663399	18225	32	6E
0005433663367	18225	33	2D
0005433663371	18225	34	3A
0005433663400	18225	35	8E
0005432220870	18225	36	9F
0005433663358	18225	37	9E
0005433663386	18225	38	5D
0005432220868	18225	39	6F
0005433663402	18225	40	7E
0005433663388	18225	41	9A
0005433663378	18225	42	8A
0005433663356	18225	43	9D
0005433663369	18225	44	9C
0005433663390	18225	45	8C
0005433663355	18225	46	5F
0005433663360	18225	47	5A
0005432220871	18225	48	5C
0005433663385	18225	49	2C
0005433663368	18225	50	4E
0005433663357	18225	51	6A
0005433663379	18225	52	4A
0005433663354	18225	53	3F
0005433663363	18225	54	2A
0005433663353	18225	55	1A
0005432957753	189048	1	4A
0005432957742	189048	2	3A
0005432957738	189048	3	2A
0005432004191	189048	4	7F
0005432957750	189048	5	10E
0005432957743	189048	6	12A
0005432957730	189048	7	11E
0005432957740	189048	8	12D
0005432957746	189048	9	4C
0005432004192	189048	10	5D
0005432957747	189048	11	10D
0005432957748	189048	12	14A
0005432957751	189048	13	12E
0005432957734	189048	14	20C
0005432957741	189048	15	17D
0005432957736	189048	16	14F
0005432957752	189048	17	6C
0005432957729	189048	18	9C
0005432004190	189048	19	6D
0005432957731	189048	20	19C
0005432957735	189048	21	15D
0005432957744	189048	22	18A
0005432957732	189048	23	17A
0005432957755	189048	24	19A
0005432957745	189048	25	16E
0005432957754	189048	26	18D
0005432957733	189048	27	16F
0005432957749	189048	28	1D
0005432957737	189048	29	1A
0005432957739	189048	30	18F
0005433572889	60331	1	23B
0005432753868	60331	2	20C
0005433572880	60331	3	17D
0005433572878	60331	4	23F
0005432753866	60331	5	22A
0005433572887	60331	6	30D
0005433572884	60331	7	23E
0005433572891	60331	8	30A
0005433572890	60331	9	8E
0005432753867	60331	10	3F
0005432755639	60331	11	15D
0005433572888	60331	12	15F
0005433572882	60331	13	17A
0005433572881	60331	14	25F
0005433572879	60331	15	6C
0005433572883	60331	16	11A
0005432755640	60331	17	12F
0005433572886	60331	18	15A
0005433572892	60331	19	5F
0005433572885	60331	20	9C
0005434160328	163542	1	9F
0005434160332	163542	2	29F
0005434160331	163542	3	16C
0005434160336	163542	4	2C
0005434160334	163542	5	25D
0005434160333	163542	6	11A
0005434160335	163542	7	18C
0005434160326	163542	8	15F
0005434160329	163542	9	11F
0005434160327	163542	10	4A
0005434160330	163542	11	2F
0005435984664	27332	1	22G
0005435984670	27332	2	19F
0005435984669	27332	3	16H
0005435984668	27332	4	38E
0005435984666	27332	5	35F
0005432183925	27332	6	33B
0005435984667	27332	7	11G
0005432183923	27332	8	3B
0005435984665	27332	9	5C
0005432183924	27332	10	16F
0005435854684	172574	1	24F
0005435942003	172574	2	27B
0005435941996	172574	3	19H
0005435942010	172574	4	24E
0005435942009	172574	5	19A
0005432569959	172574	6	20D
0005435854681	172574	7	16H
0005435942004	172574	8	22A
0005435854682	172574	9	37B
0005435786635	172574	10	32G
0005435942002	172574	11	16G
0005435941997	172574	12	21F
0005435941998	172574	13	37E
0005435854683	172574	14	1C
0005435942006	172574	15	4B
0005435942000	172574	16	5C
0005435942008	172574	17	14B
0005435942007	172574	18	11B
0005435942005	172574	19	37H
0005432569958	172574	20	28B
0005435941999	172574	21	23G
0005435854680	172574	22	24B
0005435942001	172574	23	38E
0005433547608	2368	1	21B
0005433547585	2368	2	20F
0005433547605	2368	3	8F
0005433547568	2368	4	8C
0005433547589	2368	5	7F
0005432236716	2368	6	5F
0005433547609	2368	7	5A
0005433547603	2368	8	3A
0005433547594	2368	9	1F
0005433547584	2368	10	6D
0005433547569	2368	11	4D
0005433547590	2368	12	4A
0005433547578	2368	13	6F
0005433547610	2368	14	8A
0005432236717	2368	15	7D
0005433547574	2368	16	20B
0005433547597	2368	17	11B
0005433547593	2368	18	11A
0005433547563	2368	19	9C
0005433547582	2368	20	10C
0005433547618	2368	21	9F
0005432236721	2368	22	9E
0005433547581	2368	23	12C
0005433547595	2368	24	12A
0005433547562	2368	25	14A
0005433547596	2368	26	15A
0005433547607	2368	27	17A
0005433547614	2368	28	15F
0005433547571	2368	29	15E
0005433547579	2368	30	15B
0005433547612	2368	31	16F
0005433547576	2368	32	31E
0005433547601	2368	33	16E
0005433547572	2368	34	28C
0005433547616	2368	35	16B
0005433547599	2368	36	17C
0005433547604	2368	37	17B
0005433547570	2368	38	18C
0005433547592	2368	39	18F
0005433547588	2368	40	19D
0005433547606	2368	41	29B
0005433547602	2368	42	28E
0005433547620	2368	43	23A
0005433547564	2368	44	22E
0005433547586	2368	45	21F
0005433547598	2368	46	21D
0005433547619	2368	47	23C
0005433547600	2368	48	23B
0005433547587	2368	49	25D
0005433547591	2368	50	24F
0005433547613	2368	51	23E
0005433547583	2368	52	24D
0005433547567	2368	53	23F
0005433547573	2368	54	27B
0005433547577	2368	55	26C
0005433547566	2368	56	26A
0005432236720	2368	57	27F
0005432236719	2368	58	30C
0005433547615	2368	59	30B
0005432236718	2368	60	30E
0005433547575	2368	61	30D
0005433547580	2368	62	1C
0005433547611	2368	63	29C
0005433547565	2368	64	31D
0005433547617	2368	65	31B
0005433132483	75358	1	5F
0005433064454	75358	2	5A
0005433064457	75358	3	4C
0005433064439	75358	4	3D
0005433064455	75358	5	4D
0005432191180	75358	6	3C
0005433064429	75358	7	2D
0005433130054	75358	8	1F
0005433064447	75358	9	1C
0005433130053	75358	10	31A
0005433064446	75358	11	29D
0005433064452	75358	12	9C
0005432191183	75358	13	8F
0005433064459	75358	14	6A
0005433064440	75358	15	8A
0005433064442	75358	16	7D
0005433064438	75358	17	6C
0005433130051	75358	18	7C
0005433064432	75358	19	7A
0005433064450	75358	20	15A
0005433064435	75358	21	10C
0005433064434	75358	22	21C
0005433132482	75358	23	10E
0005433064441	75358	24	14E
0005433064430	75358	25	13F
0005432191179	75358	26	11E
0005433132480	75358	27	16D
0005433064448	75358	28	21A
0005433064443	75358	29	15D
0005433064431	75358	30	15C
0005433130050	75358	31	20C
0005432191181	75358	32	17F
0005433064433	75358	33	19C
0005432191182	75358	34	18D
0005433064453	75358	35	25B
0005433130052	75358	36	22C
0005433064444	75358	37	21F
0005433064458	75358	38	24C
0005433064445	75358	39	23A
0005432191178	75358	40	24B
0005433064436	75358	41	23B
0005433064437	75358	42	29B
0005433064456	75358	43	28B
0005433132481	75358	44	25D
0005433064449	75358	45	29E
0005433064451	75358	46	31B
0005433816111	65234	1	6A
0005433816110	65234	2	5B
0005433816109	65234	3	4A
0005433816112	65234	4	4B
0005434731758	90888	1	1A
0005434731756	90888	2	6A
0005434731759	90888	3	5A
0005434731757	90888	4	3A
0005435966365	15093	1	22G
0005435966377	15093	2	19D
0005433733950	15093	3	3H
0005433733959	15093	4	4C
0005435966361	15093	5	4A
0005433765267	15093	6	4G
0005433733947	15093	7	3B
0005435966393	15093	8	2G
0005435966350	15093	9	1C
0005433733978	15093	10	1F
0005433763925	15093	11	1H
0005433733964	15093	12	2A
0005433733962	15093	13	5G
0005435966352	15093	14	11F
0005435966390	15093	15	2H
0005435966356	15093	16	4F
0005433765266	15093	17	2C
0005433733971	15093	18	3C
0005432223807	15093	19	3F
0005432651234	15093	20	4B
0005432298161	15093	21	22E
0005432651231	15093	22	17E
0005433733967	15093	23	17A
0005433733984	15093	24	23A
0005433733980	15093	25	24A
0005435966382	15093	26	13B
0005433733987	15093	27	24D
0005433733960	15093	28	3G
0005435966373	15093	29	9B
0005435966389	15093	30	9G
0005435966357	15093	31	5F
0005433733988	15093	32	24B
0005433733997	15093	33	11D
0005433733998	15093	34	9H
0005435966372	15093	35	13A
0005432651237	15093	36	12B
0005433733961	15093	37	13E
0005433733944	15093	38	11G
0005435966368	15093	39	11H
0005432223806	15093	40	37A
0005435966384	15093	41	12G
0005433733966	15093	42	12D
0005433733969	15093	43	12E
0005433733970	15093	44	14B
0005433733972	15093	45	23B
0005432298163	15093	46	23E
0005435966354	15093	47	22H
0005433733985	15093	48	14E
0005433733973	15093	49	15D
0005435966359	15093	50	15A
0005433733986	15093	51	13H
0005432298164	15093	52	14H
0005433733981	15093	53	14F
0005435966362	15093	54	13F
0005432223808	15093	55	16D
0005435966364	15093	56	23G
0005433733979	15093	57	15G
0005435966385	15093	58	18D
0005433733992	15093	59	15H
0005435966358	15093	60	18B
0005433733951	15093	61	16B
0005433733989	15093	62	16H
0005432223804	15093	63	16E
0005435966383	15093	64	16G
0005433733957	15093	65	18A
0005433733968	15093	66	17D
0005433733965	15093	67	29F
0005435966370	15093	68	29E
0005435966381	15093	69	30E
0005433733982	15093	70	29A
0005435966375	15093	71	29B
0005433733994	15093	72	30G
0005432651232	15093	73	33D
0005433733956	15093	74	21B
0005435966351	15093	75	18G
0005432298162	15093	76	18E
0005433765265	15093	77	19B
0005433733945	15093	78	27E
0005432223805	15093	79	20A
0005433733977	15093	80	22D
0005432651233	15093	81	21E
0005433733946	15093	82	18F
0005435966371	15093	83	20H
0005433733943	15093	84	19H
0005432651239	15093	85	21F
0005435966369	15093	86	19F
0005433733976	15093	87	28D
0005435966386	15093	88	36H
0005435966366	15093	89	24F
0005433733949	15093	90	35E
0005432651238	15093	91	36D
0005435966374	15093	92	24H
0005435966379	15093	93	36F
0005435966392	15093	94	35F
0005435966391	15093	95	28F
0005433733953	15093	96	28H
0005435966367	15093	97	27A
0005432651230	15093	98	35D
0005433733990	15093	99	28E
0005432298160	15093	100	25F
0005435966378	15093	101	25D
0005435966380	15093	102	25E
0005433765264	15093	103	39E
0005433733991	15093	104	33E
0005435966349	15093	105	30B
0005433733952	15093	106	39F
0005432651235	15093	107	30D
0005433733963	15093	108	36E
0005433733983	15093	109	32A
0005433733975	15093	110	31D
0005433733993	15093	111	33B
0005435966387	15093	112	31F
0005435966355	15093	113	31B
0005433733995	15093	114	33A
0005435966360	15093	115	30H
0005435966388	15093	116	34H
0005432223809	15093	117	35A
0005433733954	15093	118	33H
0005433733974	15093	119	31G
0005433733958	15093	120	33F
0005433733996	15093	121	34E
0005435966363	15093	122	34D
0005433733955	15093	123	34G
0005433733942	15093	124	38A
0005435966353	15093	125	37G
0005433763926	15093	126	37F
0005435966376	15093	127	37D
0005432651236	15093	128	37H
0005433733948	15093	129	38B
0005432298165	15093	130	38F
0005432973403	169928	1	32D
0005432973392	169928	2	38E
0005433424559	169928	3	35G
0005433424556	169928	4	34E
0005432973414	169928	5	23F
0005433424538	169928	6	19E
0005433424554	169928	7	15D
0005432050002	169928	8	30A
0005434729649	169928	9	14H
0005433424547	169928	10	14G
0005432973411	169928	11	16H
0005432973415	169928	12	18H
0005432973398	169928	13	17E
0005432973419	169928	14	15E
0005432973409	169928	15	20D
0005432973418	169928	16	16D
0005432973407	169928	17	28F
0005433424548	169928	18	16G
0005433424560	169928	19	29A
0005432973406	169928	20	29H
0005432973400	169928	21	16A
0005432973394	169928	22	19A
0005433424563	169928	23	17D
0005432973423	169928	24	20E
0005434729648	169928	25	25D
0005432973390	169928	26	21H
0005432048165	169928	27	28H
0005432973404	169928	28	23H
0005433424557	169928	29	28E
0005432973405	169928	30	21A
0005432973412	169928	31	22E
0005433424555	169928	32	22H
0005432973420	169928	33	37G
0005432973399	169928	34	37F
0005432973395	169928	35	11D
0005432973401	169928	36	11G
0005432973422	169928	37	34D
0005432973393	169928	38	32E
0005432973421	169928	39	30H
0005432973408	169928	40	31E
0005433424541	169928	41	32B
0005433424549	169928	42	30E
0005432048168	169928	43	31G
0005434729647	169928	44	2F
0005432050003	169928	45	39F
0005433424545	169928	46	11B
0005433424552	169928	47	34G
0005433424540	169928	48	34A
0005433424537	169928	49	32H
0005432973391	169928	50	34H
0005432048167	169928	51	33B
0005433424553	169928	52	14E
0005433424539	169928	53	2H
0005433424550	169928	54	5B
0005432973396	169928	55	14F
0005433424544	169928	56	1C
0005432048166	169928	57	9H
0005433424561	169928	58	1H
0005432050001	169928	59	2G
0005432973416	169928	60	2A
0005433424562	169928	61	12E
0005432973410	169928	62	2B
0005434729646	169928	63	9B
0005433424565	169928	64	5A
0005433424543	169928	65	3C
0005434729645	169928	66	3B
0005432973413	169928	67	4B
0005433424551	169928	68	12F
0005433424542	169928	69	5C
0005432973397	169928	70	5G
0005433424546	169928	71	9G
0005433424564	169928	72	13H
0005432973417	169928	73	12H
0005433424558	169928	74	12G
0005432973402	169928	75	13F
0005434358510	9901	1	7A
0005434358523	9901	2	7B
0005434358543	9901	3	18D
0005434358545	9901	4	12E
0005434358525	9901	5	14C
0005433459651	9901	6	12B
0005434358531	9901	7	13E
0005434358549	9901	8	19E
0005434358542	9901	9	12C
0005434358530	9901	10	12D
0005434358533	9901	11	14D
0005434358540	9901	12	14A
0005434358527	9901	13	13F
0005434358551	9901	14	18F
0005434358555	9901	15	18C
0005434358552	9901	16	17C
0005434358505	9901	17	1A
0005434358532	9901	18	4B
0005434358515	9901	19	4E
0005432265478	9901	20	6A
0005434358548	9901	21	6D
0005434358518	9901	22	6E
0005432265477	9901	23	6F
0005434358500	9901	24	16B
0005434358503	9901	25	23A
0005434358513	9901	26	22C
0005434358550	9901	27	3D
0005434358544	9901	28	22E
0005433460803	9901	29	23E
0005434358528	9901	30	23C
0005434358506	9901	31	2D
0005434358502	9901	32	22F
0005434358547	9901	33	22A
0005434358516	9901	34	20F
0005434358558	9901	35	20D
0005434358517	9901	36	21E
0005434358537	9901	37	22B
0005434358556	9901	38	21F
0005433460802	9901	39	21C
0005434358538	9901	40	1C
0005434358526	9901	41	2A
0005434358536	9901	42	2F
0005434358554	9901	43	5D
0005434358499	9901	44	5E
0005432265476	9901	45	5B
0005434358507	9901	46	10C
0005434358553	9901	47	5C
0005434358535	9901	48	4C
0005434358520	9901	49	8C
0005434358534	9901	50	7E
0005432265481	9901	51	10E
0005434358557	9901	52	8B
0005434358546	9901	53	10D
0005434358541	9901	54	8F
0005434358539	9901	55	7F
0005432265482	9901	56	9B
0005434358514	9901	57	7C
0005432265479	9901	58	11F
0005434358512	9901	59	14E
0005434358501	9901	60	16C
0005434358504	9901	61	11C
0005434358522	9901	62	17D
0005434358519	9901	63	16E
0005434358524	9901	64	17A
0005434358509	9901	65	18B
0005432265480	9901	66	17E
0005434358508	9901	67	18A
0005434358559	9901	68	19C
0005434358511	9901	69	19A
0005434358521	9901	70	19B
0005434358529	9901	71	12A
0005433763926	130491	1	21D
0005433139042	130491	2	19F
0005433139049	130491	3	19E
0005433139041	130491	4	16C
0005434028750	130491	5	18B
0005433139046	130491	6	14D
0005433139021	130491	7	3C
0005433139020	130491	8	17B
0005432054925	130491	9	12E
0005433139019	130491	10	14E
0005433139033	130491	11	17A
0005433139030	130491	12	15A
0005433139016	130491	13	13F
0005433139029	130491	14	13D
0005433139022	130491	15	14F
0005432054922	130491	16	16E
0005433139037	130491	17	16A
0005433139048	130491	18	18A
0005433139018	130491	19	20A
0005433763925	130491	20	2C
0005433139031	130491	21	4C
0005433139026	130491	22	6C
0005433139023	130491	23	22E
0005433139028	130491	24	22C
0005433139025	130491	25	23D
0005433139038	130491	26	1F
0005433139014	130491	27	20D
0005433139040	130491	28	21C
0005433139045	130491	29	6D
0005433139015	130491	30	23E
0005433139027	130491	31	11D
0005433930363	130491	32	12C
0005433139032	130491	33	12D
0005432054924	130491	34	6F
0005433139043	130491	35	3D
0005433139044	130491	36	9F
0005433139039	130491	37	8F
0005433139024	130491	38	10B
0005433139034	130491	39	9E
0005433139036	130491	40	10E
0005432054923	130491	41	8C
0005433139047	130491	42	7B
0005433139017	130491	43	8D
0005433139035	130491	44	12A
0005432407064	3344	1	21A
0005432407113	3344	2	18F
0005432280320	3344	3	2F
0005432407066	3344	4	19B
0005432407099	3344	5	11B
0005432407058	3344	6	7C
0005432407093	3344	7	28A
0005432407055	3344	8	2A
0005432407107	3344	9	28B
0005432407110	3344	10	14F
0005432407092	3344	11	28F
0005432407085	3344	12	25C
0005432407089	3344	13	25A
0005432407086	3344	14	30B
0005432407117	3344	15	26A
0005432407063	3344	16	24E
0005432407082	3344	17	29E
0005432407061	3344	18	29A
0005432407078	3344	19	25B
0005432407103	3344	20	29D
0005432407067	3344	21	26B
0005432407116	3344	22	26F
0005432407102	3344	23	26C
0005432407070	3344	24	12C
0005432407115	3344	25	31B
0005432407096	3344	26	27C
0005432407072	3344	27	27E
0005432407068	3344	28	8D
0005432280317	3344	29	14E
0005432407057	3344	30	21B
0005432407097	3344	31	22A
0005432407075	3344	32	20C
0005432407087	3344	33	4C
0005432407071	3344	34	4A
0005432407069	3344	35	3A
0005432280316	3344	36	4F
0005432407073	3344	37	15F
0005432407083	3344	38	3F
0005432407105	3344	39	13E
0005432407077	3344	40	14A
0005432407109	3344	41	12D
0005432280318	3344	42	14B
0005432280319	3344	43	15E
0005432407098	3344	44	13C
0005432407079	3344	45	13D
0005432407104	3344	46	16E
0005432407056	3344	47	13B
0005432407094	3344	48	12F
0005432407062	3344	49	16F
0005432407095	3344	50	24C
0005432407065	3344	51	16B
0005432407108	3344	52	17A
0005432407091	3344	53	18D
0005432407074	3344	54	18C
0005432407106	3344	55	22C
0005432407081	3344	56	23F
0005432407101	3344	57	24A
0005432407112	3344	58	18E
0005432407088	3344	59	22F
0005432407059	3344	60	22B
0005432407111	3344	61	27A
0005432407060	3344	62	8B
0005432407100	3344	63	8C
0005432407090	3344	64	6A
0005432280321	3344	65	6F
0005432407084	3344	66	9E
0005432407080	3344	67	9F
0005432407114	3344	68	10C
0005432407076	3344	69	8F
0005432280322	3344	70	14D
0005432300969	83758	1	23F
0005432300970	83758	2	20C
0005432300971	83758	3	24E
0005432300972	83758	4	27D
0005433999313	2895	1	31G
0005433999293	2895	2	31D
0005433999297	2895	3	33B
0005433999287	2895	4	1F
0005433999331	2895	5	1C
0005433999330	2895	6	33E
0005433999299	2895	7	33D
0005433999334	2895	8	34A
0005433999284	2895	9	21D
0005433999283	2895	10	1H
0005433999300	2895	11	33H
0005433999270	2895	12	15F
0005433999319	2895	13	30A
0005433999327	2895	14	30G
0005433999276	2895	15	33A
0005433999294	2895	16	32A
0005433999307	2895	17	31B
0005432232928	2895	18	32G
0005432232927	2895	19	32B
0005433999298	2895	20	16H
0005433999325	2895	21	17G
0005433999301	2895	22	20B
0005433999291	2895	23	14E
0005433999311	2895	24	13H
0005433999336	2895	25	23A
0005433999288	2895	26	29H
0005433999315	2895	27	28D
0005433999308	2895	28	28B
0005432232923	2895	29	21G
0005432232926	2895	30	22A
0005433999310	2895	31	25F
0005433999321	2895	32	29F
0005433999339	2895	33	27G
0005433999332	2895	34	27E
0005433999273	2895	35	27D
0005433999280	2895	36	24G
0005433999322	2895	37	23H
0005433999316	2895	38	20F
0005433999275	2895	39	17E
0005433999303	2895	40	20D
0005432232925	2895	41	19B
0005433999309	2895	42	17A
0005433999306	2895	43	18E
0005433999333	2895	44	2C
0005433999312	2895	45	14B
0005433999329	2895	46	34F
0005433999295	2895	47	12H
0005433999272	2895	48	2F
0005433999286	2895	49	12D
0005433999314	2895	50	16G
0005433999323	2895	51	13E
0005433999337	2895	52	12A
0005433999285	2895	53	13G
0005433999292	2895	54	11A
0005433999317	2895	55	13D
0005432232924	2895	56	38D
0005433999326	2895	57	37F
0005432232929	2895	58	5C
0005433999338	2895	59	2G
0005433999328	2895	60	9G
0005433999320	2895	61	13A
0005433999289	2895	62	5H
0005433999324	2895	63	4G
0005433999282	2895	64	37H
0005433999274	2895	65	3C
0005433999305	2895	66	39F
0005433999281	2895	67	39D
0005433999335	2895	68	34D
0005433999304	2895	69	36G
0005433999318	2895	70	4H
0005433999277	2895	71	37G
0005433999296	2895	72	35B
0005433999290	2895	73	37B
0005433999302	2895	74	38G
0005433999271	2895	75	37D
0005433999279	2895	76	34H
0005433999278	2895	77	35E
0005433043417	82236	1	14A
0005433043411	82236	2	28E
0005433043438	82236	3	15A
0005433043432	82236	4	38E
0005433043406	82236	5	38D
0005433043418	82236	6	21A
0005432154757	82236	7	35F
0005433043436	82236	8	35B
0005434733809	82236	9	17E
0005433043426	82236	10	4B
0005432154760	82236	11	38G
0005433043444	82236	12	5A
0005433043409	82236	13	37G
0005432156772	82236	14	9A
0005433043410	82236	15	36B
0005433043425	82236	16	36D
0005433043419	82236	17	34H
0005433043428	82236	18	34G
0005433043437	82236	19	31A
0005433043413	82236	20	27A
0005433043407	82236	21	17G
0005433043414	82236	22	25F
0005433043423	82236	23	36G
0005433043443	82236	24	27B
0005433043434	82236	25	32F
0005433043435	82236	26	33F
0005433043430	82236	27	18F
0005433043415	82236	28	3G
0005433928116	82236	29	11G
0005433043439	82236	30	24F
0005434733806	82236	31	32D
0005434733805	82236	32	31E
0005433043433	82236	33	29E
0005434733807	82236	34	28D
0005433043424	82236	35	28B
0005433043405	82236	36	18E
0005434733810	82236	37	19E
0005432154758	82236	38	22D
0005433043429	82236	39	20G
0005433043422	82236	40	22E
0005433043427	82236	41	18H
0005433683702	82236	42	2C
0005432154761	82236	43	2G
0005433043445	82236	44	1A
0005433928117	82236	45	23H
0005433043412	82236	46	22G
0005433043420	82236	47	13H
0005433043416	82236	48	15B
0005433043408	82236	49	13G
0005433043431	82236	50	12H
0005433683701	82236	51	17B
0005433043442	82236	52	15H
0005433043440	82236	53	16D
0005433928118	82236	54	15G
0005433928115	82236	55	13D
0005433043421	82236	56	16B
0005433043441	82236	57	12F
0005434733808	82236	58	14D
0005432154759	82236	59	13A
0005433888764	13805	1	11E
0005433888697	13805	2	32F
0005433888699	13805	3	36A
0005433888767	13805	4	35D
0005433888788	13805	5	38E
0005433888768	13805	6	36F
0005433928116	13805	7	35B
0005432043521	13805	8	38A
0005433888750	13805	9	36G
0005432227726	13805	10	36H
0005432227719	13805	11	39D
0005433888783	13805	12	37H
0005433928118	13805	13	36D
0005433888762	13805	14	37D
0005433888739	13805	15	38F
0005433888743	13805	16	35A
0005433888747	13805	17	37E
0005433888717	13805	18	36E
0005433888698	13805	19	37G
0005433888710	13805	20	33B
0005433888733	13805	21	33A
0005433888692	13805	22	28B
0005433888716	13805	23	34D
0005433888769	13805	24	28D
0005433888721	13805	25	33H
0005432227722	13805	26	34F
0005433888728	13805	27	34E
0005433888720	13805	28	33D
0005433888776	13805	29	33E
0005433888770	13805	30	33F
0005432227727	13805	31	9H
0005433888702	13805	32	12H
0005433888734	13805	33	20B
0005433888712	13805	34	19G
0005433888730	13805	35	3B
0005433888691	13805	36	32B
0005432227723	13805	37	23G
0005432227720	13805	38	32G
0005433888754	13805	39	30B
0005433888729	13805	40	31H
0005433888693	13805	41	32E
0005432227724	13805	42	29D
0005433888746	13805	43	30G
0005433888775	13805	44	30E
0005433888700	13805	45	32D
0005433888777	13805	46	32A
0005433888773	13805	47	29G
0005433888715	13805	48	29F
0005433888765	13805	49	31F
0005433888724	13805	50	31B
0005433888760	13805	51	27F
0005433888725	13805	52	24D
0005432043523	13805	53	30D
0005432043522	13805	54	25F
0005433928115	13805	55	2B
0005433888780	13805	56	27E
0005433888696	13805	57	27G
0005433888766	13805	58	27D
0005433888778	13805	59	23B
0005433888727	13805	60	24F
0005433888701	13805	61	5A
0005433888704	13805	62	2G
0005433888713	13805	63	23E
0005433888758	13805	64	18D
0005433888772	13805	65	25E
0005433888745	13805	66	24H
0005433888756	13805	67	3H
0005433888722	13805	68	3C
0005433888735	13805	69	4A
0005433888759	13805	70	4G
0005433888740	13805	71	4C
0005433888761	13805	72	3F
0005433930363	13805	73	1C
0005433888718	13805	74	24A
0005433888738	13805	75	23H
0005433888723	13805	76	21E
0005433888736	13805	77	18E
0005433888695	13805	78	3G
0005433888709	13805	79	1H
0005433888782	13805	80	22H
0005433888742	13805	81	21A
0005433888706	13805	82	23A
0005433888719	13805	83	1B
0005433888763	13805	84	21F
0005432227721	13805	85	22A
0005433888708	13805	86	21G
0005433888732	13805	87	22F
0005433888703	13805	88	21D
0005433888781	13805	89	21B
0005433888741	13805	90	18G
0005433888774	13805	91	19E
0005433888771	13805	92	18A
0005433888726	13805	93	20D
0005433888755	13805	94	12G
0005433888779	13805	95	15E
0005433888751	13805	96	16H
0005433888753	13805	97	14B
0005433888786	13805	98	17B
0005433888707	13805	99	17G
0005433888694	13805	100	16B
0005433888705	13805	101	13H
0005433888784	13805	102	16G
0005433928117	13805	103	13G
0005433888737	13805	104	13F
0005433888787	13805	105	15A
0005433888757	13805	106	14H
0005432227725	13805	107	15B
0005433888749	13805	108	14E
0005433888731	13805	109	16A
0005433888748	13805	110	15F
0005433888785	13805	111	11A
0005433888752	13805	112	12E
0005432227728	13805	113	12F
0005433888714	13805	114	13A
0005433888711	13805	115	11B
0005432227729	13805	116	12D
0005433888744	13805	117	11G
0005433017310	156346	1	29A
0005433017282	156346	2	28F
0005433017272	156346	3	29F
0005433017318	156346	4	39D
0005433017304	156346	5	1G
0005433017295	156346	6	15D
0005433017285	156346	7	2A
0005433017286	156346	8	15G
0005433017321	156346	9	4F
0005433017305	156346	10	15B
0005434027222	156346	11	3A
0005432206723	156346	12	5F
0005433017276	156346	13	21D
0005433017307	156346	14	5A
0005433017273	156346	15	11A
0005432204082	156346	16	5B
0005432206725	156346	17	11D
0005433017284	156346	18	2C
0005433017316	156346	19	14D
0005433017279	156346	20	13D
0005432204081	156346	21	14G
0005433017312	156346	22	13H
0005433017311	156346	23	12B
0005433017322	156346	24	13F
0005432748991	156346	25	13G
0005433017281	156346	26	15H
0005433017294	156346	27	27F
0005434027221	156346	28	11E
0005433017288	156346	29	16E
0005433017275	156346	30	16F
0005433017299	156346	31	27A
0005433017292	156346	32	16D
0005433017297	156346	33	16G
0005433017315	156346	34	27D
0005433017323	156346	35	17B
0005433017309	156346	36	18D
0005433017283	156346	37	27G
0005433017296	156346	38	21A
0005433017293	156346	39	19B
0005433017303	156346	40	20A
0005433017291	156346	41	20E
0005432748990	156346	42	24B
0005433017324	156346	43	23D
0005432206724	156346	44	24E
0005433017302	156346	45	17H
0005432204083	156346	46	23H
0005434027224	156346	47	22D
0005433017308	156346	48	23A
0005433017278	156346	49	22B
0005433017301	156346	50	28B
0005433017289	156346	51	28H
0005433017325	156346	52	38G
0005434027223	156346	53	31G
0005433017313	156346	54	35F
0005433017290	156346	55	30A
0005433017320	156346	56	34B
0005432748992	156346	57	36B
0005433017317	156346	58	36E
0005433017274	156346	59	37F
0005433017298	156346	60	29D
0005433017314	156346	61	38F
0005433017280	156346	62	33D
0005432204085	156346	63	31F
0005433017300	156346	64	31D
0005433017319	156346	65	32G
0005433017287	156346	66	37E
0005432204086	156346	67	35A
0005433017277	156346	68	35D
0005432204084	156346	69	36A
0005433017306	156346	70	36F
0005434531463	1927	1	24E
0005434681774	1927	2	42B
0005434681823	1927	3	41G
0005434681777	1927	4	37K
0005435137697	1927	5	40J
0005434681768	1927	6	41F
0005435137692	1927	7	47E
0005434531477	1927	8	49F
0005434681891	1927	9	49K
0005434681805	1927	10	49D
0005434531460	1927	11	49H
0005434531441	1927	12	50F
0005434681880	1927	13	1A
0005434681873	1927	14	50A
0005434681816	1927	15	15D
0005434531471	1927	16	23J
0005434681820	1927	17	23C
0005434681846	1927	18	22C
0005434681861	1927	19	50H
0005434681887	1927	20	50C
0005434681785	1927	21	1C
0005432272965	1927	22	25G
0005434681804	1927	23	49C
0005434681799	1927	24	49A
0005434531451	1927	25	51G
0005434681890	1927	26	51D
0005434531431	1927	27	48A
0005434681810	1927	28	48K
0005435137690	1927	29	48D
0005434681863	1927	30	25D
0005434681791	1927	31	42A
0005434531435	1927	32	23G
0005435137686	1927	33	41H
0005432272961	1927	34	23E
0005434531459	1927	35	23F
0005434531466	1927	36	16K
0005434681801	1927	37	23D
0005432272963	1927	38	25C
0005432272957	1927	39	42H
0005434681867	1927	40	39K
0005434681840	1927	41	46B
0005434531461	1927	42	45K
0005434531480	1927	43	46C
0005434681789	1927	44	47D
0005434531432	1927	45	24F
0005434531464	1927	46	42D
0005434681881	1927	47	45J
0005434531433	1927	48	40B
0005434681831	1927	49	45G
0005435137693	1927	50	47C
0005434681786	1927	51	47F
0005432272962	1927	52	47K
0005434531446	1927	53	47G
0005432272964	1927	54	32G
0005432272966	1927	55	46J
0005434681884	1927	56	45D
0005434531440	1927	57	45C
0005434531444	1927	58	45E
0005434681826	1927	59	33F
0005434531472	1927	60	43E
0005434681858	1927	61	43B
0005434681855	1927	62	43K
0005434681854	1927	63	42J
0005434681872	1927	64	45B
0005435137696	1927	65	44B
0005434531467	1927	66	42K
0005434681850	1927	67	43G
0005434531482	1927	68	43H
0005434531437	1927	69	44C
0005435137689	1927	70	44F
0005434681862	1927	71	44E
0005434681843	1927	72	44A
0005434681889	1927	73	42F
0005434681813	1927	74	43A
0005434531476	1927	75	37A
0005434531462	1927	76	38J
0005434681824	1927	77	38C
0005434681878	1927	78	37B
0005434681842	1927	79	38B
0005435137691	1927	80	39A
0005434681778	1927	81	37J
0005434681849	1927	82	40G
0005435137688	1927	83	40E
0005434531483	1927	84	41E
0005434531439	1927	85	40D
0005434681871	1927	86	36G
0005434681822	1927	87	40H
0005434531450	1927	88	39G
0005434681866	1927	89	32J
0005434531481	1927	90	39J
0005434531454	1927	91	39H
0005434531486	1927	92	32K
0005434300888	1927	93	39E
0005434681790	1927	94	39B
0005434681882	1927	95	39D
0005434681848	1927	96	42C
0005434681860	1927	97	36F
0005432272959	1927	98	36E
0005434531438	1927	99	35F
0005434531485	1927	100	33K
0005434681877	1927	101	36D
0005434531479	1927	102	35G
0005434531443	1927	103	35E
0005434531484	1927	104	35D
0005434681772	1927	105	36C
0005434681779	1927	106	35C
0005434531473	1927	107	35J
0005434300890	1927	108	34C
0005434681856	1927	109	35B
0005434681827	1927	110	32F
0005434681870	1927	111	35A
0005434681814	1927	112	32E
0005434681794	1927	113	34D
0005434681834	1927	114	34K
0005435137687	1927	115	34G
0005434681885	1927	116	31E
0005434681865	1927	117	30C
0005434681792	1927	118	31D
0005432272960	1927	119	30F
0005434681812	1927	120	32A
0005434531469	1927	121	32B
0005434681829	1927	122	30D
0005434681851	1927	123	29J
0005434531458	1927	124	27G
0005434531475	1927	125	27A
0005434681876	1927	126	30H
0005434681852	1927	127	26K
0005434681815	1927	128	30K
0005434531436	1927	129	26E
0005434531465	1927	130	29K
0005434681793	1927	131	25F
0005434681817	1927	132	15H
0005435137695	1927	133	26F
0005434531468	1927	134	15G
0005432272954	1927	135	26H
0005434681807	1927	136	28H
0005434681802	1927	137	26C
0005434531455	1927	138	28D
0005434681803	1927	139	29C
0005434531445	1927	140	27B
0005434681782	1927	141	27E
0005434681808	1927	142	29A
0005434531478	1927	143	18F
0005434681787	1927	144	15E
0005434681770	1927	145	19D
0005434681841	1927	146	19C
0005434681888	1927	147	19B
0005434681781	1927	148	20B
0005434681830	1927	149	17E
0005434681795	1927	150	19G
0005434681800	1927	151	20D
0005434681868	1927	152	19A
0005434681832	1927	153	22J
0005434681844	1927	154	23A
0005434681847	1927	155	23B
0005432272956	1927	156	22F
0005434681821	1927	157	20A
0005434531447	1927	158	21D
0005434681838	1927	159	20F
0005434681874	1927	160	17A
0005434681788	1927	161	22B
0005434681773	1927	162	21K
0005434681859	1927	163	21H
0005434681825	1927	164	21G
0005434681833	1927	165	21A
0005434681835	1927	166	20K
0005434531448	1927	167	14D
0005434681879	1927	168	16H
0005434681875	1927	169	15K
0005434681796	1927	170	18A
0005434531474	1927	171	17K
0005434681811	1927	172	18B
0005434300887	1927	173	17H
0005434681836	1927	174	18K
0005434681819	1927	175	18J
0005435137685	1927	176	17G
0005434681806	1927	177	16D
0005434681797	1927	178	16E
0005434681883	1927	179	16G
0005434681886	1927	180	1H
0005434681845	1927	181	15C
0005434681776	1927	182	14F
0005434531434	1927	183	14C
0005434681769	1927	184	2C
0005434531449	1927	185	2G
0005434681809	1927	186	1G
0005432272955	1927	187	14A
0005434681775	1927	188	13K
0005434681857	1927	189	14H
0005434681869	1927	190	12F
0005434681837	1927	191	13D
0005434531442	1927	192	4D
0005434531456	1927	193	13E
0005434531457	1927	194	13F
0005434681839	1927	195	5H
0005435137694	1927	196	13G
0005434681783	1927	197	13A
0005434300889	1927	198	5D
0005434681780	1927	199	11C
0005434531452	1927	200	11E
0005434531470	1927	201	11F
0005434681784	1927	202	12C
0005434681818	1927	203	12H
0005434681828	1927	204	12G
0005432272958	1927	205	5C
0005434681864	1927	206	11K
0005434681798	1927	207	3D
0005434681771	1927	208	4K
0005434531453	1927	209	2H
0005434681853	1927	210	4A
0005433171990	63945	1	33G
0005432196731	63945	2	47F
0005433211531	63945	3	32K
0005433211542	63945	4	20J
0005433171988	63945	5	20A
0005433211538	63945	6	20F
0005433211556	63945	7	20C
0005433211550	63945	8	35H
0005433211514	63945	9	23J
0005433172001	63945	10	14E
0005433171997	63945	11	15C
0005433211502	63945	12	13D
0005433172009	63945	13	13E
0005433172010	63945	14	13F
0005433211533	63945	15	15A
0005433211516	63945	16	13H
0005433211526	63945	17	11F
0005433211548	63945	18	14C
0005433211560	63945	19	35C
0005433211561	63945	20	11D
0005433211509	63945	21	11H
0005433765266	63945	22	12A
0005433211517	63945	23	4C
0005433211540	63945	24	5C
0005433211513	63945	25	45B
0005433112733	63945	26	2G
0005433211544	63945	27	35A
0005433211539	63945	28	3K
0005433211532	63945	29	3C
0005433211543	63945	30	2K
0005433211551	63945	31	27A
0005433211535	63945	32	11C
0005432196729	63945	33	5H
0005433211508	63945	34	36D
0005433171987	63945	35	36J
0005433211527	63945	36	35J
0005433171995	63945	37	34J
0005433172008	63945	38	34F
0005433211546	63945	39	1G
0005433211503	63945	40	43C
0005433211510	63945	41	36H
0005433211541	63945	42	34C
0005433211559	63945	43	48E
0005433765265	63945	44	43J
0005432196730	63945	45	43F
0005432196727	63945	46	46D
0005433171999	63945	47	48F
0005433171992	63945	48	46F
0005433211558	63945	49	47G
0005434030369	63945	50	48G
0005434030368	63945	51	47K
0005433211537	63945	52	51G
0005433211524	63945	53	47D
0005433211505	63945	54	48D
0005433171994	63945	55	48C
0005433211499	63945	56	49E
0005433172006	63945	57	50H
0005433172000	63945	58	49H
0005433211555	63945	59	50E
0005433172011	63945	60	50C
0005433211498	63945	61	50K
0005433211530	63945	62	51F
0005434030372	63945	63	49K
0005433765264	63945	64	31K
0005433211506	63945	65	29F
0005434030370	63945	66	32F
0005432196732	63945	67	31G
0005433211536	63945	68	23K
0005433171986	63945	69	27B
0005433211534	63945	70	27H
0005433211500	63945	71	41H
0005433211504	63945	72	31E
0005433211522	63945	73	29E
0005433211519	63945	74	32E
0005433171998	63945	75	39J
0005433211545	63945	76	30J
0005433172002	63945	77	29J
0005433171993	63945	78	32J
0005433211557	63945	79	43B
0005432196728	63945	80	45A
0005433171989	63945	81	30H
0005433172004	63945	82	30F
0005433211529	63945	83	41A
0005433211528	63945	84	42G
0005433172005	63945	85	39F
0005433112734	63945	86	40E
0005433172003	63945	87	39D
0005433211554	63945	88	42E
0005432196726	63945	89	17C
0005433171991	63945	90	18J
0005433211547	63945	91	22H
0005433211553	63945	92	19H
0005433211552	63945	93	21K
0005433171985	63945	94	22B
0005434030367	63945	95	26G
0005433171996	63945	96	26C
0005433211507	63945	97	18F
0005433211523	63945	98	45H
0005433211525	63945	99	18E
0005434030371	63945	100	23A
0005433211521	63945	101	36E
0005433211518	63945	102	18A
0005433211549	63945	103	36G
0005433211511	63945	104	38A
0005433211501	63945	105	17A
0005433172007	63945	106	38K
0005433211512	63945	107	15D
0005433765267	63945	108	37G
0005434030373	63945	109	45C
0005433211520	63945	110	16H
0005433211515	63945	111	15F
0005432196725	63945	112	36F
0005434041997	50435	1	40K
0005432480733	50435	2	40H
0005432480777	50435	3	40E
0005432480774	50435	4	40D
0005432480808	50435	5	5C
0005432480708	50435	6	3G
0005434042031	50435	7	36C
0005432480703	50435	8	36A
0005432147353	50435	9	35J
0005432480720	50435	10	37E
0005434042018	50435	11	37B
0005432064406	50435	12	36G
0005432480744	50435	13	37C
0005434042011	50435	14	36H
0005432532248	50435	15	37J
0005434042040	50435	16	39H
0005432480750	50435	17	39G
0005432480709	50435	18	37G
0005432480824	50435	19	37F
0005432480822	50435	20	39C
0005432480705	50435	21	38H
0005432480801	50435	22	14A
0005432480772	50435	23	39A
0005434041975	50435	24	40B
0005434042006	50435	25	39K
0005432147357	50435	26	40A
0005432480828	50435	27	41A
0005434041996	50435	28	40J
0005432480742	50435	29	43A
0005432480815	50435	30	31H
0005434042000	50435	31	43H
0005434042033	50435	32	43F
0005434042014	50435	33	31G
0005432480818	50435	34	42K
0005432147352	50435	35	42G
0005432480723	50435	36	42E
0005432064407	50435	37	42D
0005432534064	50435	38	41D
0005432064405	50435	39	42C
0005434042001	50435	40	42A
0005432534060	50435	41	41F
0005432480753	50435	42	45C
0005432480710	50435	43	43K
0005432480707	50435	44	32C
0005432480735	50435	45	48A
0005434042026	50435	46	43J
0005432532249	50435	47	44D
0005432480811	50435	48	44C
0005434042037	50435	49	45A
0005432480760	50435	50	44A
0005432480827	50435	51	44G
0005432480755	50435	52	45B
0005432480695	50435	53	44K
0005432480745	50435	54	44H
0005432147356	50435	55	45E
0005432480779	50435	56	45D
0005432064403	50435	57	46F
0005434041970	50435	58	45H
0005432480714	50435	59	47H
0005434041981	50435	60	46C
0005432427687	50435	61	45K
0005432480746	50435	62	45J
0005432480721	50435	63	47G
0005434041982	50435	64	47A
0005432147351	50435	65	46J
0005434042024	50435	66	46E
0005432480730	50435	67	13D
0005432480783	50435	68	47F
0005432480736	50435	69	47E
0005432480799	50435	70	47C
0005432480722	50435	71	50G
0005432480698	50435	72	49D
0005432480716	50435	73	48C
0005432480765	50435	74	48D
0005432480699	50435	75	32D
0005432480781	50435	76	49A
0005432480787	50435	77	48H
0005434042032	50435	78	48E
0005432480719	50435	79	50F
0005434042004	50435	80	49H
0005432480734	50435	81	49F
0005434042023	50435	82	49E
0005434042019	50435	83	49K
0005434041980	50435	84	50C
0005434042029	50435	85	50D
0005432147355	50435	86	50A
0005432480785	50435	87	34D
0005432480752	50435	88	50H
0005432480789	50435	89	51G
0005432480759	50435	90	50K
0005432064411	50435	91	32E
0005432480704	50435	92	51F
0005432480762	50435	93	34C
0005432480803	50435	94	51D
0005432480696	50435	95	32G
0005432480740	50435	96	33F
0005432480802	50435	97	33H
0005432480793	50435	98	33J
0005432480788	50435	99	33E
0005434042022	50435	100	32J
0005432480769	50435	101	32K
0005432480725	50435	102	33A
0005432480757	50435	103	32B
0005434041969	50435	104	31J
0005434041974	50435	105	31K
0005434041999	50435	106	35H
0005432534061	50435	107	26D
0005432064414	50435	108	35G
0005434041985	50435	109	26J
0005434041973	50435	110	26K
0005432532250	50435	111	27A
0005434042010	50435	112	27B
0005434042027	50435	113	30F
0005434042020	50435	114	27G
0005434042002	50435	115	31F
0005432480776	50435	116	30J
0005434041991	50435	117	27E
0005432480724	50435	118	31C
0005432480766	50435	119	31A
0005434042016	50435	120	31D
0005432064410	50435	121	30C
0005434042003	50435	122	27K
0005434042012	50435	123	30G
0005434041992	50435	124	12D
0005432480729	50435	125	30B
0005434042028	50435	126	29G
0005432480715	50435	127	29K
0005434041994	50435	128	29J
0005432480823	50435	129	29C
0005432532247	50435	130	29D
0005432480717	50435	131	28A
0005434042015	50435	132	29F
0005432427689	50435	133	28B
0005432480826	50435	134	29A
0005434041971	50435	135	28K
0005434042007	50435	136	28J
0005434041978	50435	137	27J
0005432480761	50435	138	27F
0005434042035	50435	139	35F
0005432480738	50435	140	20K
0005432480731	50435	141	21A
0005434042009	50435	142	21B
0005434042034	50435	143	21C
0005432480806	50435	144	22C
0005434042025	50435	145	25H
0005432480791	50435	146	25J
0005432064415	50435	147	22B
0005434042030	50435	148	25K
0005432480819	50435	149	26A
0005432480778	50435	150	26B
0005434041983	50435	151	22D
0005432480798	50435	152	25F
0005432480748	50435	153	25G
0005432480813	50435	154	23H
0005432480782	50435	155	25D
0005432480711	50435	156	24G
0005432480732	50435	157	23K
0005434042008	50435	158	25B
0005432480701	50435	159	22F
0005432480820	50435	160	23E
0005432480756	50435	161	23D
0005432480743	50435	162	23G
0005432480780	50435	163	23B
0005432064412	50435	164	22G
0005432427690	50435	165	22H
0005432480739	50435	166	23A
0005432480794	50435	167	21J
0005434042039	50435	168	21G
0005432480814	50435	169	18K
0005434041976	50435	170	19K
0005432064404	50435	171	20G
0005434042038	50435	172	20J
0005432480694	50435	173	20A
0005432480800	50435	174	20H
0005434041990	50435	175	20E
0005434042005	50435	176	20F
0005432480795	50435	177	19B
0005432480804	50435	178	19G
0005432480764	50435	179	19H
0005432480821	50435	180	19J
0005432427688	50435	181	19A
0005432480718	50435	182	19F
0005434042013	50435	183	19C
0005432480726	50435	184	19E
0005434041989	50435	185	19D
0005432480810	50435	186	18G
0005432480751	50435	187	17E
0005432480825	50435	188	17G
0005432534062	50435	189	18F
0005432480713	50435	190	18A
0005434041987	50435	191	18C
0005432480770	50435	192	16D
0005432480792	50435	193	17D
0005432480727	50435	194	16F
0005432480771	50435	195	16K
0005432480812	50435	196	17A
0005434042021	50435	197	16C
0005432480763	50435	198	14C
0005432064408	50435	199	15H
0005432064409	50435	200	16A
0005432480786	50435	201	15F
0005432480749	50435	202	14K
0005432480809	50435	203	15C
0005434041972	50435	204	15E
0005432480747	50435	205	14G
0005432480816	50435	206	13G
0005432064402	50435	207	14E
0005434041979	50435	208	34G
0005432534063	50435	209	11F
0005432480797	50435	210	11H
0005432480817	50435	211	11K
0005432064413	50435	212	12C
0005434042017	50435	213	4G
0005432480737	50435	214	12E
0005432480784	50435	215	13F
0005432480796	50435	216	12F
0005434041993	50435	217	12K
0005432480758	50435	218	3A
0005434041977	50435	219	5H
0005432480728	50435	220	5K
0005432480767	50435	221	11D
0005432480706	50435	222	11E
0005432480807	50435	223	4K
0005432480741	50435	224	5D
0005434041995	50435	225	3D
0005432480768	50435	226	5G
0005434041998	50435	227	4A
0005434042036	50435	228	4H
0005434041988	50435	229	4C
0005434041984	50435	230	3K
0005432480712	50435	231	2G
0005432480805	50435	232	1C
0005432480754	50435	233	2H
0005434041986	50435	234	1D
0005432427686	50435	235	2A
0005432480790	50435	236	1G
0005432480697	50435	237	1H
0005432480700	50435	238	34E
0005432064401	50435	239	1A
0005432147354	50435	240	35D
0005432480773	50435	241	35B
0005432480702	50435	242	35A
0005432480775	50435	243	34K
0005435573784	34730	1	48G
0005435573726	34730	2	1A
0005435573829	34730	3	46E
0005435573801	34730	4	25E
0005435573770	34730	5	41D
0005434568271	34730	6	3A
0005435573725	34730	7	11E
0005435573781	34730	8	11G
0005434331296	34730	9	11D
0005435573731	34730	10	43J
0005434331325	34730	11	11A
0005432127763	34730	12	43K
0005432046195	34730	13	44G
0005434331314	34730	14	45F
0005435573769	34730	15	34C
0005434331298	34730	16	4A
0005435573744	34730	17	45D
0005434331310	34730	18	4D
0005434331305	34730	19	35A
0005435573788	34730	20	4G
0005434568263	34730	21	3G
0005432127760	34730	22	45C
0005434331319	34730	23	1K
0005434568276	34730	24	1C
0005435573773	34730	25	3K
0005432127769	34730	26	34F
0005434331317	34730	27	1G
0005435573798	34730	28	2H
0005432127759	34730	29	2A
0005435573831	34730	30	47C
0005435573855	34730	31	45H
0005434568266	34730	32	46C
0005435573750	34730	33	49C
0005435573802	34730	34	47F
0005434331292	34730	35	47G
0005435573815	34730	36	46H
0005435573786	34730	37	47E
0005435573821	34730	38	47H
0005435573749	34730	39	46K
0005435573799	34730	40	48C
0005434331301	34730	41	48A
0005435573846	34730	42	47K
0005435573823	34730	43	48D
0005434331308	34730	44	49A
0005435573779	34730	45	50H
0005435573792	34730	46	51D
0005434331316	34730	47	48E
0005435573800	34730	48	48F
0005434331295	34730	49	51E
0005435573824	34730	50	50D
0005435573783	34730	51	50G
0005435573728	34730	52	51G
0005434331303	34730	53	49H
0005435573743	34730	54	49G
0005435573834	34730	55	50C
0005435573835	34730	56	49F
0005434568265	34730	57	41G
0005432046193	34730	58	40D
0005435573859	34730	59	28H
0005435573853	34730	60	39E
0005435573832	34730	61	40C
0005434568267	34730	62	35K
0005435573767	34730	63	36C
0005435573841	34730	64	38H
0005435573762	34730	65	36G
0005435093709	34730	66	36H
0005434331324	34730	67	37E
0005434331309	34730	68	33F
0005432127758	34730	69	39A
0005435573838	34730	70	37F
0005435093714	34730	71	38B
0005435573807	34730	72	39B
0005435573734	34730	73	37C
0005435093708	34730	74	37D
0005434568275	34730	75	35G
0005435573830	34730	76	28G
0005435573742	34730	77	35E
0005435573757	34730	78	41H
0005435573732	34730	79	36B
0005435573787	34730	80	36F
0005434331300	34730	81	37A
0005435573811	34730	82	36J
0005435573822	34730	83	38J
0005435573772	34730	84	40A
0005434331307	34730	85	41C
0005435573804	34730	86	29E
0005434568270	34730	87	29K
0005435093711	34730	88	29J
0005434331323	34730	89	29H
0005435573775	34730	90	29C
0005435573745	34730	91	31B
0005435573739	34730	92	30H
0005435573860	34730	93	31C
0005435573828	34730	94	30K
0005434568273	34730	95	39F
0005435573764	34730	96	39J
0005434568272	34730	97	39G
0005434331321	34730	98	29B
0005435573735	34730	99	39K
0005435573808	34730	100	28K
0005432127756	34730	101	28J
0005435573843	34730	102	31D
0005435573771	34730	103	31E
0005435573817	34730	104	33C
0005435573778	34730	105	32K
0005435573727	34730	106	31G
0005435573754	34730	107	32B
0005435093707	34730	108	31F
0005435573849	34730	109	32E
0005435573785	34730	110	32C
0005435573793	34730	111	32H
0005435573751	34730	112	32J
0005435573741	34730	113	30A
0005435573826	34730	114	29F
0005434331313	34730	115	41F
0005434331318	34730	116	33G
0005434331299	34730	117	45A
0005435573852	34730	118	43A
0005435573790	34730	119	40F
0005435093713	34730	120	40G
0005435573806	34730	121	28D
0005435573755	34730	122	40H
0005434331306	34730	123	40J
0005435093712	34730	124	40K
0005435573746	34730	125	18J
0005435573809	34730	126	28E
0005435573854	34730	127	25D
0005435573810	34730	128	5K
0005432127761	34730	129	12A
0005435573803	34730	130	20A
0005435573758	34730	131	11K
0005435573795	34730	132	21E
0005434331311	34730	133	19E
0005435573858	34730	134	26G
0005434331304	34730	135	27E
0005432127765	34730	136	18K
0005435573857	34730	137	27A
0005435573850	34730	138	28C
0005434331293	34730	139	28B
0005435573820	34730	140	26B
0005435573842	34730	141	26D
0005434331322	34730	142	42J
0005434568264	34730	143	27C
0005435573780	34730	144	23G
0005435573747	34730	145	19J
0005434568277	34730	146	23D
0005434331312	34730	147	26K
0005435573812	34730	148	23B
0005435573768	34730	149	21J
0005435573748	34730	150	24D
0005435573827	34730	151	25A
0005435573789	34730	152	26A
0005435573763	34730	153	23E
0005432127767	34730	154	21F
0005435573840	34730	155	23K
0005435573816	34730	156	23F
0005435573814	34730	157	22E
0005435573740	34730	158	22F
0005435573848	34730	159	22C
0005434568274	34730	160	22B
0005435573818	34730	161	12D
0005434568269	34730	162	12F
0005435573837	34730	163	13F
0005435573760	34730	164	13K
0005435573766	34730	165	15A
0005435573759	34730	166	12G
0005435573791	34730	167	19C
0005435573761	34730	168	42C
0005435573836	34730	169	19F
0005432046194	34730	170	20B
0005435573738	34730	171	21C
0005435573736	34730	172	19G
0005435573737	34730	173	20K
0005435573845	34730	174	20C
0005434331320	34730	175	20D
0005435573794	34730	176	42D
0005432127768	34730	177	42F
0005434331297	34730	178	14D
0005435573733	34730	179	16A
0005434331294	34730	180	4K
0005435573730	34730	181	42B
0005434331290	34730	182	35D
0005435573752	34730	183	42A
0005435573805	34730	184	5H
0005435573844	34730	185	5D
0005435573756	34730	186	43C
0005435573796	34730	187	5C
0005434331315	34730	188	43D
0005434568268	34730	189	43G
0005435093710	34730	190	15G
0005435573833	34730	191	44H
0005432127762	34730	192	17A
0005435573777	34730	193	18H
0005435573839	34730	194	18G
0005435573729	34730	195	15E
0005435573774	34730	196	16D
0005432127764	34730	197	18C
0005435573856	34730	198	18E
0005434331302	34730	199	18D
0005435573797	34730	200	15F
0005435573851	34730	201	17K
0005435573765	34730	202	17E
0005435573724	34730	203	18A
0005435573825	34730	204	14E
0005435573776	34730	205	16E
0005435573813	34730	206	16F
0005432127757	34730	207	16G
0005435573782	34730	208	13C
0005434331291	34730	209	13A
0005435573819	34730	210	14C
0005435093706	34730	211	14A
0005432127766	34730	212	13D
0005435573753	34730	213	12K
0005435573847	34730	214	12E
0005435093715	34730	215	11C
0005432840240	70787	1	35H
0005435400007	70787	2	35G
0005434234375	70787	3	40J
0005435399985	70787	4	40D
0005435400002	70787	5	15C
0005435399979	70787	6	32G
0005434234382	70787	7	23J
0005434234371	70787	8	26H
0005432162282	70787	9	14E
0005434234362	70787	10	26G
0005435399960	70787	11	32A
0005435400004	70787	12	25F
0005435042032	70787	13	27C
0005435400030	70787	14	27B
0005434234370	70787	15	26K
0005434234384	70787	16	29B
0005435399987	70787	17	27E
0005434655823	70787	18	28E
0005435399959	70787	19	28C
0005435399986	70787	20	18F
0005435399994	70787	21	24E
0005434234373	70787	22	26B
0005434234377	70787	23	25J
0005435400001	70787	24	18E
0005435399963	70787	25	25C
0005435400019	70787	26	33B
0005432162280	70787	27	25E
0005432165721	70787	28	15D
0005434234356	70787	29	16H
0005435400020	70787	30	15F
0005434234364	70787	31	33D
0005435400010	70787	32	24G
0005434234363	70787	33	17H
0005435399977	70787	34	15K
0005434655824	70787	35	16E
0005433717907	70787	36	16A
0005435399968	70787	37	21K
0005434234379	70787	38	18G
0005435400015	70787	39	22G
0005432362232	70787	40	21J
0005432162279	70787	41	23C
0005434234376	70787	42	23A
0005434234359	70787	43	20F
0005434234357	70787	44	20G
0005435400029	70787	45	21C
0005435042033	70787	46	19E
0005433717908	70787	47	21B
0005434234360	70787	48	20A
0005435400009	70787	49	21D
0005435399997	70787	50	19F
0005435400000	70787	51	20K
0005435400022	70787	52	33E
0005435399978	70787	53	38K
0005435399971	70787	54	15E
0005435399967	70787	55	37J
0005434234367	70787	56	36K
0005435399965	70787	57	38B
0005435400005	70787	58	38H
0005435399961	70787	59	40B
0005435399982	70787	60	40A
0005432162284	70787	61	39G
0005435399995	70787	62	40G
0005435399974	70787	63	36F
0005435399975	70787	64	36A
0005435399988	70787	65	3A
0005434234374	70787	66	45F
0005434234380	70787	67	34G
0005435399962	70787	68	34F
0005435400026	70787	69	36J
0005432162278	70787	70	34A
0005435399969	70787	71	34J
0005435399964	70787	72	35B
0005435400028	70787	73	35A
0005435399990	70787	74	34B
0005434234378	70787	75	48D
0005435399984	70787	76	40K
0005434234358	70787	77	45A
0005435399981	70787	78	50H
0005435399970	70787	79	48H
0005435399999	70787	80	51D
0005432362230	70787	81	48C
0005432165722	70787	82	47G
0005435399991	70787	83	47H
0005435400017	70787	84	45C
0005434234369	70787	85	46C
0005435400027	70787	86	46D
0005434234361	70787	87	44K
0005434234383	70787	88	11G
0005435400018	70787	89	5C
0005432840239	70787	90	13A
0005435399992	70787	91	5D
0005435042031	70787	92	12K
0005435400021	70787	93	11D
0005435400012	70787	94	30B
0005435399972	70787	95	11H
0005435400006	70787	96	29H
0005435399966	70787	97	11K
0005435399980	70787	98	3K
0005434234355	70787	99	5H
0005435399998	70787	100	4C
0005435042034	70787	101	2G
0005435400016	70787	102	41D
0005435400003	70787	103	31B
0005435399976	70787	104	31A
0005435400024	70787	105	30E
0005435399983	70787	106	30J
0005432362231	70787	107	3G
0005433717910	70787	108	3C
0005432162283	70787	109	13C
0005435399973	70787	110	29J
0005434234381	70787	111	30H
0005435400013	70787	112	31G
0005435400014	70787	113	31F
0005434234368	70787	114	31D
0005435400011	70787	115	14A
0005435400025	70787	116	42A
0005435399996	70787	117	13F
0005435400023	70787	118	30A
0005434234365	70787	119	29D
0005435399993	70787	120	14C
0005435400008	70787	121	29G
0005432162281	70787	122	41F
0005434234372	70787	123	42H
0005433717909	70787	124	42F
0005434234385	70787	125	43D
0005434655825	70787	126	43C
0005434234366	70787	127	44H
0005435399989	70787	128	44C
0005433621530	21488	1	23D
0005433793148	21488	2	19B
0005433793175	21488	3	19C
0005433793159	21488	4	19D
0005433500516	21488	5	19E
0005433500522	21488	6	23F
0005433621551	21488	7	9C
0005433500510	21488	8	9D
0005433500524	21488	9	9E
0005432173685	21488	10	9A
0005432173678	21488	11	9B
0005433500511	21488	12	8A
0005433500523	21488	13	7F
0005433621554	21488	14	8F
0005432173686	21488	15	8B
0005432173692	21488	16	8D
0005433793145	21488	17	23E
0005433793155	21488	18	18D
0005433793151	21488	19	7D
0005433621543	21488	20	7C
0005433621562	21488	21	31D
0005433793152	21488	22	18C
0005433621563	21488	23	31F
0005433621560	21488	24	20A
0005433621538	21488	25	6F
0005433621549	21488	26	26E
0005433500513	21488	27	10B
0005433621536	21488	28	9F
0005433621540	21488	29	18E
0005433793160	21488	30	20B
0005432173687	21488	31	18F
0005433621542	21488	32	20F
0005433793169	21488	33	21D
0005433621559	21488	34	16C
0005433793149	21488	35	14C
0005432173690	21488	36	11A
0005433621539	21488	37	15C
0005433793163	21488	38	15F
0005433621545	21488	39	16B
0005433793172	21488	40	6D
0005433793164	21488	41	14F
0005433621537	21488	42	14D
0005433621556	21488	43	14E
0005433621555	21488	44	13D
0005433621533	21488	45	10F
0005433500525	21488	46	14A
0005433621548	21488	47	31A
0005433793174	21488	48	10E
0005432173674	21488	49	16D
0005432173673	21488	50	11E
0005432173680	21488	51	12B
0005433793161	21488	52	10C
0005433500512	21488	53	24D
0005433500526	21488	54	13A
0005433793165	21488	55	12D
0005433793154	21488	56	13C
0005433621564	21488	57	12E
0005432173672	21488	58	16F
0005433793168	21488	59	16A
0005432173677	21488	60	15D
0005433621561	21488	61	29D
0005432173689	21488	62	2F
0005433793173	21488	63	26B
0005433500527	21488	64	25E
0005432173676	21488	65	26A
0005432173679	21488	66	1A
0005433500518	21488	67	1C
0005433793162	21488	68	1F
0005433621552	21488	69	3C
0005433793144	21488	70	2A
0005432173688	21488	71	2D
0005433621550	21488	72	6C
0005433500515	21488	73	17D
0005432173682	21488	74	25D
0005433793167	21488	75	1D
0005432173675	21488	76	28D
0005433793150	21488	77	6A
0005433500519	21488	78	4C
0005432173684	21488	79	3A
0005432173681	21488	80	5A
0005433500514	21488	81	3F
0005433621558	21488	82	5C
0005433500520	21488	83	3D
0005433500517	21488	84	5F
0005433621541	21488	85	29A
0005433793146	21488	86	31C
0005432173691	21488	87	30D
0005433621557	21488	88	4F
0005433621547	21488	89	30B
0005433793170	21488	90	27F
0005433793171	21488	91	26F
0005433621528	21488	92	27A
0005432173683	21488	93	27D
0005433793166	21488	94	22E
0005433621531	21488	95	23C
0005433793156	21488	96	21A
0005433621546	21488	97	22B
0005433621553	21488	98	21C
0005433500509	21488	99	20E
0005433621529	21488	100	22C
0005433793153	21488	101	24C
0005433793158	21488	102	23A
0005433621544	21488	103	24F
0005433621535	21488	104	17B
0005433621532	21488	105	17F
0005433621534	21488	106	26D
0005433793147	21488	107	24A
0005433500521	21488	108	23B
0005433793157	21488	109	25A
0005435867787	53004	1	6F
0005435867785	53004	2	6D
0005432441058	53004	3	16D
0005435867797	53004	4	7D
0005435867782	53004	5	5A
0005435867823	53004	6	4D
0005432441104	53004	7	8B
0005432441065	53004	8	8C
0005432441078	53004	9	8A
0005432037698	53004	10	2F
0005432441066	53004	11	1C
0005432441085	53004	12	1D
0005435867800	53004	13	2A
0005435867805	53004	14	4A
0005435867799	53004	15	2D
0005432037702	53004	16	2C
0005432441093	53004	17	4C
0005432441067	53004	18	3A
0005435867808	53004	19	3C
0005432441102	53004	20	7C
0005432441096	53004	21	5F
0005435867786	53004	22	7A
0005435867811	53004	23	6A
0005432037701	53004	24	31C
0005432037700	53004	25	31B
0005432037703	53004	26	26D
0005435867801	53004	27	30D
0005432037697	53004	28	26E
0005432441069	53004	29	9A
0005435867806	53004	30	28A
0005435867817	53004	31	24E
0005435867796	53004	32	25A
0005435867803	53004	33	8E
0005432441070	53004	34	25D
0005435867795	53004	35	25F
0005432441068	53004	36	25E
0005432441086	53004	37	25C
0005435867780	53004	38	31A
0005432441082	53004	39	27D
0005432441081	53004	40	27E
0005432037693	53004	41	31F
0005432441099	53004	42	27B
0005432441072	53004	43	27F
0005435867824	53004	44	29D
0005432441088	53004	45	28C
0005435867812	53004	46	28D
0005432441107	53004	47	29B
0005435867807	53004	48	29E
0005435867789	53004	49	30C
0005432441063	53004	50	29F
0005432441092	53004	51	29C
0005435867802	53004	52	31D
0005435867784	53004	53	31E
0005435867818	53004	54	11C
0005432441076	53004	55	9B
0005432037699	53004	56	20C
0005432037695	53004	57	20D
0005432441100	53004	58	20E
0005432441059	53004	59	18E
0005434311571	53004	60	19C
0005432441089	53004	61	9F
0005432441106	53004	62	8D
0005435867791	53004	63	10F
0005435867813	53004	64	11B
0005432441087	53004	65	11A
0005435867816	53004	66	9D
0005432441064	53004	67	10C
0005435867783	53004	68	10A
0005432441077	53004	69	17E
0005432441097	53004	70	12F
0005432441080	53004	71	12A
0005432441060	53004	72	10E
0005432441108	53004	73	13A
0005435867790	53004	74	11E
0005432441091	53004	75	16B
0005432441074	53004	76	12B
0005435867821	53004	77	15C
0005435867814	53004	78	15D
0005435867804	53004	79	14E
0005432037694	53004	80	16A
0005432037692	53004	81	12C
0005432441103	53004	82	12D
0005435867810	53004	83	15E
0005432441071	53004	84	14B
0005432441073	53004	85	13B
0005432441061	53004	86	13E
0005432441109	53004	87	18B
0005432441098	53004	88	18A
0005435867792	53004	89	16F
0005435867809	53004	90	17D
0005432037696	53004	91	16E
0005435867815	53004	92	17A
0005432441062	53004	93	17C
0005435867819	53004	94	17F
0005432441083	53004	95	18D
0005432441090	53004	96	19D
0005432441079	53004	97	18F
0005434311570	53004	98	20A
0005435867798	53004	99	22B
0005435867825	53004	100	22D
0005432037691	53004	101	21C
0005435867779	53004	102	21E
0005432441094	53004	103	20B
0005435867827	53004	104	21D
0005435867793	53004	105	26A
0005432441084	53004	106	25B
0005432441105	53004	107	24A
0005435867788	53004	108	26B
0005432441101	53004	109	24B
0005434311569	53004	110	23E
0005435867826	53004	111	23F
0005435867781	53004	112	30F
0005435867794	53004	113	22F
0005432441095	53004	114	23B
0005435867820	53004	115	23A
0005432441075	53004	116	23C
0005435867822	53004	117	24C
0005432369024	29465	1	14C
0005432369030	29465	2	15C
0005432369057	29465	3	16E
0005433453071	29465	4	16C
0005432369019	29465	5	13E
0005433454117	29465	6	18D
0005432369020	29465	7	18A
0005432369028	29465	8	18E
0005432369043	29465	9	11C
0005433454116	29465	10	6E
0005432369023	29465	11	5F
0005433720097	29465	12	7E
0005432369055	29465	13	1A
0005433720096	29465	14	1C
0005432723430	29465	15	7F
0005432369056	29465	16	2C
0005432369034	29465	17	8A
0005433453070	29465	18	11A
0005432369033	29465	19	4C
0005432723426	29465	20	6F
0005432369027	29465	21	5E
0005432369050	29465	22	3C
0005432369041	29465	23	7C
0005432369038	29465	24	5D
0005433720092	29465	25	5C
0005432369018	29465	26	10F
0005432723427	29465	27	4F
0005432369054	29465	28	4D
0005432369045	29465	29	5A
0005432723425	29465	30	10E
0005432369016	29465	31	2A
0005432369049	29465	32	1D
0005432369046	29465	33	1F
0005432723428	29465	34	17F
0005432723434	29465	35	17A
0005432723424	29465	36	20C
0005432723432	29465	37	20D
0005433720093	29465	38	11D
0005432369039	29465	39	19F
0005433720094	29465	40	20A
0005432369047	29465	41	13A
0005432369048	29465	42	19E
0005432369052	29465	43	12F
0005432369035	29465	44	11F
0005432369026	29465	45	12D
0005432723433	29465	46	19C
0005433720095	29465	47	12C
0005432369017	29465	48	19A
0005432369025	29465	49	13C
0005432369037	29465	50	17E
0005432369029	29465	51	16F
0005432369044	29465	52	18F
0005432369015	29465	53	15F
0005432369040	29465	54	16D
0005432723431	29465	55	14A
0005432369031	29465	56	15A
0005433720091	29465	57	14E
0005432369021	29465	58	15E
0005432369058	29465	59	7D
0005432369032	29465	60	8C
0005432369022	29465	61	10D
0005432369051	29465	62	10A
0005432369036	29465	63	8D
0005432369042	29465	64	9D
0005433720098	29465	65	9F
0005432723429	29465	66	9C
0005432369053	29465	67	8F
0005435521470	11346	1	6C
0005435533215	11346	2	6A
0005435533195	11346	3	1F
0005435533199	11346	4	2A
0005435533210	11346	5	8C
0005433513505	11346	6	7D
0005435521475	11346	7	4E
0005433513501	11346	8	14A
0005435533200	11346	9	13C
0005435521474	11346	10	16C
0005432293618	11346	11	15F
0005435533218	11346	12	15D
0005435521455	11346	13	14F
0005433513500	11346	14	14C
0005435521472	11346	15	14D
0005432293619	11346	16	13A
0005435521466	11346	17	10F
0005435533212	11346	18	13F
0005435533204	11346	19	13E
0005435533197	11346	20	11E
0005435533208	11346	21	10D
0005435533207	11346	22	10E
0005435521461	11346	23	6D
0005435533213	11346	24	6E
0005435521456	11346	25	9D
0005432293617	11346	26	11C
0005435521458	11346	27	9C
0005435521462	11346	28	9E
0005433513499	11346	29	6F
0005435521473	11346	30	10A
0005435521471	11346	31	5C
0005435533203	11346	32	5A
0005433513502	11346	33	5D
0005435521459	11346	34	4F
0005435533202	11346	35	2C
0005433513506	11346	36	3F
0005435533206	11346	37	4A
0005435521467	11346	38	4D
0005435521465	11346	39	3A
0005435533205	11346	40	2F
0005435521463	11346	41	2D
0005433513503	11346	42	3C
0005435521468	11346	43	1A
0005435533217	11346	44	1D
0005435533209	11346	45	17C
0005435533211	11346	46	19D
0005435521464	11346	47	12E
0005435533196	11346	48	12D
0005435533214	11346	49	17F
0005435533201	11346	50	18A
0005433513504	11346	51	18C
0005432293616	11346	52	19C
0005435533198	11346	53	20D
0005435521457	11346	54	19E
0005435521469	11346	55	17E
0005433513507	11346	56	18D
0005435533216	11346	57	15A
0005435521460	11346	58	12F
0005435521454	11346	59	18F
0005433513498	11346	60	17D
0005432923305	142865	1	11E
0005432923306	142865	2	11C
0005432923307	142865	3	20F
0005432923309	142865	4	7A
0005432923308	142865	5	16A
0005432827835	47847	1	7C
0005434451302	47847	2	6C
0005432072144	47847	3	7A
0005432827837	47847	4	8E
0005432827810	47847	5	6E
0005432827833	47847	6	11C
0005432827828	47847	7	10D
0005434451303	47847	8	10F
0005434451310	47847	9	10A
0005432827819	47847	10	20E
0005434451300	47847	11	20D
0005432827826	47847	12	19D
0005432827820	47847	13	14C
0005432827821	47847	14	14A
0005434451309	47847	15	15A
0005432827822	47847	16	20A
0005432827816	47847	17	18D
0005432827840	47847	18	19C
0005432827813	47847	19	16C
0005432072146	47847	20	13A
0005434451315	47847	21	20F
0005434451307	47847	22	16A
0005432827827	47847	23	18F
0005432827829	47847	24	19F
0005432827812	47847	25	12C
0005432072145	47847	26	18C
0005434451312	47847	27	16D
0005432827832	47847	28	16F
0005432827838	47847	29	17D
0005434451316	47847	30	11D
0005434451305	47847	31	17C
0005432827825	47847	32	17F
0005432827834	47847	33	8A
0005432827839	47847	34	11F
0005434451304	47847	35	13E
0005434451308	47847	36	13C
0005432827831	47847	37	13D
0005432827815	47847	38	13F
0005434451318	47847	39	9A
0005434451306	47847	40	9C
0005432827830	47847	41	9D
0005432827841	47847	42	5D
0005432827818	47847	43	6D
0005434451317	47847	44	5E
0005432827824	47847	45	7E
0005432827817	47847	46	3D
0005432827823	47847	47	5A
0005434451314	47847	48	5C
0005432827814	47847	49	3C
0005432827836	47847	50	2F
0005434451301	47847	51	3A
0005432827811	47847	52	1C
0005434451311	47847	53	4C
0005434451313	47847	54	2A
0005435246190	187662	1	16F
0005435246186	187662	2	20C
0005435246193	187662	3	1F
0005435246181	187662	4	5A
0005435246179	187662	5	18C
0005434664129	187662	6	12D
0005435246182	187662	7	12A
0005435246195	187662	8	9D
0005434664128	187662	9	11F
0005435246178	187662	10	8F
0005435246180	187662	11	5F
0005435246183	187662	12	8A
0005435246188	187662	13	6A
0005435246191	187662	14	13C
0005435246189	187662	15	13D
0005432000284	187662	16	10C
0005435246187	187662	17	12E
0005435246194	187662	18	13A
0005434664130	187662	19	20E
0005435246184	187662	20	1C
0005435246185	187662	21	14F
0005434664127	187662	22	17E
0005435246192	187662	23	16C
0005435988054	57072	1	5D
0005435988060	57072	2	1F
0005435988058	57072	3	19A
0005435988055	57072	4	17C
0005435988057	57072	5	19E
0005435988056	57072	6	19D
0005435988059	57072	7	10C
0005434273944	102199	1	4A
0005434273942	102199	2	15E
0005434273941	102199	3	18B
0005434273940	102199	4	8A
0005434273939	102199	5	11A
0005434273943	102199	6	16B
0005432426374	133827	1	6A
0005432426375	133827	2	21B
0005433476129	200088	1	3B
0005433476128	200088	2	4D
0005433476130	200088	3	5C
0005432331725	41489	1	3D
0005432343049	41489	2	19E
0005432343072	41489	3	3A
0005432331724	41489	4	20A
0005432343040	41489	5	16B
0005432343051	41489	6	16D
0005432343055	41489	7	15B
0005432362230	41489	8	14F
0005432343044	41489	9	15C
0005432060305	41489	10	16E
0005432060307	41489	11	20C
0005432331722	41489	12	19D
0005432343032	41489	13	17C
0005432343030	41489	14	20B
0005432331723	41489	15	18A
0005432331720	41489	16	19F
0005432343050	41489	17	19C
0005432343041	41489	18	17A
0005432343042	41489	19	19A
0005432343035	41489	20	2C
0005432343048	41489	21	4E
0005432343065	41489	22	5A
0005432343061	41489	23	18B
0005432331721	41489	24	18D
0005432343064	41489	25	7B
0005432343043	41489	26	14D
0005432343062	41489	27	15F
0005432343054	41489	28	14C
0005432343029	41489	29	13E
0005432343066	41489	30	15E
0005432343063	41489	31	13A
0005432343073	41489	32	9F
0005432343046	41489	33	20D
0005432331728	41489	34	14A
0005432343036	41489	35	13F
0005432343034	41489	36	20E
0005432343060	41489	37	23D
0005432343074	41489	38	21E
0005432343052	41489	39	11D
0005432331719	41489	40	9C
0005432343056	41489	41	9A
0005432343067	41489	42	1C
0005432343039	41489	43	12F
0005432343038	41489	44	12A
0005432362232	41489	45	12C
0005432331718	41489	46	11B
0005432343075	41489	47	1D
0005432343037	41489	48	5D
0005432343071	41489	49	10C
0005432343053	41489	50	11E
0005432343058	41489	51	8F
0005432060304	41489	52	1F
0005432060302	41489	53	10D
0005432343069	41489	54	8E
0005432343068	41489	55	5C
0005432060306	41489	56	8A
0005432331726	41489	57	5E
0005432343070	41489	58	7D
0005432343031	41489	59	6F
0005432331727	41489	60	6A
0005432343059	41489	61	2A
0005432362231	41489	62	3F
0005432343027	41489	63	4C
0005432060303	41489	64	22F
0005432331729	41489	65	23B
0005432343028	41489	66	21A
0005432343045	41489	67	3C
0005432343033	41489	68	22A
0005432343047	41489	69	23C
0005432343057	41489	70	23F
0005434145492	136446	1	22D
0005435167203	136446	2	22B
0005435167208	136446	3	22F
0005435167188	136446	4	1C
0005435167190	136446	5	11C
0005435167189	136446	6	7A
0005432051643	136446	7	6E
0005435167193	136446	8	22E
0005435167197	136446	9	11E
0005435167194	136446	10	20E
0005435488978	136446	11	8B
0005434145487	136446	12	20C
0005435167210	136446	13	20D
0005435167214	136446	14	1A
0005435167205	136446	15	5C
0005435167199	136446	16	4E
0005435167192	136446	17	2F
0005434145496	136446	18	5B
0005432051646	136446	19	7C
0005434145488	136446	20	12C
0005434145493	136446	21	7E
0005432051645	136446	22	9E
0005432051644	136446	23	10E
0005435167191	136446	24	10B
0005435167211	136446	25	9F
0005435167201	136446	26	17D
0005435167195	136446	27	14E
0005435167212	136446	28	12B
0005434145486	136446	29	19B
0005435488979	136446	30	17E
0005435167200	136446	31	20B
0005435167207	136446	32	18C
0005435488976	136446	33	23E
0005435722382	136446	34	21B
0005434145491	136446	35	21F
0005434145494	136446	36	21C
0005435167206	136446	37	20F
0005435167204	136446	38	12A
0005435167198	136446	39	15E
0005434145497	136446	40	14D
0005435167202	136446	41	17C
0005434145490	136446	42	19A
0005434145489	136446	43	18D
0005435167196	136446	44	18F
0005435167209	136446	45	21A
0005435167213	136446	46	16F
0005435488977	136446	47	12E
0005434145495	136446	48	13D
0005434185139	114960	1	22D
0005434185137	114960	2	5A
0005434185138	114960	3	21B
0005434451309	188957	1	3D
0005434451304	188957	2	3C
0005434451301	188957	3	2A
0005434451315	188957	4	22D
0005434451305	188957	5	4C
0005434451316	188957	6	2B
0005434451318	188957	7	20D
0005434451303	188957	8	19D
0005434451313	188957	9	19A
0005434451314	188957	10	20B
0005434451300	188957	11	21A
0005434451310	188957	12	21B
0005434451306	188957	13	22A
0005434451311	188957	14	2D
0005434451317	188957	15	3A
0005434451302	188957	16	5B
0005434451308	188957	17	5A
0005434451312	188957	18	1C
0005434451307	188957	19	1B
0005435220674	205437	1	2B
0005435220673	205437	2	7B
0005435220675	205437	3	18A
0005435221208	205437	4	23A
0005435221207	205437	5	4B
0005432733681	2517	1	20E
0005432733643	2517	2	11D
0005432218460	2517	3	20F
0005432218458	2517	4	11E
0005432733659	2517	5	13E
0005432733663	2517	6	16C
0005432733652	2517	7	18D
0005432733658	2517	8	18C
0005432733670	2517	9	19A
0005432733650	2517	10	12D
0005432733657	2517	11	17F
0005432733661	2517	12	20C
0005432733669	2517	13	19F
0005432733677	2517	14	18A
0005432733645	2517	15	12A
0005432733674	2517	16	19D
0005432218457	2517	17	4E
0005432218461	2517	18	10D
0005432733648	2517	19	17C
0005432733647	2517	20	15F
0005432733655	2517	21	16F
0005432733664	2517	22	14E
0005432733644	2517	23	10A
0005432733672	2517	24	6D
0005432733665	2517	25	15E
0005432733678	2517	26	15A
0005432733654	2517	27	4D
0005432733675	2517	28	11A
0005432733651	2517	29	10F
0005432733653	2517	30	6E
0005432733679	2517	31	6F
0005432733662	2517	32	9F
0005432733667	2517	33	9E
0005432733646	2517	34	9A
0005432733660	2517	35	8A
0005432733668	2517	36	4A
0005432733656	2517	37	7E
0005432733671	2517	38	8D
0005432733649	2517	39	5A
0005432218459	2517	40	3A
0005432733680	2517	41	6A
0005432733673	2517	42	5D
0005432733676	2517	43	2F
0005435154157	2517	44	2C
0005432733666	2517	45	1C
0005432883966	78361	1	15F
0005432214014	78361	2	15E
0005432883963	78361	3	17A
0005432883961	78361	4	17D
0005432883957	78361	5	1A
0005432214017	78361	6	19E
0005432883970	78361	7	4D
0005432883972	78361	8	7E
0005432214015	78361	9	19F
0005432883974	78361	10	4C
0005432883965	78361	11	8C
0005432883958	78361	12	6C
0005432883973	78361	13	3A
0005432883975	78361	14	6F
0005432883969	78361	15	18C
0005432883956	78361	16	20C
0005432883971	78361	17	17F
0005432883960	78361	18	16E
0005432214016	78361	19	16D
0005432883959	78361	20	9E
0005432883962	78361	21	12A
0005432883964	78361	22	10E
0005432883967	78361	23	12D
0005432883968	78361	24	13A
0005432925959	210727	1	19D
0005432925961	210727	2	3A
0005432925958	210727	3	7C
0005432925960	210727	4	2D
0005434777921	34120	1	42D
0005434777874	34120	2	21G
0005435144951	34120	3	42J
0005434777930	34120	4	43G
0005434777886	34120	5	43J
0005434777857	34120	6	43F
0005434777827	34120	7	42A
0005434777879	34120	8	46A
0005434777843	34120	9	44J
0005434777826	34120	10	44F
0005434555390	34120	11	41G
0005434777870	34120	12	46D
0005435144950	34120	13	5D
0005434777835	34120	14	11A
0005434777881	34120	15	11H
0005434777876	34120	16	14H
0005435144946	34120	17	12C
0005434777919	34120	18	12H
0005434777902	34120	19	12D
0005434555396	34120	20	13C
0005434777889	34120	21	14D
0005434777883	34120	22	13H
0005435144947	34120	23	46J
0005434777891	34120	24	4G
0005434777811	34120	25	41D
0005434777904	34120	26	5A
0005434777868	34120	27	37G
0005435144954	34120	28	46E
0005434777828	34120	29	37H
0005434777820	34120	30	30B
0005434777884	34120	31	47C
0005434777858	34120	32	46K
0005434777845	34120	33	37F
0005434777848	34120	34	30E
0005434777918	34120	35	47E
0005435144956	34120	36	47K
0005432116253	34120	37	47H
0005434777842	34120	38	39J
0005434777897	34120	39	40C
0005434777864	34120	40	47G
0005434777850	34120	41	37C
0005434777926	34120	42	47F
0005432116254	34120	43	38A
0005434555389	34120	44	37J
0005435144952	34120	45	40B
0005434777901	34120	46	39E
0005434777893	34120	47	39A
0005434777841	34120	48	40A
0005432116256	34120	49	45F
0005434777892	34120	50	45G
0005434777878	34120	51	42K
0005434777852	34120	52	4A
0005434777929	34120	53	1G
0005434555395	34120	54	3G
0005432116257	34120	55	49H
0005434777813	34120	56	48D
0005432116249	34120	57	48F
0005434777865	34120	58	40E
0005434555386	34120	59	41C
0005434777806	34120	60	42F
0005434777856	34120	61	42E
0005434555385	34120	62	39F
0005434777824	34120	63	49F
0005434777809	34120	64	38B
0005434777915	34120	65	41A
0005434555398	34120	66	39G
0005434777840	34120	67	39D
0005434777900	34120	68	39B
0005435144945	34120	69	39H
0005434777887	34120	70	26D
0005434777830	34120	71	2K
0005435144944	34120	72	4D
0005434777869	34120	73	26F
0005432392648	34120	74	4C
0005434777829	34120	75	49K
0005434777846	34120	76	3C
0005435144949	34120	77	3K
0005435144948	34120	78	28F
0005434555384	34120	79	20K
0005434777802	34120	80	51F
0005434777925	34120	81	51G
0005434777924	34120	82	1H
0005434777844	34120	83	50K
0005434777923	34120	84	26H
0005434777910	34120	85	29H
0005434777805	34120	86	50C
0005434777898	34120	87	27F
0005434777895	34120	88	27A
0005434777859	34120	89	27C
0005434777862	34120	90	21J
0005432394786	34120	91	22E
0005434777807	34120	92	25B
0005435144955	34120	93	30F
0005434777819	34120	94	25G
0005434777914	34120	95	30G
0005434777882	34120	96	30H
0005434777818	34120	97	25E
0005434777839	34120	98	29F
0005434777851	34120	99	28K
0005434777838	34120	100	21K
0005435144943	34120	101	20H
0005434777847	34120	102	28J
0005435144953	34120	103	29C
0005434777814	34120	104	28C
0005434777821	34120	105	27J
0005434777905	34120	106	27G
0005434777803	34120	107	25D
0005434777922	34120	108	23F
0005434777917	34120	109	24D
0005434777908	34120	110	23K
0005434777836	34120	111	23G
0005434777804	34120	112	23J
0005434777873	34120	113	32B
0005434777907	34120	114	25A
0005434555387	34120	115	24F
0005432392650	34120	116	22G
0005434777816	34120	117	23E
0005435144957	34120	118	23D
0005432116261	34120	119	32J
0005434777906	34120	120	32H
0005434777831	34120	121	21C
0005432394788	34120	122	35H
0005434777931	34120	123	31H
0005432116251	34120	124	31J
0005434777894	34120	125	21A
0005432392649	34120	126	36B
0005434777885	34120	127	36J
0005434777817	34120	128	36D
0005434777928	34120	129	33D
0005434555393	34120	130	33B
0005434777860	34120	131	33A
0005434777853	34120	132	33C
0005432392647	34120	133	32K
0005434777863	34120	134	32G
0005434555400	34120	135	34B
0005434555394	34120	136	34E
0005434777822	34120	137	33H
0005434777854	34120	138	33F
0005434777808	34120	139	33G
0005434777861	34120	140	22F
0005434777890	34120	141	35C
0005434777849	34120	142	32D
0005434777823	34120	143	32F
0005434777927	34120	144	34H
0005434777916	34120	145	23B
0005432394789	34120	146	23A
0005434777810	34120	147	35B
0005434777912	34120	148	37A
0005434777825	34120	149	35J
0005434555399	34120	150	30K
0005434777867	34120	151	31G
0005434777855	34120	152	21E
0005434777866	34120	153	31E
0005432116259	34120	154	21H
0005434555392	34120	155	34F
0005434777834	34120	156	16C
0005432116258	34120	157	15K
0005434777880	34120	158	16D
0005434777871	34120	159	16H
0005434777875	34120	160	16E
0005434777815	34120	161	12A
0005434777911	34120	162	11E
0005434777837	34120	163	18C
0005432116262	34120	164	15C
0005434777832	34120	165	19J
0005434777920	34120	166	20F
0005434777899	34120	167	4K
0005434777909	34120	168	25K
0005432116255	34120	169	5H
0005434777888	34120	170	20C
0005432116260	34120	171	5K
0005434555397	34120	172	19D
0005432116252	34120	173	19C
0005434555388	34120	174	5C
0005434777872	34120	175	30A
0005432394787	34120	176	11C
0005434777896	34120	177	11D
0005432116250	34120	178	19B
0005434777913	34120	179	18K
0005434777877	34120	180	19F
0005434777833	34120	181	19G
0005432116248	34120	182	15D
0005434777812	34120	183	18J
0005434555391	34120	184	15G
0005434777903	34120	185	17C
0005435733412	64430	1	14A
0005435349777	64430	2	41D
0005435384203	64430	3	26B
0005435349752	64430	4	28J
0005435349778	64430	5	27E
0005435349748	64430	6	30B
0005435349755	64430	7	25F
0005435349788	64430	8	1D
0005435179507	64430	9	13E
0005435733414	64430	10	30F
0005432200453	64430	11	13D
0005432822718	64430	12	29H
0005435349738	64430	13	29F
0005435733411	64430	14	12K
0005435349776	64430	15	5K
0005435349789	64430	16	22H
0005435384202	64430	17	13A
0005435349759	64430	18	31K
0005435349749	64430	19	30K
0005435349728	64430	20	3C
0005435349753	64430	21	3D
0005435349741	64430	22	2D
0005435349742	64430	23	2C
0005435349784	64430	24	5G
0005435384208	64430	25	5D
0005435349763	64430	26	4K
0005435349756	64430	27	31J
0005435349730	64430	28	22K
0005435349757	64430	29	41G
0005435349786	64430	30	27J
0005432200452	64430	31	28D
0005432200454	64430	32	27K
0005435384209	64430	33	28G
0005435349779	64430	34	27F
0005435349775	64430	35	23B
0005435384206	64430	36	25A
0005435660876	64430	37	23F
0005435349790	64430	38	28E
0005435349761	64430	39	46A
0005435349732	64430	40	47D
0005435349751	64430	41	37J
0005435349736	64430	42	37C
0005435660875	64430	43	17K
0005435349782	64430	44	34D
0005435349770	64430	45	18C
0005435349758	64430	46	17H
0005435349727	64430	47	14E
0005435349765	64430	48	14D
0005432822717	64430	49	45H
0005435733415	64430	50	15H
0005435349781	64430	51	15E
0005435349762	64430	52	50H
0005435349746	64430	53	47H
0005435384205	64430	54	45F
0005435349729	64430	55	51G
0005435349731	64430	56	18F
0005435349767	64430	57	17G
0005435349740	64430	58	50E
0005435349772	64430	59	48C
0005435349745	64430	60	50F
0005432200451	64430	61	51D
0005435349734	64430	62	14C
0005435349737	64430	63	39K
0005435349771	64430	64	36F
0005435349785	64430	65	34E
0005435349768	64430	66	39F
0005435349773	64430	67	13F
0005435349743	64430	68	41B
0005435660874	64430	69	41C
0005435349750	64430	70	40H
0005435349764	64430	71	44G
0005435384207	64430	72	42J
0005435349780	64430	73	45E
0005435384204	64430	74	42B
0005435349754	64430	75	42E
0005432200450	64430	76	43C
0005435179124	64430	77	33H
0005435349760	64430	78	21G
0005435349787	64430	79	19G
0005432200448	64430	80	20J
0005435349766	64430	81	19K
0005435349774	64430	82	32B
0005435349744	64430	83	22F
0005435349735	64430	84	22A
0005432200449	64430	85	18G
0005435349783	64430	86	20E
0005432200455	64430	87	21E
0005435349733	64430	88	15C
0005435349769	64430	89	33K
0005435349739	64430	90	37F
0005435733413	64430	91	13H
0005435349747	64430	92	36C
0005435789251	45494	1	20A
0005435079891	45494	2	2B
0005435079894	45494	3	5D
0005435079888	45494	4	19C
0005435079890	45494	5	6B
0005435079897	45494	6	20C
0005435079889	45494	7	23A
0005435079896	45494	8	21D
0005435079893	45494	9	21A
0005435079892	45494	10	20B
0005435789250	45494	11	3A
0005435079895	45494	12	20D
0005434741640	61871	1	15C
0005434741654	61871	2	3C
0005434741646	61871	3	13D
0005434741650	61871	4	13C
0005434741656	61871	5	13E
0005434741630	61871	6	11C
0005434741658	61871	7	15F
0005434741629	61871	8	19E
0005434741633	61871	9	4E
0005434741663	61871	10	19C
0005434741636	61871	11	6F
0005434741639	61871	12	6C
0005434741623	61871	13	20F
0005434741665	61871	14	20E
0005434741647	61871	15	7D
0005434741635	61871	16	12E
0005434741643	61871	17	8E
0005434741625	61871	18	7F
0005434741642	61871	19	9A
0005434741659	61871	20	7C
0005434741652	61871	21	20C
0005434741624	61871	22	4F
0005434741641	61871	23	16C
0005434741660	61871	24	18E
0005434741644	61871	25	18D
0005434741634	61871	26	18F
0005434741638	61871	27	14E
0005434741657	61871	28	10D
0005434741626	61871	29	5C
0005434741651	61871	30	5D
0005434741645	61871	31	2F
0005434741664	61871	32	1C
0005434741632	61871	33	4C
0005434741655	61871	34	14A
0005434741648	61871	35	4D
0005434741662	61871	36	4A
0005434741627	61871	37	6D
0005434741649	61871	38	10E
0005434741661	61871	39	11E
0005434741631	61871	40	12C
0005434741637	61871	41	11A
0005434741628	61871	42	11D
0005434741653	61871	43	10F
0005435099036	70267	1	21C
0005435099037	70267	2	22A
0005435099035	70267	3	20C
0005435099038	70267	4	7D
0005434759307	206579	1	18B
0005434759306	206579	2	20A
0005434629850	13032	1	21D
0005432289518	13032	2	20B
0005434629845	13032	3	18B
0005434629852	13032	4	18A
0005434629864	13032	5	18C
0005434629844	13032	6	5D
0005434629856	13032	7	7B
0005434629859	13032	8	4A
0005434629865	13032	9	4D
0005432289517	13032	10	4C
0005434629855	13032	11	19A
0005434629863	13032	12	19C
0005434629867	13032	13	20D
0005434629848	13032	14	21C
0005434629868	13032	15	22B
0005434629847	13032	16	23B
0005434629846	13032	17	20A
0005434629849	13032	18	3C
0005434629860	13032	19	6C
0005434629854	13032	20	19D
0005434629853	13032	21	3B
0005434629869	13032	22	6B
0005434629851	13032	23	6D
0005434629857	13032	24	1C
0005434629862	13032	25	3A
0005434629866	13032	26	3D
0005434629861	13032	27	1B
0005434629858	13032	28	2B
0005434591105	39437	1	20D
0005434591090	39437	2	20C
0005434591103	39437	3	19E
0005434591114	39437	4	19F
0005434591113	39437	5	18C
0005434591088	39437	6	17E
0005434591099	39437	7	16F
0005434591112	39437	8	15C
0005434591089	39437	9	16D
0005432110200	39437	10	20F
0005433531936	39437	11	20E
0005433529918	39437	12	13C
0005434591109	39437	13	11C
0005434591111	39437	14	11F
0005434591094	39437	15	10F
0005432110199	39437	16	19D
0005434591095	39437	17	18D
0005434591096	39437	18	13F
0005434591108	39437	19	8A
0005433529920	39437	20	5A
0005434591100	39437	21	10D
0005434591101	39437	22	4F
0005433529919	39437	23	15F
0005434591106	39437	24	6C
0005434591093	39437	25	5D
0005434591092	39437	26	8F
0005432110198	39437	27	5F
0005433531935	39437	28	7C
0005434591091	39437	29	9E
0005434591107	39437	30	6E
0005434591097	39437	31	1D
0005434591102	39437	32	6D
0005433531934	39437	33	4C
0005434591104	39437	34	1C
0005433529921	39437	35	3F
0005434591110	39437	36	2A
0005434591098	39437	37	2C
0005435321756	120566	1	7C
0005435321752	120566	2	12F
0005435321759	120566	3	1C
0005435321753	120566	4	2A
0005435321745	120566	5	15A
0005435321747	120566	6	9C
0005435321757	120566	7	16F
0005435321750	120566	8	13E
0005435321746	120566	9	11F
0005435321754	120566	10	5C
0005435321748	120566	11	20A
0005435321749	120566	12	17D
0005435321758	120566	13	12A
0005435321755	120566	14	10E
0005435321751	120566	15	3D
0005434553238	68769	1	4F
0005433171990	179672	1	12D
0005433171996	179672	2	17D
0005433172006	179672	3	19C
0005433172003	179672	4	15F
0005433172005	179672	5	14A
0005433172010	179672	6	6A
0005433171995	179672	7	6C
0005433172002	179672	8	6D
0005433171999	179672	9	6F
0005433172004	179672	10	2A
0005433171998	179672	11	20E
0005433171988	179672	12	20F
0005433171989	179672	13	16D
0005433171993	179672	14	19D
0005433172001	179672	15	12E
0005433172008	179672	16	13F
0005433172000	179672	17	10F
0005433172009	179672	18	10A
0005433171985	179672	19	7D
0005433171997	179672	20	9A
0005433171991	179672	21	12A
0005433171992	179672	22	12C
0005433171986	179672	23	11F
0005433172011	179672	24	10E
0005433171987	179672	25	11D
0005433171994	179672	26	13A
0005433172007	179672	27	13E
0005433457683	39988	1	3A
0005433457679	39988	2	5B
0005433457680	39988	3	2A
0005433457681	39988	4	4B
0005433457682	39988	5	5A
0005435253575	125262	1	4B
0005432134361	43507	1	17C
0005435667650	43507	2	14F
0005435667643	43507	3	16E
0005435667629	43507	4	9E
0005435667621	43507	5	19A
0005435667614	43507	6	9D
0005435667630	43507	7	18F
0005435667620	43507	8	6F
0005435667628	43507	9	12D
0005432134359	43507	10	10C
0005432134362	43507	11	14E
0005435667627	43507	12	10A
0005435667616	43507	13	9C
0005435667613	43507	14	12E
0005435667631	43507	15	17F
0005435667653	43507	16	10D
0005435667622	43507	17	11D
0005432134358	43507	18	13F
0005435667636	43507	19	13A
0005435667635	43507	20	13D
0005435667608	43507	21	11E
0005435667648	43507	22	7F
0005435667611	43507	23	1D
0005435667610	43507	24	18D
0005435667647	43507	25	19C
0005435667618	43507	26	19F
0005435667625	43507	27	19D
0005435667612	43507	28	20C
0005432134357	43507	29	20A
0005435667639	43507	30	17A
0005435667640	43507	31	16D
0005435667638	43507	32	15F
0005435667615	43507	33	16F
0005435667649	43507	34	8C
0005435667617	43507	35	15E
0005435667619	43507	36	15D
0005435667623	43507	37	8D
0005435667633	43507	38	16A
0005435667652	43507	39	17E
0005435667624	43507	40	7E
0005435667642	43507	41	6A
0005435667634	43507	42	9A
0005435667641	43507	43	6D
0005435667651	43507	44	2A
0005435667632	43507	45	14D
0005435667626	43507	46	1F
0005432134356	43507	47	6C
0005435667609	43507	48	2F
0005435667645	43507	49	2C
0005432134360	43507	50	3F
0005435667637	43507	51	5F
0005435667644	43507	52	4F
0005435667646	43507	53	5C
0005432532250	159616	1	6D
0005435429934	159616	2	20F
0005435429944	159616	3	8A
0005435429939	159616	4	20E
0005435429951	159616	5	19F
0005435429942	159616	6	20A
0005435429935	159616	7	2A
0005432532247	159616	8	7F
0005435429940	159616	9	1D
0005435429945	159616	10	2F
0005435429937	159616	11	11D
0005435429941	159616	12	4E
0005434827687	159616	13	11A
0005432532249	159616	14	8C
0005432304855	159616	15	3A
0005432304857	159616	16	10D
0005435429947	159616	17	10F
0005435429955	159616	18	6E
0005435429943	159616	19	6F
0005435429952	159616	20	13C
0005435429954	159616	21	4F
0005434827689	159616	22	5D
0005435429946	159616	23	16C
0005435429948	159616	24	5E
0005435429938	159616	25	14E
0005435429950	159616	26	18E
0005434827688	159616	27	4C
0005435429932	159616	28	5C
0005435429953	159616	29	4A
0005435429936	159616	30	3D
0005435429933	159616	31	18D
0005435429949	159616	32	14F
0005432304856	159616	33	18A
0005432532248	159616	34	17E
0005435104833	74887	1	4A
0005435104832	74887	2	18E
0005435557138	206974	1	14C
0005435557137	206974	2	11F
0005435557136	206974	3	20E
0005433380542	87867	1	12C
0005433380563	87867	2	14A
0005433380520	87867	3	13C
0005433380552	87867	4	15F
0005433380564	87867	5	16E
0005433380528	87867	6	15E
0005433380548	87867	7	16D
0005433380553	87867	8	16F
0005433380570	87867	9	17F
0005433380536	87867	10	19C
0005433380531	87867	11	17D
0005433380539	87867	12	14D
0005433380533	87867	13	19D
0005433380535	87867	14	12E
0005433380550	87867	15	20C
0005433380562	87867	16	20A
0005433380559	87867	17	17A
0005433380521	87867	18	16A
0005433380547	87867	19	19F
0005433380527	87867	20	18D
0005433380567	87867	21	15D
0005433380543	87867	22	6D
0005433380560	87867	23	5E
0005433380569	87867	24	5A
0005433380544	87867	25	4E
0005433380529	87867	26	7F
0005433380556	87867	27	9E
0005433380565	87867	28	8A
0005433380537	87867	29	13D
0005433380558	87867	30	8D
0005433380546	87867	31	11D
0005433380541	87867	32	10A
0005433380557	87867	33	11C
0005433380566	87867	34	8E
0005433380568	87867	35	11F
0005433380540	87867	36	9D
0005433380555	87867	37	12A
0005433380554	87867	38	7C
0005433380523	87867	39	4A
0005433380545	87867	40	1D
0005433380524	87867	41	7E
0005433380538	87867	42	4C
0005433380532	87867	43	6E
0005433380530	87867	44	3F
0005433380551	87867	45	6A
0005433380561	87867	46	4F
0005433380534	87867	47	1A
0005433380549	87867	48	2F
0005433380522	87867	49	3A
0005433380525	87867	50	1F
0005433380526	87867	51	2D
0005432296325	125683	1	7D
0005435727693	125683	2	8C
0005432296327	125683	3	19D
0005435727692	125683	4	11E
0005435727694	125683	5	1F
0005435727696	125683	6	4D
0005432296326	125683	7	12A
0005435727695	125683	8	14F
0005435920731	85290	1	9A
0005435920734	85290	2	9D
0005435920725	85290	3	19C
0005435920727	85290	4	12D
0005435920738	85290	5	4E
0005435920729	85290	6	15F
0005435920723	85290	7	18F
0005435920733	85290	8	13A
0005435920737	85290	9	11A
0005435920730	85290	10	18A
0005435920735	85290	11	18D
0005435920726	85290	12	16C
0005435920736	85290	13	4F
0005435920722	85290	14	4C
0005435920728	85290	15	1D
0005435920721	85290	16	11E
0005435920732	85290	17	3D
0005435920724	85290	18	4A
0005434197768	69437	1	5E
0005434197761	69437	2	18C
0005434197784	69437	3	17F
0005434197762	69437	4	5A
0005434197770	69437	5	16A
0005434197782	69437	6	4E
0005434197765	69437	7	5D
0005434197772	69437	8	15F
0005434197774	69437	9	17D
0005434197780	69437	10	16C
0005434197781	69437	11	9E
0005434197758	69437	12	17C
0005434197778	69437	13	17A
0005434197776	69437	14	9D
0005434197792	69437	15	14E
0005434197760	69437	16	15C
0005434197797	69437	17	14A
0005434197801	69437	18	14C
0005434197777	69437	19	6C
0005434197775	69437	20	6A
0005434197771	69437	21	7E
0005434197799	69437	22	14F
0005434197795	69437	23	7C
0005434197783	69437	24	6D
0005434197764	69437	25	7A
0005434197759	69437	26	6F
0005434197779	69437	27	10E
0005434197763	69437	28	8C
0005434197794	69437	29	10A
0005434197790	69437	30	13D
0005434197787	69437	31	13C
0005434197757	69437	32	11E
0005434197773	69437	33	13A
0005434197800	69437	34	12F
0005434197788	69437	35	12A
0005434197804	69437	36	9A
0005434197791	69437	37	12E
0005434197785	69437	38	16D
0005434197802	69437	39	3C
0005434197798	69437	40	2F
0005434197786	69437	41	19D
0005434197796	69437	42	19C
0005434197769	69437	43	3A
0005434197789	69437	44	19A
0005434197803	69437	45	19F
0005434197767	69437	46	4A
0005434197766	69437	47	16F
0005434197793	69437	48	4D
0005432122785	35525	1	22D
0005435016650	35525	2	20D
0005435016616	35525	3	11D
0005434998663	35525	4	10E
0005435016652	35525	5	13B
0005434998666	35525	6	12D
0005435016624	35525	7	13C
0005435016638	35525	8	13E
0005435016664	35525	9	20B
0005435016629	35525	10	10C
0005432122788	35525	11	4D
0005434998654	35525	12	4B
0005434998665	35525	13	4F
0005435016661	35525	14	16C
0005434998670	35525	15	18F
0005435016668	35525	16	6E
0005435016641	35525	17	19F
0005435016619	35525	18	6A
0005435016617	35525	19	5C
0005432122786	35525	20	6C
0005435016657	35525	21	5D
0005435016639	35525	22	5E
0005435016635	35525	23	19D
0005435016633	35525	24	19B
0005435016620	35525	25	18C
0005434998664	35525	26	18E
0005435016678	35525	27	7C
0005435043046	35525	28	19C
0005435016656	35525	29	18B
0005435016626	35525	30	19A
0005434998656	35525	31	18A
0005432122782	35525	32	19E
0005434998657	35525	33	20C
0005434998675	35525	34	10B
0005435016630	35525	35	16B
0005435016681	35525	36	13F
0005434998658	35525	37	13A
0005435016662	35525	38	11B
0005435016645	35525	39	10D
0005435016634	35525	40	17E
0005435016673	35525	41	12A
0005434998660	35525	42	11C
0005435016622	35525	43	11E
0005434998673	35525	44	12E
0005435016654	35525	45	12C
0005435016676	35525	46	14B
0005434998662	35525	47	17F
0005434998672	35525	48	15E
0005432122787	35525	49	12B
0005435016625	35525	50	14C
0005435016658	35525	51	9F
0005435016643	35525	52	15F
0005434998674	35525	53	13D
0005434998653	35525	54	15C
0005435016618	35525	55	15D
0005435016653	35525	56	16A
0005434998652	35525	57	14A
0005435042031	35525	58	14D
0005435016631	35525	59	15B
0005434998667	35525	60	14E
0005435016621	35525	61	9C
0005435016636	35525	62	8A
0005435016659	35525	63	8E
0005432122784	35525	64	9B
0005434998661	35525	65	14F
0005435016670	35525	66	8F
0005435016669	35525	67	9A
0005435042033	35525	68	8D
0005435016675	35525	69	7F
0005435016640	35525	70	8B
0005435016646	35525	71	8C
0005435016627	35525	72	9D
0005435016644	35525	73	21A
0005435016655	35525	74	2D
0005434998669	35525	75	2A
0005434998651	35525	76	1F
0005432122783	35525	77	7E
0005435016671	35525	78	3F
0005435016667	35525	79	2F
0005434998655	35525	80	4A
0005434998659	35525	81	3D
0005435016649	35525	82	5B
0005435016647	35525	83	7A
0005435016628	35525	84	5A
0005435016679	35525	85	23E
0005435016680	35525	86	22F
0005435042034	35525	87	22E
0005432122781	35525	88	20F
0005435016660	35525	89	21C
0005435042032	35525	90	22A
0005435016677	35525	91	22B
0005435016651	35525	92	22C
0005435016614	35525	93	21E
0005435016615	35525	94	23F
0005435016637	35525	95	23D
0005435016648	35525	96	23C
0005435016632	35525	97	23A
0005435016672	35525	98	23B
0005435016665	35525	99	20E
0005434998671	35525	100	17C
0005435016666	35525	101	1A
0005435016663	35525	102	17B
0005435016642	35525	103	16D
0005434998668	35525	104	16F
0005435016623	35525	105	1D
0005435016674	35525	106	16E
0005434221224	84027	1	3D
0005434221239	84027	2	4D
0005434221219	84027	3	20F
0005432302986	84027	4	20E
0005434221221	84027	5	21A
0005434221237	84027	6	12A
0005432302985	84027	7	4F
0005434221233	84027	8	10D
0005434221234	84027	9	5D
0005434221225	84027	10	14B
0005434221217	84027	11	9A
0005434221235	84027	12	19E
0005434221223	84027	13	8B
0005434221220	84027	14	14D
0005434221227	84027	15	19F
0005434221222	84027	16	21D
0005434221231	84027	17	2F
0005432302988	84027	18	22D
0005434221226	84027	19	13E
0005434221238	84027	20	13F
0005434221230	84027	21	15A
0005432302987	84027	22	23E
0005434221218	84027	23	23B
0005434221228	84027	24	20A
0005434221229	84027	25	19D
0005434221236	84027	26	22E
0005432302989	84027	27	16F
0005434221232	84027	28	17E
0005435896296	130920	1	13F
0005435552456	130920	2	5D
0005435896298	130920	3	6E
0005435896285	130920	4	17E
0005435896280	130920	5	6D
0005435552454	130920	6	18C
0005435552453	130920	7	18D
0005435896283	130920	8	15E
0005435896291	130920	9	19E
0005435896282	130920	10	16D
0005435896290	130920	11	16F
0005435896288	130920	12	17D
0005435896287	130920	13	15A
0005435896281	130920	14	3A
0005435896295	130920	15	5C
0005435896284	130920	16	11A
0005435896294	130920	17	15C
0005435896297	130920	18	13E
0005435552455	130920	19	9C
0005435896293	130920	20	8A
0005432058781	130920	21	6A
0005435896286	130920	22	2A
0005435896292	130920	23	2C
0005435552457	130920	24	6C
0005435896289	130920	25	1F
0005433424547	173246	1	2D
0005433424564	173246	2	1D
0005433424544	173246	3	6C
0005433424552	173246	4	9C
0005433424540	173246	5	7D
0005433424548	173246	6	14D
0005434269456	173246	7	13F
0005434270560	173246	8	15F
0005433424551	173246	9	15A
0005433424553	173246	10	13D
0005433424543	173246	11	15C
0005434269455	173246	12	17D
0005433424539	173246	13	20F
0005433424550	173246	14	20D
0005433424537	173246	15	19F
0005433424556	173246	16	3D
0005433424554	173246	17	17E
0005433424549	173246	18	19E
0005434268352	173246	19	19C
0005433424562	173246	20	18A
0005433424542	173246	21	17C
0005433424559	173246	22	16F
0005433424558	173246	23	13C
0005433424545	173246	24	9A
0005434269457	173246	25	9F
0005433424546	173246	26	12C
0005433424538	173246	27	10A
0005433424557	173246	28	7E
0005433424561	173246	29	10C
0005433424560	173246	30	11F
0005434268353	173246	31	12A
0005434269458	173246	32	11A
0005434270561	173246	33	4F
0005433424563	173246	34	8C
0005433424555	173246	35	7F
0005433424541	173246	36	8D
0005433424565	173246	37	6E
0005432050001	173246	38	5A
0005432050003	173246	39	5D
0005432050002	173246	40	2A
0005434268354	173246	41	1C
0005432574928	20391	1	5D
0005432574935	20391	2	20A
0005432574937	20391	3	5B
0005432215261	20391	4	4C
0005432574927	20391	5	22D
0005432574939	20391	6	4B
0005432574949	20391	7	22A
0005432574944	20391	8	21C
0005432574931	20391	9	1D
0005432574945	20391	10	4A
0005432574934	20391	11	1B
0005432574942	20391	12	1A
0005432574940	20391	13	2A
0005432574951	20391	14	3C
0005432574936	20391	15	3B
0005432574932	20391	16	2B
0005432574948	20391	17	19C
0005432574930	20391	18	7B
0005432215260	20391	19	7C
0005432574952	20391	20	6D
0005432574946	20391	21	6C
0005432574938	20391	22	6A
0005432574943	20391	23	18B
0005432574941	20391	24	18D
0005432215259	20391	25	7D
0005432574933	20391	26	19D
0005432574950	20391	27	20B
0005432574929	20391	28	21B
0005432574947	20391	29	21A
0005432853750	204442	1	21D
0005432853747	204442	2	21B
0005432853759	204442	3	19C
0005432853746	204442	4	20D
0005432853755	204442	5	4C
0005432853752	204442	6	18A
0005432853751	204442	7	22A
0005432853749	204442	8	22D
0005432853757	204442	9	22B
0005432853758	204442	10	6A
0005432853756	204442	11	3A
0005432853748	204442	12	5D
0005432853754	204442	13	5C
0005432853753	204442	14	3C
0005434940008	5821	1	2D
0005434940011	5821	2	23A
0005434940005	5821	3	20A
0005434940010	5821	4	19C
0005434940009	5821	5	18D
0005434940007	5821	6	6C
0005434940004	5821	7	18C
0005434940012	5821	8	19D
0005434940013	5821	9	3B
0005434940006	5821	10	5B
0005433253149	105248	1	22D
0005433253148	105248	2	19D
0005433253146	105248	3	6C
0005433253150	105248	4	3B
0005433253147	105248	5	22B
0005433793171	60780	1	24F
0005432666732	60780	2	1G
0005433771807	60780	3	2F
0005433793148	60780	4	2G
0005433793172	60780	5	2H
0005433771822	60780	6	1A
0005433771809	60780	7	37A
0005433771826	60780	8	36D
0005433771824	60780	9	35A
0005433771800	60780	10	36H
0005433793170	60780	11	1B
0005433771830	60780	12	35G
0005432656326	60780	13	32H
0005433793175	60780	14	33B
0005433757921	60780	15	33E
0005433793163	60780	16	34B
0005432666734	60780	17	33F
0005433771815	60780	18	38F
0005433793153	60780	19	3A
0005433757918	60780	20	34E
0005433757923	60780	21	34F
0005433793144	60780	22	37H
0005432656325	60780	23	34A
0005433757924	60780	24	34G
0005433771819	60780	25	37E
0005433771804	60780	26	24H
0005433793165	60780	27	23A
0005433793166	60780	28	21B
0005433793154	60780	29	21D
0005433771814	60780	30	21G
0005433793168	60780	31	27H
0005433757920	60780	32	22D
0005433793162	60780	33	25E
0005433793151	60780	34	24A
0005433771816	60780	35	4C
0005433793167	60780	36	1C
0005433793149	60780	37	14B
0005433771802	60780	38	3C
0005433771829	60780	39	4G
0005433793155	60780	40	17D
0005432665628	60780	41	2A
0005433771818	60780	42	32G
0005433771803	60780	43	4F
0005433771825	60780	44	3B
0005433771828	60780	45	28D
0005432666733	60780	46	3G
0005433793169	60780	47	12G
0005433757927	60780	48	4B
0005433771831	60780	49	14F
0005432664510	60780	50	12H
0005433771827	60780	51	17A
0005433793147	60780	52	13A
0005433771813	60780	53	13H
0005433793159	60780	54	9A
0005433757928	60780	55	15D
0005433771806	60780	56	11B
0005433771817	60780	57	11G
0005433793152	60780	58	12F
0005433793145	60780	59	14G
0005433793158	60780	60	11D
0005433757919	60780	61	16G
0005433757922	60780	62	9H
0005433793157	60780	63	21A
0005432665630	60780	64	20G
0005433771823	60780	65	15F
0005433793174	60780	66	28B
0005433793156	60780	67	16E
0005433793164	60780	68	15B
0005433793161	60780	69	20H
0005433771799	60780	70	18H
0005433771811	60780	71	19D
0005433771801	60780	72	20D
0005433771805	60780	73	18E
0005433793160	60780	74	28A
0005433757917	60780	75	20E
0005433771810	60780	76	20F
0005433757926	60780	77	24D
0005432664509	60780	78	22G
0005433771812	60780	79	31F
0005433771820	60780	80	24E
0005433757925	60780	81	32B
0005433771832	60780	82	27D
0005433757916	60780	83	30H
0005433793150	60780	84	30B
0005433771798	60780	85	30D
0005433793146	60780	86	31D
0005432665629	60780	87	32E
0005433793173	60780	88	30F
0005433771808	60780	89	31G
0005433771821	60780	90	28E
0005433757929	60780	91	31H
0005434165874	170255	1	38H
0005434165875	170255	2	12H
0005434165877	170255	3	3B
0005434165887	170255	4	18H
0005434165876	170255	5	14A
0005434165883	170255	6	23E
0005434165880	170255	7	19B
0005434165884	170255	8	28G
0005434165885	170255	9	33G
0005434165886	170255	10	37F
0005434165882	170255	11	11H
0005434165881	170255	12	11F
0005434165879	170255	13	4F
0005434165878	170255	14	5H
0005435133890	31829	1	21D
0005435133889	31829	2	7C
0005435133888	31829	3	2C
0005435133886	31829	4	18A
0005435133887	31829	5	1B
0005435928670	214279	1	18A
0005435928667	214279	2	22B
0005435928669	214279	3	19C
0005435928668	214279	4	4A
0005434981401	61531	1	21D
0005434981405	61531	2	20C
0005434981404	61531	3	5B
0005434981403	61531	4	4C
0005434981406	61531	5	2C
0005434981402	61531	6	1A
0005434216483	177378	1	18A
0005434216482	177378	2	7C
0005434216484	177378	3	7B
0005434216481	177378	4	19D
0005434471289	6111	1	21A
0005434471305	6111	2	23B
0005434471302	6111	3	21D
0005434471304	6111	4	20A
0005434471290	6111	5	21C
0005434471306	6111	6	23A
0005434471294	6111	7	22C
0005434471303	6111	8	19C
0005434471311	6111	9	19B
0005434471286	6111	10	19A
0005434471292	6111	11	21B
0005434471297	6111	12	19D
0005434471298	6111	13	18D
0005434471291	6111	14	6B
0005434471296	6111	15	3C
0005434471308	6111	16	6D
0005432268479	6111	17	18B
0005432268481	6111	18	3B
0005434471293	6111	19	5D
0005434471287	6111	20	7A
0005434471288	6111	21	5A
0005434471295	6111	22	1A
0005434471310	6111	23	4B
0005432268480	6111	24	4A
0005434471300	6111	25	3A
0005434471299	6111	26	2D
0005434471309	6111	27	4C
0005434471301	6111	28	2A
0005434471307	6111	29	1D
0005433161186	107483	1	5A
0005433161194	107483	2	4D
0005433161189	107483	3	21D
0005433161193	107483	4	22C
0005433161198	107483	5	20A
0005433161195	107483	6	18D
0005433161191	107483	7	6B
0005433161192	107483	8	6D
0005433161196	107483	9	23B
0005433161187	107483	10	1A
0005433161197	107483	11	5B
0005433161190	107483	12	3D
0005433161188	107483	13	2D
0005433287241	142415	1	5D
0005435384204	142415	2	21B
0005433287235	142415	3	22B
0005433287240	142415	4	3D
0005435384207	142415	5	7D
0005435384203	142415	6	22C
0005433287236	142415	7	5C
0005433287237	142415	8	1D
0005435384206	142415	9	1A
0005435384208	142415	10	19B
0005435384202	142415	11	19A
0005433287238	142415	12	23B
0005433287234	142415	13	3C
0005433287239	142415	14	19C
0005435384209	142415	15	6B
0005435384205	142415	16	2C
0005435316385	135645	1	16E
0005435316376	135645	2	11D
0005435316379	135645	3	7D
0005435316378	135645	4	6F
0005435316383	135645	5	3D
0005435316377	135645	6	18F
0005435316380	135645	7	12F
0005435316384	135645	8	6A
0005435316382	135645	9	19A
0005435316381	135645	10	14C
0005432697520	19042	1	9F
0005432216749	19042	2	15E
0005432697539	19042	3	10C
0005432697542	19042	4	15C
0005432697530	19042	5	14C
0005432216748	19042	6	18A
0005432697522	19042	7	9D
0005432697527	19042	8	18F
0005432697525	19042	9	16F
0005432697534	19042	10	14D
0005432697533	19042	11	17D
0005432697526	19042	12	12C
0005432697536	19042	13	19A
0005432697524	19042	14	8A
0005432697532	19042	15	8E
0005432697541	19042	16	13E
0005432697528	19042	17	11A
0005432697531	19042	18	12F
0005432697540	19042	19	7F
0005432697537	19042	20	19E
0005432697538	19042	21	4A
0005432697529	19042	22	1A
0005432697535	19042	23	7E
0005432697519	19042	24	3A
0005432697523	19042	25	1C
0005432697521	19042	26	5E
0005432216747	19042	27	2A
0005432681983	194450	1	4E
0005432875543	194450	2	3C
0005432875533	194450	3	3A
0005432681980	194450	4	19E
0005432681959	194450	5	4D
0005432875536	194450	6	16E
0005432681968	194450	7	16D
0005432681976	194450	8	20D
0005432681965	194450	9	4C
0005432875531	194450	10	18E
0005432875538	194450	11	19D
0005432681975	194450	12	1D
0005432875544	194450	13	1A
0005432681979	194450	14	18A
0005432681960	194450	15	17E
0005432875530	194450	16	18D
0005432681972	194450	17	14E
0005432681955	194450	18	15F
0005432681978	194450	19	18C
0005432681961	194450	20	12A
0005432875532	194450	21	11F
0005432681973	194450	22	7C
0005432681981	194450	23	5E
0005432875542	194450	24	13E
0005432875534	194450	25	13C
0005432875540	194450	26	13D
0005432681974	194450	27	5A
0005432875539	194450	28	5C
0005432681966	194450	29	13F
0005432681971	194450	30	8A
0005432681956	194450	31	7F
0005432681969	194450	32	8E
0005432681963	194450	33	7D
0005432681970	194450	34	8F
0005432681985	194450	35	11D
0005432681967	194450	36	6F
0005432681982	194450	37	8C
0005432681962	194450	38	11A
0005432875535	194450	39	6C
0005432875537	194450	40	13A
0005432681957	194450	41	12F
0005432875541	194450	42	12E
0005432681984	194450	43	10F
0005432875545	194450	44	9D
0005432681958	194450	45	10C
0005432681977	194450	46	10A
0005432681964	194450	47	7A
0005433112733	127267	1	7D
0005433112734	127267	2	21C
0005435050486	23063	1	19E
0005435050465	23063	2	4E
0005435050505	23063	3	20D
0005435050491	23063	4	20E
0005435716801	23063	5	3F
0005435050482	23063	6	5D
0005435050493	23063	7	2F
0005435050506	23063	8	11E
0005435050500	23063	9	11C
0005435050469	23063	10	11A
0005435050495	23063	11	11F
0005435050496	23063	12	12E
0005435050467	23063	13	13F
0005435050478	23063	14	12D
0005435050461	23063	15	2D
0005435716799	23063	16	6F
0005435050480	23063	17	13E
0005435050462	23063	18	1D
0005435050484	23063	19	13A
0005435050510	23063	20	20F
0005435050471	23063	21	10F
0005435050481	23063	22	17A
0005435716805	23063	23	13D
0005435050488	23063	24	7C
0005435050466	23063	25	1A
0005435050483	23063	26	12C
0005435050479	23063	27	8E
0005435050509	23063	28	9A
0005435050498	23063	29	1C
0005435050468	23063	30	10D
0005435050497	23063	31	9D
0005435050472	23063	32	9F
0005435050492	23063	33	9E
0005435050475	23063	34	5F
0005435716802	23063	35	7F
0005435050485	23063	36	9C
0005435050463	23063	37	7E
0005435050474	23063	38	1F
0005435050490	23063	39	2C
0005435050464	23063	40	7D
0005435050470	23063	41	8C
0005435050494	23063	42	6D
0005435716804	23063	43	17C
0005435050477	23063	44	4F
0005435716798	23063	45	5E
0005435050502	23063	46	3D
0005435050473	23063	47	20C
0005435716803	23063	48	18A
0005435050501	23063	49	19F
0005435050511	23063	50	14D
0005435050489	23063	51	18C
0005435050476	23063	52	15D
0005435050487	23063	53	19A
0005435050503	23063	54	15E
0005435050504	23063	55	15A
0005435050508	23063	56	16F
0005435050507	23063	57	16C
0005435050499	23063	58	14F
0005435716800	23063	59	14E
0005435920733	99253	1	15A
0005435920730	99253	2	18C
0005435939236	99253	3	11A
0005435920734	99253	4	8D
0005435920722	99253	5	13C
0005435920731	99253	6	14A
0005435920728	99253	7	7D
0005435920729	99253	8	13F
0005435920737	99253	9	12C
0005435920723	99253	10	18E
0005435939237	99253	11	11D
0005435920726	99253	12	10F
0005435920727	99253	13	1C
0005435920735	99253	14	19C
0005435920738	99253	15	6A
0005435920724	99253	16	6F
0005435920721	99253	17	4F
0005435920725	99253	18	3F
0005435920736	99253	19	2D
0005435920732	99253	20	16D
0005432156772	886	1	22C
0005432245463	882	1	7F
0005432245449	882	2	29A
0005432245447	882	3	21A
0005432245436	882	4	20E
0005432245453	882	5	20D
0005432245446	882	6	13B
0005432806760	882	7	21F
0005432245472	882	8	28B
0005432245460	882	9	11C
0005432287797	882	10	4C
0005432806759	882	11	28D
0005432806776	882	12	28E
0005432245431	882	13	19C
0005432806768	882	14	20C
0005432245469	882	15	25B
0005432806777	882	16	21C
0005432245461	882	17	1A
0005432806758	882	18	1C
0005432806765	882	19	23E
0005432806763	882	20	29C
0005432245433	882	21	23C
0005432245451	882	22	22B
0005432245438	882	23	22C
0005432245467	882	24	24E
0005432245448	882	25	24D
0005432806752	882	26	22F
0005432245470	882	27	28A
0005432245455	882	28	23F
0005432245450	882	29	7A
0005432806762	882	30	7D
0005432806764	882	31	25D
0005432245437	882	32	26A
0005432245452	882	33	26F
0005432245439	882	34	27B
0005432806761	882	35	29B
0005432245464	882	36	26B
0005432245454	882	37	1F
0005432806756	882	38	3C
0005432806757	882	39	11B
0005432245445	882	40	3F
0005432245473	882	41	3A
0005432806775	882	42	2C
0005432806772	882	43	6F
0005432245432	882	44	2F
0005432245442	882	45	6A
0005432287796	882	46	13C
0005432806769	882	47	10E
0005432245435	882	48	11F
0005432245468	882	49	6C
0005432245441	882	50	15A
0005432245444	882	51	18E
0005432806778	882	52	8A
0005432806771	882	53	14C
0005432245474	882	54	14F
0005432806754	882	55	10A
0005432245429	882	56	14A
0005432245430	882	57	10B
0005432245471	882	58	8F
0005432245443	882	59	8D
0005432806753	882	60	9A
0005432806755	882	61	12A
0005432245459	882	62	30C
0005432806766	882	63	16F
0005432806770	882	64	15F
0005432245462	882	65	14D
0005432806751	882	66	31A
0005432806774	882	67	17D
0005432245457	882	68	15D
0005432245466	882	69	30E
0005432245440	882	70	31E
0005432245458	882	71	29E
0005432245434	882	72	18C
0005432245456	882	73	30A
0005432245465	882	74	12D
0005432806773	882	75	16B
0005432245428	882	76	17B
0005432806767	882	77	18B
0005432806779	882	78	17E
0005433083088	51617	1	18A
0005433083089	51617	2	18E
0005432010574	51617	3	14A
0005432752095	51617	4	15A
0005433083069	51617	5	14D
0005432010577	51617	6	17D
0005433083055	51617	7	13F
0005433083053	51617	8	13E
0005433083092	51617	9	16D
0005433083054	51617	10	15F
0005433083061	51617	11	15E
0005433083101	51617	12	16C
0005433083079	51617	13	17F
0005433083063	51617	14	17E
0005432390908	51617	15	19C
0005432010572	51617	16	19B
0005433083058	51617	17	18C
0005432010571	51617	18	19D
0005432390906	51617	19	31E
0005432010568	51617	20	31D
0005433083096	51617	21	31F
0005432750320	51617	22	30E
0005433083091	51617	23	14B
0005432010591	51617	24	6F
0005432676143	51617	25	7A
0005432044887	51617	26	4C
0005432010565	51617	27	2C
0005432010587	51617	28	4D
0005433083065	51617	29	13B
0005433083076	51617	30	31C
0005433083052	51617	31	6A
0005433083050	51617	32	1A
0005433083074	51617	33	1D
0005432010583	51617	34	1F
0005432010586	51617	35	16F
0005432010579	51617	36	3F
0005432010584	51617	37	2A
0005432676142	51617	38	3C
0005432010582	51617	39	2F
0005432010570	51617	40	4A
0005433083083	51617	41	15D
0005432010585	51617	42	16A
0005433083077	51617	43	16E
0005433083078	51617	44	5F
0005432010576	51617	45	12E
0005432010578	51617	46	9D
0005433083086	51617	47	11E
0005433083066	51617	48	13D
0005433083099	51617	49	15C
0005433083051	51617	50	11F
0005432752093	51617	51	9E
0005432010567	51617	52	30F
0005433083080	51617	53	12A
0005432390907	51617	54	11C
0005433083056	51617	55	7C
0005432043523	51617	56	11B
0005433083071	51617	57	6C
0005433083085	51617	58	12D
0005432043521	51617	59	7F
0005433083100	51617	60	8F
0005433083094	51617	61	8E
0005433083097	51617	62	10E
0005432752094	51617	63	9F
0005433083082	51617	64	11A
0005433083072	51617	65	10C
0005433083070	51617	66	30C
0005432010575	51617	67	29D
0005432010589	51617	68	30A
0005432010588	51617	69	28F
0005432044889	51617	70	27A
0005433083057	51617	71	29A
0005433083090	51617	72	25B
0005433083093	51617	73	27C
0005432010581	51617	74	24C
0005432676141	51617	75	26D
0005433083062	51617	76	24D
0005433083081	51617	77	26C
0005432010590	51617	78	26A
0005433083087	51617	79	26B
0005433083060	51617	80	28B
0005433083059	51617	81	28A
0005432043522	51617	82	23A
0005432010569	51617	83	26F
0005433083098	51617	84	23C
0005432750319	51617	85	24B
0005433083075	51617	86	25E
0005432676139	51617	87	21A
0005433083064	51617	88	21F
0005432010566	51617	89	20C
0005432044888	51617	90	22B
0005433083067	51617	91	21E
0005433083073	51617	92	22A
0005432676140	51617	93	20F
0005432010573	51617	94	21D
0005433083095	51617	95	28E
0005432010580	51617	96	28C
0005433083084	51617	97	29B
0005432390909	51617	98	31B
0005433083068	51617	99	29C
0005432001357	51618	1	2D
0005432895273	51618	2	1A
0005432895263	51618	3	10D
0005432895268	51618	4	10B
0005432895262	51618	5	28F
0005432895274	51618	6	25F
0005432895260	51618	7	8F
0005432895264	51618	8	9B
0005432001355	51618	9	27B
0005432001356	51618	10	27C
0005432895265	51618	11	28E
0005432895261	51618	12	12D
0005432895258	51618	13	15A
0005432895266	51618	14	12A
0005432895275	51618	15	14A
0005432895267	51618	16	18C
0005432895272	51618	17	23C
0005432895270	51618	18	19E
0005432895269	51618	19	23B
0005432895271	51618	20	16B
0005432895259	51618	21	14C
0005433869927	62552	1	5B
0005434174248	209854	1	2B
0005434174249	209854	2	2A
0005434174247	209854	3	3A
0005434174246	209854	4	4A
0005434844288	22784	1	2H
0005434844318	22784	2	44G
0005435111734	22784	3	44D
0005434844355	22784	4	47D
0005434844319	22784	5	3K
0005435111735	22784	6	5A
0005434415980	22784	7	4D
0005434844368	22784	8	3D
0005434844314	22784	9	4G
0005432789295	22784	10	5C
0005434931104	22784	11	5G
0005432789294	22784	12	5D
0005435111725	22784	13	3G
0005434844328	22784	14	37G
0005435111698	22784	15	2K
0005435111711	22784	16	37F
0005434931097	22784	17	37B
0005434844304	22784	18	37E
0005434415987	22784	19	36K
0005434931105	22784	20	36F
0005434415989	22784	21	36B
0005432789287	22784	22	2C
0005434415988	22784	23	2D
0005434844280	22784	24	36J
0005432789290	22784	25	36H
0005434415990	22784	26	36G
0005432789279	22784	27	37D
0005434415986	22784	28	37C
0005432789303	22784	29	37J
0005435619827	22784	30	37H
0005434844367	22784	31	40B
0005432789284	22784	32	39B
0005434844364	22784	33	39A
0005434844332	22784	34	38C
0005434844289	22784	35	38A
0005435619817	22784	36	38B
0005435111723	22784	37	38H
0005435111708	22784	38	39E
0005434415999	22784	39	40A
0005435619828	22784	40	39C
0005435111729	22784	41	39H
0005434844338	22784	42	49G
0005434844293	22784	43	50H
0005434844286	22784	44	43F
0005432182678	22784	45	39G
0005434844303	22784	46	46A
0005434415994	22784	47	48F
0005435111710	22784	48	46F
0005434931102	22784	49	43C
0005434844274	22784	50	46B
0005434415985	22784	51	45G
0005435619825	22784	52	41F
0005435111706	22784	53	40J
0005434844276	22784	54	40E
0005434844310	22784	55	40F
0005434844330	22784	56	43G
0005432789292	22784	57	43D
0005435619826	22784	58	42C
0005434844295	22784	59	41K
0005434931101	22784	60	47K
0005432789299	22784	61	42F
0005434844350	22784	62	42J
0005434415996	22784	63	45J
0005434844305	22784	64	44E
0005432612387	22784	65	43H
0005435111699	22784	66	44C
0005434844313	22784	67	43K
0005434416002	22784	68	44B
0005434844315	22784	69	45H
0005435111701	22784	70	46G
0005434415983	22784	71	44K
0005434844316	22784	72	44H
0005434931087	22784	73	45D
0005434931100	22784	74	45A
0005432610375	22784	75	45B
0005434844309	22784	76	51G
0005434844320	22784	77	46J
0005432612384	22784	78	41J
0005435111704	22784	79	51D
0005434844291	22784	80	48E
0005434844284	22784	81	43J
0005434415997	22784	82	46K
0005434844361	22784	83	47F
0005432612385	22784	84	40C
0005434844357	22784	85	45E
0005435111727	22784	86	48K
0005434931099	22784	87	50G
0005434844282	22784	88	50E
0005432789302	22784	89	49E
0005432789301	22784	90	49K
0005434931098	22784	91	48C
0005432612388	22784	92	44J
0005432789286	22784	93	41D
0005435111732	22784	94	47E
0005434844324	22784	95	51F
0005435111718	22784	96	46E
0005435619814	22784	97	40D
0005434844299	22784	98	42D
0005434844302	22784	99	30J
0005434415981	22784	100	30K
0005434415979	22784	101	36C
0005434415992	22784	102	34A
0005435111709	22784	103	33F
0005434844360	22784	104	33G
0005434844317	22784	105	50A
0005434844292	22784	106	34D
0005434416003	22784	107	43A
0005432789293	22784	108	34B
0005435111702	22784	109	33K
0005434844359	22784	110	47G
0005435111736	22784	111	31A
0005432789300	22784	112	31D
0005434844345	22784	113	31E
0005434844275	22784	114	31F
0005434844296	22784	115	31G
0005434844344	22784	116	31J
0005435111703	22784	117	32A
0005432789283	22784	118	32B
0005432789280	22784	119	32D
0005435111714	22784	120	42G
0005434844329	22784	121	33D
0005434844351	22784	122	33A
0005434844323	22784	123	32F
0005434415995	22784	124	32G
0005435111712	22784	125	32K
0005435111713	22784	126	32E
0005432610373	22784	127	25D
0005434931089	22784	128	36A
0005432187427	22784	129	18J
0005434844353	22784	130	25H
0005434844349	22784	131	25J
0005434844326	22784	132	25F
0005434931086	22784	133	27C
0005435619820	22784	134	26J
0005435111715	22784	135	30H
0005435111724	22784	136	28A
0005434931103	22784	137	29K
0005435111722	22784	138	30E
0005434931090	22784	139	30F
0005434844331	22784	140	28J
0005434844285	22784	141	29B
0005434844366	22784	142	29H
0005432789278	22784	143	29G
0005435619816	22784	144	27D
0005434931093	22784	145	29A
0005435111730	22784	146	29C
0005434844334	22784	147	29F
0005434844297	22784	148	27H
0005434844333	22784	149	39K
0005434844348	22784	150	27G
0005435111733	22784	151	26H
0005434844298	22784	152	26G
0005434844339	22784	153	26E
0005434416004	22784	154	25K
0005435619822	22784	155	26B
0005434844335	22784	156	26A
0005434844278	22784	157	18K
0005435111720	22784	158	19D
0005434844346	22784	159	19E
0005434415978	22784	160	21J
0005432789291	22784	161	21K
0005432789282	22784	162	20H
0005434844370	22784	163	25A
0005432789296	22784	164	25B
0005432182677	22784	165	23B
0005435111707	22784	166	42E
0005434931094	22784	167	24G
0005435619815	22784	168	22A
0005432789288	22784	169	24F
0005435619819	22784	170	23D
0005434844272	22784	171	23E
0005434844321	22784	172	23K
0005434844343	22784	173	22B
0005434844300	22784	174	22H
0005434931092	22784	175	22J
0005434416000	22784	176	22K
0005432789289	22784	177	22G
0005434931096	22784	178	22D
0005434844325	22784	179	22E
0005432610374	22784	180	40G
0005434844294	22784	181	20K
0005434844362	22784	182	21C
0005434844354	22784	183	21E
0005435111716	22784	184	21H
0005434415977	22784	185	21F
0005435619821	22784	186	20J
0005435111717	22784	187	20C
0005434844363	22784	188	49F
0005432789285	22784	189	20G
0005434415984	22784	190	20D
0005434415993	22784	191	20F
0005435111728	22784	192	19F
0005434844279	22784	193	19G
0005432789298	22784	194	20B
0005434844308	22784	195	19H
0005434844342	22784	196	19J
0005434931095	22784	197	12F
0005435111719	22784	198	12E
0005435111721	22784	199	12H
0005434415991	22784	200	39J
0005432789275	22784	201	17E
0005435619818	22784	202	17F
0005434844322	22784	203	17G
0005435619824	22784	204	18D
0005432789297	22784	205	18E
0005434844281	22784	206	18G
0005434844336	22784	207	17H
0005434844356	22784	208	18C
0005434415976	22784	209	18B
0005432789276	22784	210	18A
0005434844287	22784	211	13K
0005435111737	22784	212	13F
0005434415982	22784	213	17C
0005434844301	22784	214	17D
0005434844306	22784	215	47H
0005434844337	22784	216	16A
0005435111726	22784	217	16H
0005434844273	22784	218	14D
0005434844327	22784	219	16G
0005434844290	22784	220	16C
0005435111705	22784	221	15D
0005434844352	22784	222	15G
0005435619823	22784	223	15E
0005434844277	22784	224	15F
0005434844365	22784	225	13G
0005432187428	22784	226	12C
0005434415975	22784	227	50D
0005434415998	22784	228	11G
0005434844283	22784	229	11H
0005434844340	22784	230	43E
0005432612386	22784	231	11K
0005434931091	22784	232	11F
0005434844358	22784	233	35H
0005434844307	22784	234	35G
0005435111700	22784	235	35F
0005434844347	22784	236	35E
0005434844369	22784	237	35D
0005432789281	22784	238	35B
0005435111697	22784	239	34K
0005434844312	22784	240	34J
0005434844341	22784	241	5H
0005434844311	22784	242	11D
0005434416001	22784	243	2A
0005434931088	22784	244	11E
0005432789277	22784	245	1A
0005435111731	22784	246	1K
0005435841993	94626	1	19B
0005435896294	94626	2	35D
0005435896280	94626	3	39D
0005435841994	94626	4	41B
0005435896291	94626	5	28J
0005435896285	94626	6	31F
0005435896282	94626	7	27C
0005435896293	94626	8	3G
0005435896297	94626	9	18K
0005435896298	94626	10	11G
0005435896289	94626	11	4H
0005435896281	94626	12	17C
0005435896290	94626	13	12E
0005435896288	94626	14	38H
0005435896284	94626	15	42C
0005435896292	94626	16	43C
0005435841593	94626	17	37B
0005435896295	94626	18	32D
0005435896283	94626	19	33C
0005432058781	94626	20	22D
0005435896296	94626	21	25E
0005435896287	94626	22	23H
0005435896286	94626	23	19F
0005434321477	23643	1	5A
0005434321480	23643	2	22C
0005434321475	23643	3	23A
0005434321479	23643	4	20B
0005434321471	23643	5	23B
0005434321478	23643	6	19B
0005434321474	23643	7	4C
0005434321481	23643	8	18D
0005434321476	23643	9	18C
0005434321472	23643	10	4D
0005434321470	23643	11	3C
0005434321473	23643	12	2D
0005435887715	101156	1	5A
0005435887714	101156	2	3D
0005435887716	101156	3	2C
0005435887718	101156	4	22D
0005435887713	101156	5	19C
0005435887717	101156	6	6C
0005435952396	4147	1	5A
0005435952388	4147	2	4D
0005435952395	4147	3	5C
0005435952391	4147	4	18C
0005435952385	4147	5	20B
0005435952383	4147	6	22A
0005435952389	4147	7	20C
0005435952382	4147	8	7C
0005435952394	4147	9	18B
0005435952393	4147	10	18A
0005435952386	4147	11	6C
0005435952392	4147	12	21B
0005435952387	4147	13	22B
0005435952390	4147	14	23B
0005435952384	4147	15	1D
0005433417317	98658	1	22A
0005433417316	98658	2	21A
0005433417318	98658	3	23B
0005433417319	98658	4	3D
0005433417322	98658	5	3C
0005433417323	98658	6	1C
0005433417320	98658	7	6A
0005433417321	98658	8	2A
0005434246209	103952	1	4A
0005434246210	103952	2	1B
0005435792375	18347	1	14E
0005435792377	18347	2	15C
0005435792387	18347	3	11E
0005435792381	18347	4	18A
0005435792379	18347	5	11C
0005435792386	18347	6	16F
0005435792385	18347	7	20A
0005435792388	18347	8	1C
0005435792380	18347	9	5A
0005435792376	18347	10	8D
0005435792373	18347	11	10E
0005435792384	18347	12	10D
0005435792383	18347	13	3C
0005435792374	18347	14	15F
0005435792378	18347	15	4D
0005435792382	18347	16	5E
0005433402113	190291	1	9A
0005433402114	190291	2	1D
0005433402110	190291	3	20F
0005433402115	190291	4	16D
0005433402109	190291	5	4D
0005433402112	190291	6	10A
0005433402111	190291	7	5C
0005434944833	37942	1	5B
0005434944830	37942	2	5A
0005434944836	37942	3	4B
0005434944829	37942	4	2A
0005434944834	37942	5	3B
0005434944828	37942	6	2B
0005434944831	37942	7	6A
0005434944832	37942	8	6B
0005434944835	37942	9	1A
0005435375531	105956	1	1A
0005435375530	105956	2	2B
0005435375527	105956	3	4A
0005435375532	105956	4	5B
0005435375529	105956	5	5A
0005435375528	105956	6	2A
0005433939826	44449	1	10A
0005433939838	44449	2	9F
0005433939835	44449	3	4F
0005433939800	44449	4	9C
0005433939844	44449	5	4E
0005433939830	44449	6	4A
0005433939829	44449	7	5C
0005433939845	44449	8	5D
0005433939801	44449	9	14A
0005433939813	44449	10	17F
0005433939824	44449	11	5E
0005433939818	44449	12	1A
0005433939799	44449	13	3C
0005433939837	44449	14	6C
0005433939828	44449	15	8C
0005433939827	44449	16	5F
0005433939811	44449	17	20D
0005433939814	44449	18	8D
0005433939804	44449	19	7F
0005433939808	44449	20	8E
0005433939810	44449	21	6F
