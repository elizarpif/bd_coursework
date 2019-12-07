-- Diff code generated with pgModeler (PostgreSQL Database Modeler)
-- pgModeler version: 0.9.2-beta1
-- Diff date: 2019-12-07 22:16:14
-- Source model: pension_db
-- Database: pension_db
-- PostgreSQL version: 11.0

-- [ Diff summary ]
-- Dropped objects: 7
-- Created objects: 1
-- Changed objects: 2
-- Truncated tables: 0

SET search_path=public,pg_catalog;
-- ddl-end --


-- [ Dropped objects ] --
DROP FUNCTION IF EXISTS public.info_retiree(IN character varying,IN character varying,IN character varying) CASCADE;
-- ddl-end --
DROP TRIGGER IF EXISTS update_sum ON public.result_summas CASCADE;
-- ddl-end --
DROP FUNCTION IF EXISTS public.set_update_sum() CASCADE;
-- ddl-end --
DROP TRIGGER IF EXISTS insert_sum ON public.result_summas CASCADE;
-- ddl-end --
DROP FUNCTION IF EXISTS public.set_insert_sum() CASCADE;
-- ddl-end --
DROP EXTENSION IF EXISTS "uuid-ossp" CASCADE;
-- ddl-end --
DROP TABLE IF EXISTS public.migrations CASCADE;
-- ddl-end --


-- [ Created objects ] --
-- object: place_of_work | type: COLUMN --
-- ALTER TABLE public.work_experience DROP COLUMN IF EXISTS place_of_work CASCADE;
ALTER TABLE public.work_experience ADD COLUMN place_of_work varchar(128);
-- ddl-end --

COMMENT ON COLUMN public.work_experience.place_of_work IS 'Место работы';
-- ddl-end --




-- [ Changed objects ] --
ALTER ROLE pension_dba
	NOLOGIN
	UNENCRYPTED PASSWORD '12345';
-- ddl-end --
ALTER ROLE pension_db
	NOLOGIN
	UNENCRYPTED PASSWORD '12345';
-- ddl-end --
