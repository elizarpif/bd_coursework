
-- +migrate Up
-- +migrate StatementBegin
-- ddl-end --
ALTER TABLE public.result_summas ALTER COLUMN january SET DEFAULT 0;
-- ddl-end --
ALTER TABLE public.result_summas ALTER COLUMN january SET NOT NULL;
-- ddl-end --
ALTER TABLE public.result_summas ALTER COLUMN february SET DEFAULT 0;
-- ddl-end --
ALTER TABLE public.result_summas ALTER COLUMN february SET NOT NULL;
-- ddl-end --
ALTER TABLE public.result_summas ALTER COLUMN march SET DEFAULT 0;
-- ddl-end --
ALTER TABLE public.result_summas ALTER COLUMN march SET NOT NULL;
-- ddl-end --
ALTER TABLE public.result_summas ALTER COLUMN april SET DEFAULT 0;
-- ddl-end --
ALTER TABLE public.result_summas ALTER COLUMN april SET NOT NULL;
-- ddl-end --
ALTER TABLE public.result_summas ALTER COLUMN may SET DEFAULT 0;
-- ddl-end --
ALTER TABLE public.result_summas ALTER COLUMN may SET NOT NULL;
-- ddl-end --
ALTER TABLE public.result_summas ALTER COLUMN june SET DEFAULT 0;
-- ddl-end --
ALTER TABLE public.result_summas ALTER COLUMN june SET NOT NULL;
-- ddl-end --
ALTER TABLE public.result_summas ALTER COLUMN july SET DEFAULT 0;
-- ddl-end --
ALTER TABLE public.result_summas ALTER COLUMN july SET NOT NULL;
-- ddl-end --
ALTER TABLE public.result_summas ALTER COLUMN august SET DEFAULT 0;
-- ddl-end --
ALTER TABLE public.result_summas ALTER COLUMN august SET NOT NULL;
-- ddl-end --
ALTER TABLE public.result_summas ALTER COLUMN september SET DEFAULT 0;
-- ddl-end --
ALTER TABLE public.result_summas ALTER COLUMN september SET NOT NULL;
-- ddl-end --
ALTER TABLE public.result_summas ALTER COLUMN october SET DEFAULT 0;
-- ddl-end --
ALTER TABLE public.result_summas ALTER COLUMN october SET NOT NULL;
-- ddl-end --
ALTER TABLE public.result_summas ALTER COLUMN november SET DEFAULT 0;
-- ddl-end --
ALTER TABLE public.result_summas ALTER COLUMN november SET NOT NULL;
-- ddl-end --
ALTER TABLE public.result_summas ALTER COLUMN december SET DEFAULT 0;
-- ddl-end --
ALTER TABLE public.result_summas ALTER COLUMN december SET NOT NULL;
-- ddl-end --
ALTER TABLE public.result_summas ALTER COLUMN result SET DEFAULT 0;
-- ddl-end --
ALTER TABLE public.result_summas ALTER COLUMN result SET NOT NULL;
-- ddl-end --


CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
-- pensions_type
INSERT INTO pensions_type (id, type, rus_label) VALUES (uuid_generate_v4(), 'insurable', 'страховая');
INSERT INTO pensions_type (id, type, rus_label) VALUES (uuid_generate_v4(), 'state', 'государственная');
-- pensions
INSERT INTO pensions (id, name, rus_label, id_pension_type) VALUES (uuid_generate_v4(), 'disability', 'по инвалидности', (SELECT id FROM pensions_type where type='state'));
INSERT INTO pensions (id, name, rus_label, id_pension_type) VALUES (uuid_generate_v4(), 'senility', 'по старости', (SELECT id FROM pensions_type where type='state'));
INSERT INTO pensions (id, name, rus_label, id_pension_type) VALUES (uuid_generate_v4(), 'participants_of_operations', 'участники боевых действий', (SELECT id FROM pensions_type where type='state'));
INSERT INTO pensions (id, name, rus_label, id_pension_type) VALUES (uuid_generate_v4(), 'monthly_cash_payments', 'ежемесячные денежные выплаты (ЕДВ)', (SELECT id FROM pensions_type where type='insurable'));
INSERT INTO pensions (id, name, rus_label, id_pension_type) VALUES (uuid_generate_v4(), E'survivor\'s_case', 'случай потери кормильца (СПК)', (SELECT id FROM pensions_type where type='insurable'));

--retirees
INSERT INTO retirees (id, name,surname,patronymic,registration_date, insurance_number_of_individual_personal_account,address) VALUES (uuid_generate_v4(), 'Elena', 'Ivanova', 'Pavlovna','2014-07-25','163-648-564 96', 'г Москва, ул Солянка, д 9, кв 45' );
--retirees_pensions
INSERT INTO retirees_pensions ( id , id_pension , id_retirees) VALUES (uuid_generate_v4(), (SELECT id FROM pensions where name='disability'), (SELECT id FROM retirees where name='Elena' and surname='Ivanova' and insurance_number_of_individual_personal_account='163-648-564 96'));
-- work_experience
INSERT INTO work_experience (id, work_experience, insurance_payment, id_retirees) VALUES (uuid_generate_v4(), 17, '8300', (SELECT id FROM retirees where name='Elena' and surname='Ivanova' and insurance_number_of_individual_personal_account='163-648-564 96'));

-- +migrate StatementEnd

-- +migrate Down
-- +migrate StatementBegin

-- work_experience
DELETE FROM work_experience WHERE id_retirees=(SELECT id FROM retirees where name='Elena' and surname='Ivanova' and insurance_number_of_individual_personal_account='163-648-564 96');

-- retirees_pensions
DELETE FROM retirees_pensions WHERE id_retirees=(SELECT id FROM retirees where name='Elena' and surname='Ivanova' and insurance_number_of_individual_personal_account='163-648-564 96');

-- retirees
DELETE FROM retirees WHERE name = 'Elena' AND surname = 'Ivanova' AND insurance_number_of_individual_personal_account= '163-648-564 96';


-- pensions
DELETE FROM pensions WHERE name='disability';
DELETE FROM pensions WHERE name='senility';
DELETE FROM pensions WHERE name='participants_of_operations';
DELETE FROM pensions WHERE name='monthly_cash_payments';
DELETE FROM pensions WHERE name=E'survivor\'s_case';

-- pensions_type
DELETE FROM pensions_type WHERE type='insurable';
DELETE FROM pensions_type WHERE type='state';
-- +migrate StatementEnd
