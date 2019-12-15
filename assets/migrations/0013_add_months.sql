-- +migrate Up
-- +migrate StatementBegin

ALTER TABLE public.result_summas DROP CONSTRAINT IF EXISTS retirees_fkey CASCADE;
ALTER TABLE public.work_experience DROP CONSTRAINT IF EXISTS retiress_fkey CASCADE;
ALTER TABLE public.retirees_pensions DROP CONSTRAINT IF EXISTS retirees_fkey CASCADE;
ALTER TABLE public.retirees_pensions DROP CONSTRAINT IF EXISTS pensions_fkey CASCADE;
ALTER TABLE public.pensions DROP CONSTRAINT IF EXISTS pension_type_fkey CASCADE;

ALTER TABLE public.pensions DROP COLUMN IF EXISTS id_pension_type CASCADE;
ALTER TABLE public.retirees_pensions DROP COLUMN IF EXISTS id_pension CASCADE;
ALTER TABLE public.retirees_pensions DROP COLUMN IF EXISTS id_retirees CASCADE;
ALTER TABLE public.work_experience DROP COLUMN IF EXISTS id_retirees CASCADE;

ALTER TABLE public.result_summas DROP COLUMN IF EXISTS january CASCADE;
ALTER TABLE public.result_summas DROP COLUMN IF EXISTS february CASCADE;
ALTER TABLE public.result_summas DROP COLUMN IF EXISTS march CASCADE;
ALTER TABLE public.result_summas DROP COLUMN IF EXISTS april CASCADE;
ALTER TABLE public.result_summas DROP COLUMN IF EXISTS may CASCADE;
ALTER TABLE public.result_summas DROP COLUMN IF EXISTS june CASCADE;
ALTER TABLE public.result_summas DROP COLUMN IF EXISTS july CASCADE;
ALTER TABLE public.result_summas DROP COLUMN IF EXISTS august CASCADE;
ALTER TABLE public.result_summas DROP COLUMN IF EXISTS september CASCADE;
ALTER TABLE public.result_summas DROP COLUMN IF EXISTS october CASCADE;
ALTER TABLE public.result_summas DROP COLUMN IF EXISTS november CASCADE;
ALTER TABLE public.result_summas DROP COLUMN IF EXISTS december CASCADE;
ALTER TABLE public.result_summas DROP COLUMN IF EXISTS id_retirees CASCADE;

ALTER TABLE public.pensions ADD COLUMN pension_type_id uuid ;
ALTER TABLE public.retirees_pensions ADD COLUMN pension_id uuid ;
ALTER TABLE public.retirees_pensions ADD COLUMN retiree_id uuid ;
ALTER TABLE public.work_experience ADD COLUMN retiree_id uuid ;
ALTER TABLE public.result_summas ADD COLUMN retiree_id uuid ;

CREATE TABLE public.months (
	id uuid NOT NULL,
	number smallint,
	rus_label varchar(15),
	CONSTRAINT month_pkey PRIMARY KEY (id)
);
ALTER TABLE public.months OWNER TO pension_dba;

ALTER TABLE public.result_summas ADD COLUMN month_id uuid ;
ALTER TABLE public.result_summas ADD COLUMN month_payment money DEFAULT 0;
ALTER TABLE public.work_experience ALTER COLUMN insurance_payment SET DEFAULT 0;
ALTER TABLE public.work_experience ALTER COLUMN coeff TYPE float;
ALTER TABLE public.result_summas ALTER COLUMN result DROP NOT NULL;

COMMENT ON COLUMN public.result_summas.result IS 'итог с начала года';

ALTER TABLE moderator.users ADD CONSTRAINT login_ukey UNIQUE (login);

ALTER TABLE public.pensions ADD CONSTRAINT pension_type_fkey FOREIGN KEY (pension_type_id)
REFERENCES public.pensions_type (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE public.retirees_pensions ADD CONSTRAINT pensions_fkey FOREIGN KEY (pension_id)
REFERENCES public.pensions (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE public.retirees_pensions ADD CONSTRAINT retirees_fkey FOREIGN KEY (retiree_id)
REFERENCES public.retirees (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE public.work_experience ADD CONSTRAINT retirees_fkey FOREIGN KEY (retiree_id)
REFERENCES public.retirees (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE public.result_summas ADD CONSTRAINT retirees_fkey FOREIGN KEY (retiree_id)
REFERENCES public.retirees (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE public.result_summas ADD CONSTRAINT month_fkey FOREIGN KEY (month_id)
REFERENCES public.months (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;

-- +migrate StatementEnd
-- +migrate Down
-- +migrate StatementBegin
ALTER TABLE public.result_summas ADD COLUMN january money DEFAULT 0;
ALTER TABLE public.result_summas ADD COLUMN february money DEFAULT 0;
ALTER TABLE public.result_summas ADD COLUMN march money DEFAULT 0;
ALTER TABLE public.result_summas ADD COLUMN april money DEFAULT 0;
ALTER TABLE public.result_summas ADD COLUMN may money DEFAULT 0;
ALTER TABLE public.result_summas ADD COLUMN june money DEFAULT 0;
ALTER TABLE public.result_summas ADD COLUMN july money DEFAULT 0;
ALTER TABLE public.result_summas ADD COLUMN august money DEFAULT 0;
ALTER TABLE public.result_summas ADD COLUMN september money DEFAULT 0;
ALTER TABLE public.result_summas ADD COLUMN october money DEFAULT 0;
ALTER TABLE public.result_summas ADD COLUMN november money DEFAULT 0;
ALTER TABLE public.result_summas ADD COLUMN december money DEFAULT 0;

ALTER TABLE public.result_summas DROP CONSTRAINT IF EXISTS month_fkey CASCADE;
ALTER TABLE public.result_summas DROP CONSTRAINT IF EXISTS retirees_fkey CASCADE;
ALTER TABLE public.work_experience DROP CONSTRAINT IF EXISTS retirees_fkey CASCADE;
ALTER TABLE public.retirees_pensions DROP CONSTRAINT IF EXISTS retirees_fkey CASCADE;
ALTER TABLE public.retirees_pensions DROP CONSTRAINT IF EXISTS pensions_fkey CASCADE;
ALTER TABLE public.pensions DROP CONSTRAINT IF EXISTS pension_type_fkey CASCADE;

ALTER TABLE moderator.users DROP CONSTRAINT IF EXISTS login_ukey CASCADE;
ALTER TABLE public.result_summas DROP COLUMN IF EXISTS month_payment CASCADE;
ALTER TABLE public.result_summas DROP COLUMN IF EXISTS month_id CASCADE;

DROP TABLE IF EXISTS public.months CASCADE;

ALTER TABLE public.result_summas DROP COLUMN IF EXISTS retiree_id CASCADE;
ALTER TABLE public.work_experience DROP COLUMN IF EXISTS retiree_id CASCADE;
ALTER TABLE public.retirees_pensions DROP COLUMN IF EXISTS retiree_id CASCADE;

ALTER TABLE public.retirees_pensions DROP COLUMN IF EXISTS pension_id CASCADE;
ALTER TABLE public.pensions DROP COLUMN IF EXISTS pension_type_id CASCADE;
-- +migrate StatementEnd
