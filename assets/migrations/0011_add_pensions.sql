-- +migrate Up
-- +migrate StatementBegin
INSERT INTO retirees_pensions(id, id_pension, id_retirees)
VALUES (uuid_generate_v4(), (select id from pensions where name = 'senility'),
        (select id from retirees where name = 'Елена'));
INSERT INTO retirees_pensions(id, id_pension, id_retirees)
VALUES (uuid_generate_v4(), (select id from pensions where name = 'participants_of_operations'),
        (select id from retirees where name = 'Гарри'));
INSERT INTO retirees_pensions(id, id_pension, id_retirees)
VALUES (uuid_generate_v4(), (select id from pensions where name = E'survivor\'s_case'),
        (select id from retirees where name = 'Гарри'));

ALTER TABLE public.pensions
    ADD COLUMN standart_payment money;
ALTER TABLE public.work_experience
    ADD COLUMN coeff float;

-- ALTER TABLE public.work_experience
--     ALTER COLUMN insurance_payment TYPE float;

INSERT INTO pensions (id, name, rus_label, id_pension_type, standart_payment)
VALUES (uuid_generate_v4(), 'insurance_pension', 'страховая пенсия',
        (SELECT id FROM pensions_type where type = 'insurable'), 10000);

UPDATE pensions
SET standart_payment=3500
WHERE name = 'senility';
UPDATE pensions
SET standart_payment=1200
WHERE name = 'disability';
UPDATE pensions
SET standart_payment=7500
WHERE name = 'participants_of_operations';
UPDATE pensions
SET standart_payment=4500
WHERE name = 'monthly_cash_payments';
UPDATE pensions
SET standart_payment=6300
WHERE name = E'survivor\'s_case';

-- 17 * 6.6 * 12 + 10000
UPDATE work_experience
SET coeff = 6.6
WHERE id_retirees = (SELECT id from retirees WHERE name = 'Елена');
-- +migrate StatementEnd

-- +migrate Down
-- +migrate StatementBegin
ALTER TABLE public.work_experience
    DROP COLUMN IF EXISTS coeff CASCADE;
ALTER TABLE public.pensions
    DROP COLUMN IF EXISTS standart_payment CASCADE;
-- +migrate StatementEnd