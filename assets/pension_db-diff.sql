-- Diff code generated with pgModeler (PostgreSQL Database Modeler)
-- pgModeler version: 0.9.2-beta1
-- Diff date: 2019-12-13 05:58:05
-- Source model: pension_db
-- Database: pension_db
-- PostgreSQL version: 11.0

-- [ Diff summary ]
-- Dropped objects: 16
-- Created objects: 15
-- Changed objects: 7
-- Truncated tables: 0

SET search_path=public,pg_catalog,moderator;
-- ddl-end --


-- [ Dropped objects ] --
ALTER TABLE public.result_summas DROP CONSTRAINT IF EXISTS retirees_fkey CASCADE;
-- ddl-end --
ALTER TABLE public.work_experience DROP CONSTRAINT IF EXISTS retiress_fkey CASCADE;
-- ddl-end --
ALTER TABLE public.retirees_pensions DROP CONSTRAINT IF EXISTS retirees_fkey CASCADE;
-- ddl-end --
ALTER TABLE public.retirees_pensions DROP CONSTRAINT IF EXISTS pensions_fkey CASCADE;
-- ddl-end --
ALTER TABLE public.pensions DROP CONSTRAINT IF EXISTS pension_type_fkey CASCADE;
-- ddl-end --
DROP FUNCTION IF EXISTS public.info_about_pensions(IN character varying) CASCADE;
-- ddl-end --
DROP FUNCTION IF EXISTS public.moderator(character varying,character varying) CASCADE;
-- ddl-end --
DROP FUNCTION IF EXISTS public.info_retiree(IN character varying,IN character varying,IN character varying) CASCADE;
-- ddl-end --
DROP FUNCTION IF EXISTS public.info_work_experience(IN character varying) CASCADE;
-- ddl-end --
DROP FUNCTION IF EXISTS public.info_summas(IN character varying) CASCADE;
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
ALTER TABLE public.pensions DROP COLUMN IF EXISTS id_pension_type CASCADE;
-- ddl-end --
ALTER TABLE public.retirees_pensions DROP COLUMN IF EXISTS id_pension CASCADE;
-- ddl-end --
ALTER TABLE public.retirees_pensions DROP COLUMN IF EXISTS id_retirees CASCADE;
-- ddl-end --
ALTER TABLE public.work_experience DROP COLUMN IF EXISTS id_retirees CASCADE;
-- ddl-end --
ALTER TABLE public.result_summas DROP COLUMN IF EXISTS january CASCADE;
-- ddl-end --
ALTER TABLE public.result_summas DROP COLUMN IF EXISTS february CASCADE;
-- ddl-end --
ALTER TABLE public.result_summas DROP COLUMN IF EXISTS march CASCADE;
-- ddl-end --
ALTER TABLE public.result_summas DROP COLUMN IF EXISTS april CASCADE;
-- ddl-end --
ALTER TABLE public.result_summas DROP COLUMN IF EXISTS may CASCADE;
-- ddl-end --
ALTER TABLE public.result_summas DROP COLUMN IF EXISTS june CASCADE;
-- ddl-end --
ALTER TABLE public.result_summas DROP COLUMN IF EXISTS july CASCADE;
-- ddl-end --
ALTER TABLE public.result_summas DROP COLUMN IF EXISTS august CASCADE;
-- ddl-end --
ALTER TABLE public.result_summas DROP COLUMN IF EXISTS september CASCADE;
-- ddl-end --
ALTER TABLE public.result_summas DROP COLUMN IF EXISTS october CASCADE;
-- ddl-end --
ALTER TABLE public.result_summas DROP COLUMN IF EXISTS november CASCADE;
-- ddl-end --
ALTER TABLE public.result_summas DROP COLUMN IF EXISTS december CASCADE;
-- ddl-end --
ALTER TABLE public.result_summas DROP COLUMN IF EXISTS id_retirees CASCADE;
-- ddl-end --


-- [ Created objects ] --
-- object: pension_type_id | type: COLUMN --
-- ALTER TABLE public.pensions DROP COLUMN IF EXISTS pension_type_id CASCADE;
ALTER TABLE public.pensions ADD COLUMN pension_type_id uuid NOT NULL;
-- ddl-end --


-- object: pension_id | type: COLUMN --
-- ALTER TABLE public.retirees_pensions DROP COLUMN IF EXISTS pension_id CASCADE;
ALTER TABLE public.retirees_pensions ADD COLUMN pension_id uuid NOT NULL;
-- ddl-end --


