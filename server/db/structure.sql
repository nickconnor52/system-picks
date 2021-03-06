SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: local_schedules; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.local_schedules (
    id integer NOT NULL
);


--
-- Name: local_schedules_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.local_schedules_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: local_schedules_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.local_schedules_id_seq OWNED BY public.local_schedules.id;


--
-- Name: local_stats; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.local_stats (
    id integer NOT NULL
);


--
-- Name: local_stats_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.local_stats_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: local_stats_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.local_stats_id_seq OWNED BY public.local_stats.id;


--
-- Name: matchup_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.matchup_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: matchups; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.matchups (
    matchup_id text DEFAULT nextval('public.matchup_id_seq'::regclass) NOT NULL,
    away_team_id text,
    correct_pick text,
    date text,
    home_team_id text,
    note text,
    away_team_score text,
    home_team_score text,
    season integer,
    system_spread text,
    "time" text,
    vegas_spread text,
    week integer,
    spread_history text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    deleted_at timestamp without time zone,
    custom_weight text DEFAULT '0'::text
);


--
-- Name: schedules; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schedules (
    schedule_id text NOT NULL,
    away_team_abbreviation text,
    away_team_city text,
    away_team_api_id integer,
    away_team_name text,
    date text,
    delayed_or_postponed_reason text,
    home_team_abbreviation text,
    home_team_city text,
    home_team_api_id integer,
    home_team_name text,
    api_id integer,
    location text,
    original_date text,
    original_time text,
    schedule_status text,
    season integer,
    "time" text,
    week integer
);


--
-- Name: schedule_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.schedule_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: schedule_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.schedule_id_seq OWNED BY public.schedules.schedule_id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: stat_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.stat_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: stats; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.stats (
    stat_id text DEFAULT nextval('public.stat_id_seq'::regclass) NOT NULL,
    def_3rd_pct double precision,
    "def_LOS_drive" double precision,
    def_pass_yds_game double precision,
    def_pts_game double precision,
    def_pts_rz double precision,
    "def_RZA_game" double precision,
    def_rush_yds_game double precision,
    give_take_diff integer,
    off_3rd_pct double precision,
    "off_LOS_drive" double precision,
    off_pass_yds_game double precision,
    off_pts_game double precision,
    off_pts_rz double precision,
    "off_RZA_game" double precision,
    off_rush_yds_game double precision,
    season integer,
    team_id text NOT NULL,
    week integer
);


--
-- Name: team_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.team_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: teams; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.teams (
    team_id text DEFAULT nextval('public.team_id_seq'::regclass) NOT NULL,
    bye_week integer,
    home_field_advantage double precision,
    location text,
    name text,
    nickname text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    email character varying NOT NULL,
    password_digest character varying NOT NULL,
    admin boolean DEFAULT false
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: local_schedules id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.local_schedules ALTER COLUMN id SET DEFAULT nextval('public.local_schedules_id_seq'::regclass);


--
-- Name: local_stats id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.local_stats ALTER COLUMN id SET DEFAULT nextval('public.local_stats_id_seq'::regclass);


--
-- Name: schedules schedule_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schedules ALTER COLUMN schedule_id SET DEFAULT nextval('public.schedule_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: local_schedules local_schedules_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.local_schedules
    ADD CONSTRAINT local_schedules_pkey PRIMARY KEY (id);


--
-- Name: local_stats local_stats_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.local_stats
    ADD CONSTRAINT local_stats_pkey PRIMARY KEY (id);


--
-- Name: schedules schedules_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schedules
    ADD CONSTRAINT schedules_pkey PRIMARY KEY (schedule_id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: stats stats_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stats
    ADD CONSTRAINT stats_pkey PRIMARY KEY (stat_id);


--
-- Name: matchups systemdb.matchups_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.matchups
    ADD CONSTRAINT "systemdb.matchups_pkey" PRIMARY KEY (matchup_id);


--
-- Name: teams teams_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.teams
    ADD CONSTRAINT teams_pkey PRIMARY KEY (team_id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: matchups matchups_away_team_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.matchups
    ADD CONSTRAINT matchups_away_team_fkey FOREIGN KEY (away_team_id) REFERENCES public.teams(team_id);


--
-- Name: matchups matchups_home_team_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.matchups
    ADD CONSTRAINT matchups_home_team_fkey FOREIGN KEY (home_team_id) REFERENCES public.teams(team_id);


--
-- Name: stats stats_team_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stats
    ADD CONSTRAINT stats_team_fkey FOREIGN KEY (team_id) REFERENCES public.teams(team_id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20190512003048'),
('20190512033324'),
('20190512040124'),
('20190803030439'),
('20190803055015'),
('20190803063325'),
('20190808023545'),
('20190809022644'),
('20190818025624'),
('20190823151327'),
('20190905015000'),
('20190905025621'),
('20190905025708'),
('20190905210425');


