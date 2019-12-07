
-- +migrate Up
-- +migrate StatementBegin
CREATE TABLE public.retirees (
	id uuid NOT NULL,
	name varchar(30),
	surname varchar(30),
	patronymic varchar(30),
	registration_date date,
	insurance_number_of_individual_personal_account varchar(14),
	address text,
	CONSTRAINT retirees_pkey PRIMARY KEY (id)

);
-- ddl-end --
COMMENT ON TABLE public.retirees IS 'пенсионеры';
-- ddl-end --
COMMENT ON COLUMN public.retirees.patronymic IS 'отчество';
-- ddl-end --
COMMENT ON COLUMN public.retirees.insurance_number_of_individual_personal_account IS 'СНИЛС';
-- ddl-end --
ALTER TABLE public.retirees OWNER TO pension_dba;
-- ddl-end --

-- object: public.pensions | type: TABLE --
-- DROP TABLE IF EXISTS public.pensions CASCADE;
CREATE TABLE public.pensions (
	id uuid NOT NULL,
	name text,
	rus_label text,
	id_pension_type uuid NOT NULL,
	CONSTRAINT pensions_pkey PRIMARY KEY (id)

);
-- ddl-end --
COMMENT ON TABLE public.pensions IS 'пенсии';
-- ddl-end --
ALTER TABLE public.pensions OWNER TO pension_dba;
-- ddl-end --

-- object: public.retirees_pensions | type: TABLE --
-- DROP TABLE IF EXISTS public.retirees_pensions CASCADE;
CREATE TABLE public.retirees_pensions (
	id uuid NOT NULL,
	id_pension uuid NOT NULL,
	id_retirees uuid NOT NULL,
	CONSTRAINT retirees_pensions_pkey PRIMARY KEY (id)

);
-- ddl-end --
ALTER TABLE public.retirees_pensions OWNER TO pension_dba;
-- ddl-end --

-- object: public.work_experience | type: TABLE --
-- DROP TABLE IF EXISTS public.work_experience CASCADE;
CREATE TABLE public.work_experience (
	work_experience smallint,
	insurance_payment money,
	id uuid NOT NULL,
	id_retirees uuid NOT NULL,
	CONSTRAINT work_experience_pkey PRIMARY KEY (id)

);
-- ddl-end --
COMMENT ON COLUMN public.work_experience.insurance_payment IS 'страховой взнос';
-- ddl-end --
ALTER TABLE public.work_experience OWNER TO pension_dba;
-- ddl-end --

-- object: public.result_summas | type: TABLE --
-- DROP TABLE IF EXISTS public.result_summas CASCADE;
CREATE TABLE public.result_summas (
	january money NOT NULL DEFAULT 0,
	february money NOT NULL DEFAULT 0,
	march money NOT NULL DEFAULT 0,
	april money NOT NULL DEFAULT 0,
	may money NOT NULL DEFAULT 0,
	june money NOT NULL DEFAULT 0,
	july money NOT NULL DEFAULT 0,
	august money NOT NULL DEFAULT 0,
	september money NOT NULL DEFAULT 0,
	october money NOT NULL DEFAULT 0,
	november money NOT NULL DEFAULT 0,
	december money NOT NULL DEFAULT 0,
	result money NOT NULL DEFAULT 0,
	id uuid NOT NULL,
	id_retirees uuid NOT NULL,
	CONSTRAINT result_summas_pkey PRIMARY KEY (id)

);
-- ddl-end --
COMMENT ON COLUMN public.result_summas.result IS 'итог с начала года';
-- ddl-end --
ALTER TABLE public.result_summas OWNER TO pension_dba;
-- ddl-end --

-- object: public.pensions_type | type: TABLE --
-- DROP TABLE IF EXISTS public.pensions_type CASCADE;
CREATE TABLE public.pensions_type (
	id uuid NOT NULL,
	type varchar(30),
	rus_label text,
	CONSTRAINT pensions_type_pkey PRIMARY KEY (id)

);
-- ddl-end --
ALTER TABLE public.pensions_type OWNER TO pension_dba;
-- ddl-end --

-- object: pension_type_fkey | type: CONSTRAINT --
-- ALTER TABLE public.pensions DROP CONSTRAINT IF EXISTS pension_type_fkey CASCADE;
ALTER TABLE public.pensions ADD CONSTRAINT pension_type_fkey FOREIGN KEY (id_pension_type)
REFERENCES public.pensions_type (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: pensions_fkey | type: CONSTRAINT --
-- ALTER TABLE public.retirees_pensions DROP CONSTRAINT IF EXISTS pensions_fkey CASCADE;
ALTER TABLE public.retirees_pensions ADD CONSTRAINT pensions_fkey FOREIGN KEY (id_pension)
REFERENCES public.pensions (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: retirees_fkey | type: CONSTRAINT --
-- ALTER TABLE public.retirees_pensions DROP CONSTRAINT IF EXISTS retirees_fkey CASCADE;
ALTER TABLE public.retirees_pensions ADD CONSTRAINT retirees_fkey FOREIGN KEY (id_retirees)
REFERENCES public.retirees (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: retiress_fkey | type: CONSTRAINT --
-- ALTER TABLE public.work_experience DROP CONSTRAINT IF EXISTS retiress_fkey CASCADE;
ALTER TABLE public.work_experience ADD CONSTRAINT retiress_fkey FOREIGN KEY (id_retirees)
REFERENCES public.retirees (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: retirees_fkey | type: CONSTRAINT --
-- ALTER TABLE public.result_summas DROP CONSTRAINT IF EXISTS retirees_fkey CASCADE;
ALTER TABLE public.result_summas ADD CONSTRAINT retirees_fkey FOREIGN KEY (id_retirees)
REFERENCES public.retirees (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- +migrate StatementEnd

-- +migrate Down
-- +migrate StatementBegin
ALTER TABLE public.result_summas DROP CONSTRAINT IF EXISTS retirees_fkey CASCADE;
ALTER TABLE public.work_experience DROP CONSTRAINT IF EXISTS retiress_fkey CASCADE;
ALTER TABLE public.retirees_pensions DROP CONSTRAINT IF EXISTS retirees_fkey CASCADE;
ALTER TABLE public.retirees_pensions DROP CONSTRAINT IF EXISTS pensions_fkey CASCADE;
ALTER TABLE public.pensions DROP CONSTRAINT IF EXISTS pension_type_fkey CASCADE;

DROP TABLE IF EXISTS public.work_experience CASCADE;
DROP TABLE IF EXISTS public.retirees_pensions CASCADE;
DROP TABLE IF EXISTS public.pensions CASCADE;
DROP TABLE IF EXISTS public.retirees CASCADE;
-- +migrate StatementEnd