-- object: retiree_id | type: COLUMN --
-- ALTER TABLE public.retirees_pensions DROP COLUMN IF EXISTS retiree_id CASCADE;
ALTER TABLE public.retirees_pensions ADD COLUMN retiree_id uuid NOT NULL;
-- ddl-end --


-- object: retiree_id | type: COLUMN --
-- ALTER TABLE public.work_experience DROP COLUMN IF EXISTS retiree_id CASCADE;
ALTER TABLE public.work_experience ADD COLUMN retiree_id uuid NOT NULL;
-- ddl-end --


-- object: retiree_id | type: COLUMN --
-- ALTER TABLE public.result_summas DROP COLUMN IF EXISTS retiree_id CASCADE;
ALTER TABLE public.result_summas ADD COLUMN retiree_id uuid NOT NULL;
-- ddl-end --


-- object: public.months | type: TABLE --
-- DROP TABLE IF EXISTS public.months CASCADE;
CREATE TABLE public.months (
	id uuid NOT NULL,
	number smallint,
	rus_label varchar(15),
	CONSTRAINT month_pkey PRIMARY KEY (id)

);
-- ddl-end --
ALTER TABLE public.months OWNER TO pension_dba;
-- ddl-end --

-- object: month_id | type: COLUMN --
-- ALTER TABLE public.result_summas DROP COLUMN IF EXISTS month_id CASCADE;
ALTER TABLE public.result_summas ADD COLUMN month_id uuid NOT NULL;
-- ddl-end --


-- object: month_payment | type: COLUMN --
-- ALTER TABLE public.result_summas DROP COLUMN IF EXISTS month_payment CASCADE;
ALTER TABLE public.result_summas ADD COLUMN month_payment money DEFAULT 0;
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
ALTER ROLE pension_worker
	NOLOGIN
	ENCRYPTED PASSWORD 'pension_worker';
-- ddl-end --
ALTER TABLE public.work_experience ALTER COLUMN insurance_payment SET DEFAULT 0;
-- ddl-end --
ALTER TABLE public.work_experience ALTER COLUMN coeff TYPE float;
-- ddl-end --
ALTER TABLE public.result_summas ALTER COLUMN year TYPE bigint;
-- ddl-end --
ALTER TABLE public.result_summas ALTER COLUMN result DROP NOT NULL;
-- ddl-end --
COMMENT ON COLUMN public.result_summas.result IS '';
-- ddl-end --


-- [ Created constraints ] --
-- object: login_ukey | type: CONSTRAINT --
-- ALTER TABLE moderator.users DROP CONSTRAINT IF EXISTS login_ukey CASCADE;
ALTER TABLE moderator.users ADD CONSTRAINT login_ukey UNIQUE (login);
-- ddl-end --



-- [ Created foreign keys ] --
-- object: pension_type_fkey | type: CONSTRAINT --
-- ALTER TABLE public.pensions DROP CONSTRAINT IF EXISTS pension_type_fkey CASCADE;
ALTER TABLE public.pensions ADD CONSTRAINT pension_type_fkey FOREIGN KEY (pension_type_id)
REFERENCES public.pensions_type (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: pensions_fkey | type: CONSTRAINT --
-- ALTER TABLE public.retirees_pensions DROP CONSTRAINT IF EXISTS pensions_fkey CASCADE;
ALTER TABLE public.retirees_pensions ADD CONSTRAINT pensions_fkey FOREIGN KEY (pension_id)
REFERENCES public.pensions (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: retirees_fkey | type: CONSTRAINT --
-- ALTER TABLE public.retirees_pensions DROP CONSTRAINT IF EXISTS retirees_fkey CASCADE;
ALTER TABLE public.retirees_pensions ADD CONSTRAINT retirees_fkey FOREIGN KEY (retiree_id)
REFERENCES public.retirees (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: retirees_fkey | type: CONSTRAINT --
-- ALTER TABLE public.work_experience DROP CONSTRAINT IF EXISTS retirees_fkey CASCADE;
ALTER TABLE public.work_experience ADD CONSTRAINT retirees_fkey FOREIGN KEY (retiree_id)
REFERENCES public.retirees (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: retirees_fkey | type: CONSTRAINT --
-- ALTER TABLE public.result_summas DROP CONSTRAINT IF EXISTS retirees_fkey CASCADE;
ALTER TABLE public.result_summas ADD CONSTRAINT retirees_fkey FOREIGN KEY (retiree_id)
REFERENCES public.retirees (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: month_fkey | type: CONSTRAINT --
-- ALTER TABLE public.result_summas DROP CONSTRAINT IF EXISTS month_fkey CASCADE;
ALTER TABLE public.result_summas ADD CONSTRAINT month_fkey FOREIGN KEY (month_id)
REFERENCES public.months (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

