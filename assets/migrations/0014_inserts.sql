
-- +migrate Up
-- +migrate StatementBegin

DROP TRIGGER IF EXISTS update_sum ON public.result_summas CASCADE;
DROP FUNCTION IF EXISTS public.set_update_sum() CASCADE;
DROP TRIGGER IF EXISTS insert_sum ON public.result_summas CASCADE;
DROP FUNCTION IF EXISTS public.set_insert_sum() CASCADE;

INSERT INTO months (id, number, rus_label) VALUES (uuid_generate_v4(), 1, 'Январь');
INSERT INTO months (id, number, rus_label) VALUES (uuid_generate_v4(), 2, 'Февраль');
INSERT INTO months (id, number, rus_label) VALUES (uuid_generate_v4(), 3, 'Март');
INSERT INTO months (id, number, rus_label) VALUES (uuid_generate_v4(), 4, 'Апрель');
INSERT INTO months (id, number, rus_label) VALUES (uuid_generate_v4(), 5, 'Май');
INSERT INTO months (id, number, rus_label) VALUES (uuid_generate_v4(), 6, 'Июнь');
INSERT INTO months (id, number, rus_label) VALUES (uuid_generate_v4(), 7, 'Июль');
INSERT INTO months (id, number, rus_label) VALUES (uuid_generate_v4(), 8, 'Август');
INSERT INTO months (id, number, rus_label) VALUES (uuid_generate_v4(), 9, 'Сентябрь');
INSERT INTO months (id, number, rus_label) VALUES (uuid_generate_v4(), 10, 'Октябрь');
INSERT INTO months (id, number, rus_label) VALUES (uuid_generate_v4(), 11, 'Ноябрь');
INSERT INTO months (id, number, rus_label) VALUES (uuid_generate_v4(), 12, 'Декабрь');

DELETE FROM result_summas;
INSERT INTO result_summas (id, year, retiree_id, month_id, month_payment) VALUES (uuid_generate_v4(), 2019, (select id from retirees where name='Елена'), (select id from months where number=1), 8000);
INSERT INTO result_summas (id, year, retiree_id, month_id, month_payment) VALUES (uuid_generate_v4(), 2019, (select id from retirees where name='Елена'), (select id from months where number=2), 8000);
INSERT INTO result_summas (id, year, retiree_id, month_id, month_payment) VALUES (uuid_generate_v4(), 2019, (select id from retirees where name='Елена'), (select id from months where number=3), 8000);
INSERT INTO result_summas (id, year, retiree_id, month_id, month_payment) VALUES (uuid_generate_v4(), 2019, (select id from retirees where name='Елена'), (select id from months where number=4), 8000);
INSERT INTO result_summas (id, year, retiree_id, month_id, month_payment) VALUES (uuid_generate_v4(), 2019, (select id from retirees where name='Елена'), (select id from months where number=5), 8000);
INSERT INTO result_summas (id, year, retiree_id, month_id, month_payment) VALUES (uuid_generate_v4(), 2019, (select id from retirees where name='Елена'), (select id from months where number=6), 8000);
INSERT INTO result_summas (id, year, retiree_id, month_id, month_payment) VALUES (uuid_generate_v4(), 2019, (select id from retirees where name='Елена'), (select id from months where number=7), 8000);
INSERT INTO result_summas (id, year, retiree_id, month_id, month_payment) VALUES (uuid_generate_v4(), 2019, (select id from retirees where name='Елена'), (select id from months where number=8), 8000);
INSERT INTO result_summas (id, year, retiree_id, month_id, month_payment) VALUES (uuid_generate_v4(), 2019, (select id from retirees where name='Елена'), (select id from months where number=9), 8000);
INSERT INTO result_summas (id, year, retiree_id, month_id, month_payment) VALUES (uuid_generate_v4(), 2019, (select id from retirees where name='Елена'), (select id from months where number=10), 8000);
INSERT INTO result_summas (id, year, retiree_id, month_id, month_payment) VALUES (uuid_generate_v4(), 2019, (select id from retirees where name='Елена'), (select id from months where number=11), 8000);
INSERT INTO result_summas (id, year, retiree_id, month_id, month_payment) VALUES (uuid_generate_v4(), 2019, (select id from retirees where name='Елена'), (select id from months where number=12), 0);


