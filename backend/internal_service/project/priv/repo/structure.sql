--
-- PostgreSQL database dump
--

\restrict ly6O8zjfeDkF9SeFFG8SP3nhoCXJF2wk3Qr2bF4weJsKaRhABNiQTKQug5bHs0h

-- Dumped from database version 16.11 (Ubuntu 16.11-0ubuntu0.24.04.1)
-- Dumped by pg_dump version 16.11 (Ubuntu 16.11-0ubuntu0.24.04.1)

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
-- Name: event_store; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA event_store;


--
-- Name: saf_transactions; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA saf_transactions;


--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: account_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.account_status AS ENUM (
    'active',
    'inactive',
    'banned'
);


--
-- Name: actions; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.actions AS ENUM (
    'purchase',
    'funding',
    'profits',
    'losses'
);


--
-- Name: kyclevel; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.kyclevel AS ENUM (
    'standard',
    'advanced',
    'pro'
);


--
-- Name: kycstatus; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.kycstatus AS ENUM (
    'registered',
    'pending',
    'rejected',
    'not_available'
);


--
-- Name: wallet_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.wallet_status AS ENUM (
    'active',
    'inactive',
    'banned'
);


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: fundingtable; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.fundingtable (
    localuserid uuid NOT NULL,
    globaluserid uuid NOT NULL,
    amount_cont integer NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp(0) without time zone
);


--
-- Name: userstable; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.userstable (
    localuserid uuid NOT NULL,
    globaluserid uuid NOT NULL,
    fullname character varying(255) NOT NULL,
    phonenumber character varying(255) NOT NULL,
    kycstatus public.kycstatus DEFAULT 'not_available'::public.kycstatus NOT NULL,
    kyclevel public.kyclevel DEFAULT 'standard'::public.kyclevel NOT NULL,
    transactionlimit integer NOT NULL,
    accountstatus public.account_status DEFAULT 'active'::public.account_status NOT NULL,
    hasacceptedterms boolean DEFAULT false NOT NULL,
    username character varying(255) NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: saf_trans_table; Type: TABLE; Schema: saf_transactions; Owner: -
--

CREATE TABLE saf_transactions.saf_trans_table (
    "MerchantRequestID" text NOT NULL,
    "CheckoutRequestID" text NOT NULL,
    "ResultCode" integer NOT NULL,
    "ReceiptNumber" text NOT NULL,
    "TransactionDate" text NOT NULL,
    "PhoneNumber" text NOT NULL
);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: userstable userstable_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.userstable
    ADD CONSTRAINT userstable_pkey PRIMARY KEY (localuserid);


--
-- Name: saf_trans_table saf_trans_table_pkey; Type: CONSTRAINT; Schema: saf_transactions; Owner: -
--

ALTER TABLE ONLY saf_transactions.saf_trans_table
    ADD CONSTRAINT saf_trans_table_pkey PRIMARY KEY ("MerchantRequestID", "CheckoutRequestID", "ResultCode", "ReceiptNumber");


--
-- Name: fundingtable_localuserid_globaluserid_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fundingtable_localuserid_globaluserid_index ON public.fundingtable USING btree (localuserid, globaluserid);


--
-- Name: userstable_globaluserid_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX userstable_globaluserid_index ON public.userstable USING btree (globaluserid);


--
-- PostgreSQL database dump complete
--

\unrestrict ly6O8zjfeDkF9SeFFG8SP3nhoCXJF2wk3Qr2bF4weJsKaRhABNiQTKQug5bHs0h

INSERT INTO public."schema_migrations" (version) VALUES (20251029112152);
INSERT INTO public."schema_migrations" (version) VALUES (20251029120934);
INSERT INTO public."schema_migrations" (version) VALUES (20251110070847);
INSERT INTO public."schema_migrations" (version) VALUES (20251110072137);
