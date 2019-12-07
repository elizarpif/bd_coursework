-- +migrate Up
-- +migrate StatementBegin
-- вся информация опыт работы
-- перерасчет
-- DROP ROLE IF EXISTS pension_worker;
CREATE ROLE pension_worker WITH
	ENCRYPTED PASSWORD 'pension_worker';
GRANT select, update, insert on all tables in schema public to pension_worker;
grant select on all tables in schema public to pension_db;

ALTER TABLE work_experience
    ADD COLUMN place_of_work varchar(128);
COMMENT ON COLUMN public.work_experience.place_of_work IS 'Место работы';

ALTER TABLE result_summas
    ADD COLUMN year int;

UPDATE result_summas SET year=2019 where id='9e384fea-57e8-4231-85e0-762550ef20d4';

UPDATE public.work_experience
SET place_of_work='ООО Веста'
WHERE id = 'ee68e3f0-6d3e-4026-ad11-87498bafb607';
UPDATE public.retirees
SET name='Елена',
    surname='Иванова',
    patronymic='Павловна'
where insurance_number_of_individual_personal_account = '163-648-564 96';
-- результирующие суммы по снилсу
CREATE OR REPLACE FUNCTION info_summas(IN snils varchar)
    returns TABLE
            (
                january   pg_catalog.money,
                february  pg_catalog.money,
                march     pg_catalog.money,
                april     pg_catalog.money,
                may       pg_catalog.money,
                june      pg_catalog.money,
                july      pg_catalog.money,
                august    pg_catalog.money,
                september pg_catalog.money,
                october   pg_catalog.money,
                november  pg_catalog.money,
                december  pg_catalog.money,
                year      int,
                result    pg_catalog.money
            )
AS
$$
BEGIN
    return query SELECT january,
                        february,
                        march,
                        april,
                        may,
                        june,
                        july,
                        august,
                        september,
                        october,
                        november,
                        december,
                        year,
                        result
                 FROM result_summas
                 WHERE id_retirees =
                       (SELECT id from retirees where insurance_number_of_individual_personal_account = snils);
END;
$$ LANGUAGE plpgsql;



-- опыт работы
CREATE OR REPLACE FUNCTION info_work_experience(IN snils varchar)
    RETURNS TABLE
            (
                work_eperience    smallint,
                insurance_payment pg_catalog.money,
                place_of_work     varchar
            )
AS
    $$BEGIN
        return query
    select w.work_experience, w.insurance_payment, w.place_of_work from work_experience AS w;
end;
    $$language plpgsql;

-- +migrate StatementEnd

-- +migrate Down
-- +migrate StatementBegin
REVOKE ALL PRIVILEGES ON all tables in schema public FROM pension_worker;
DROP role if exists pension_worker;

DROP FUNCTION if exists info_work_experience() CASCADE;

DROP FUNCTION if exists info_summas() CASCADE;

UPDATE public.retirees
SET name='Elena',
    surname='Ivanova',
    patronymic='Pavlovna'
where insurance_number_of_individual_personal_account = '163-648-564 96';

ALTER TABLE result_summas
    DROP COLUMN year;

ALTER TABLE public.work_experience
    DROP COLUMN IF EXISTS place_of_work;
-- +migrate StatementEnd