DELETE FROM pensions;
INSERT INTO pensions (id, name, rus_label, pension_type_id, standart_payment) VALUES (uuid_generate_v4(), 'disability', 'по инвалидности', (SELECT id FROM pensions_type where type='state'), 3500);
INSERT INTO pensions (id, name, rus_label, pension_type_id, standart_payment) VALUES (uuid_generate_v4(), 'senility', 'по старости', (SELECT id FROM pensions_type where type='state'), 1200);
INSERT INTO pensions (id, name, rus_label, pension_type_id, standart_payment) VALUES (uuid_generate_v4(), 'participants_of_operations', 'участники боевых действий', (SELECT id FROM pensions_type where type='state'), 7500);
INSERT INTO pensions (id, name, rus_label, pension_type_id, standart_payment) VALUES (uuid_generate_v4(), 'monthly_cash_payments', 'ежемесячные денежные выплаты (ЕДВ)', (SELECT id FROM pensions_type where type='insurable'), 4500);
INSERT INTO pensions (id, name, rus_label, pension_type_id, standart_payment) VALUES (uuid_generate_v4(), E'survivor\'s_case', 'случай потери кормильца (СПК)', (SELECT id FROM pensions_type where type='insurable'), 6300);

DELETE FROM retirees_pensions;
INSERT INTO retirees_pensions ( id , pension_id, retiree_id) VALUES (uuid_generate_v4(), (SELECT id FROM pensions where name='disability'), (SELECT id FROM retirees where insurance_number_of_individual_personal_account='163-648-564 96'));
INSERT INTO retirees_pensions ( id , pension_id, retiree_id) VALUES (uuid_generate_v4(), (SELECT id FROM pensions where name='senility'), (SELECT id FROM retirees where insurance_number_of_individual_personal_account='163-648-564 96'));
INSERT INTO retirees_pensions ( id , pension_id, retiree_id) VALUES (uuid_generate_v4(), (SELECT id FROM pensions where name=E'survivor\'s_case'), (SELECT id FROM retirees where insurance_number_of_individual_personal_account='103-048-564 90'));
INSERT INTO retirees_pensions ( id , pension_id, retiree_id) VALUES (uuid_generate_v4(), (SELECT id FROM pensions where name='participants_of_operations'), (SELECT id FROM retirees where insurance_number_of_individual_personal_account='103-048-564 90'));

DELETE FROM work_experience;
INSERT INTO work_experience  (work_experience, insurance_payment, id, place_of_work, coeff, retiree_id) VALUES (17,8300, uuid_generate_v4(), 'ООО Веста', 6.6, (select id from retirees where name='Елена') );
-- DROP FUNCTION IF EXISTS public.info_about_pensions(IN character varying) CASCADE;
-- DROP FUNCTION IF EXISTS public.moderator(character varying,character varying) CASCADE;
-- DROP FUNCTION IF EXISTS public.info_retiree(IN character varying,IN character varying,IN character varying) CASCADE;
-- DROP FUNCTION IF EXISTS public.info_work_experience(IN character varying) CASCADE;

-- DROP FUNCTION IF EXISTS public.info_summas(IN character varying) CASCADE;
-- DROP TRIGGER IF EXISTS update_sum ON public.result_summas CASCADE;
-- DROP FUNCTION IF EXISTS public.set_update_sum() CASCADE;
-- DROP TRIGGER IF EXISTS insert_sum ON public.result_summas CASCADE;
-- DROP FUNCTION IF EXISTS public.set_insert_sum() CASCADE;
--
--
-- CREATE OR REPLACE FUNCTION set_insert_sum() RETURNS TRIGGER AS $$
--
-- BEGIN
--     IF    TG_OP = 'INSERT' THEN
--         UPDATE result_summas SET result=NEW. WHERE id=NEW.id;
--         RETURN NEW;
--     END IF;
-- END;
-- $$ LANGUAGE plpgsql;
--
--
-- CREATE TRIGGER insert_sum
-- AFTER INSERT ON result_summas FOR EACH ROW EXECUTE PROCEDURE set_insert_sum ();
--
-- CREATE OR REPLACE FUNCTION set_update_sum() RETURNS TRIGGER AS $$
-- BEGIN
--     IF TG_OP = 'UPDATE' THEN
--         UPDATE result_summas SET result=NEW.january + NEW.february+NEW.march+NEW.april +NEW.may + NEW.june + NEW.july +new.august + NEW.september + NEW.october + NEW.november+ NEW.december WHERE id=OLD.id;
--         RETURN NEW;
--     END IF;
-- END;
-- $$ LANGUAGE plpgsql;
--
--
-- create trigger update_sum
-- after update of january,february,march,april,may,june,july,august,september,october,november,december
-- on result_summas
-- for each row
-- execute procedure set_update_sum();

-- 17 * 6.6 * 12 + 10000
-- n * coeff * 12 (from work experience) + (standart_payment from pensions where idtype= страховая по старости)
-- если назначена в (retirees_pensions) суммируем оттуда standart_payment
-- перерасчет
-- create or replace function recalculation(IN snils varchar, IN month varchar, IN year int) returns void
-- as
--     $$
--     begin
--         -- текущий месяц
--         -- update result_summas set month=()
--     end;
--     $$
-- +migrate StatementEnd
-- +migrate Down
-- +migrate StatementBegin

-- +migrate StatementEnd