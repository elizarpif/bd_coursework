-- +migrate Up
-- +migrate StatementBegin

CREATE OR REPLACE FUNCTION set_insert_sum() RETURNS TRIGGER AS
$$

BEGIN
    IF TG_OP = 'INSERT' THEN
        UPDATE result_summas
        SET result=NEW.month_payment + (select result
                                        from result_summas
                                        where year = NEW.year
                                          AND month_id = (select id
                                                          from months
                                                          where number = ((select number from months where id = NEW.month_id) - 1)))
        WHERE id = NEW.id;
        RETURN NEW;
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER insert_sum
    AFTER INSERT
    ON result_summas
    FOR EACH ROW
EXECUTE PROCEDURE set_insert_sum();

-- опыт работы
CREATE OR REPLACE FUNCTION info_work_experience(IN snils varchar)
    RETURNS TABLE
            (
                work_eperience    smallint,
                insurance_payment pg_catalog.money,
                place_of_work     varchar
            )
AS
$$
BEGIN
    return query
        select w.work_experience, w.insurance_payment, w.place_of_work
        from work_experience AS w
        where w.retiree_id = (select id from retirees where insurance_number_of_individual_personal_account = snils);
end;
$$ language plpgsql;

-- результирующие суммы по снилсу
CREATE OR REPLACE FUNCTION info_summas(IN snils varchar)
    returns TABLE
            (
                month         varchar,
                month_payment pg_catalog.money,
                result        pg_catalog.money,
                year          int
            )
AS
$$
BEGIN
    return query SELECT m.rus_label,
                        r.month_payment,
                        r.result,
                        r.year
                 FROM result_summas AS r
                          JOIN months AS m on r.month_id = m.id
                 WHERE retiree_id =
                       (SELECT id from retirees where insurance_number_of_individual_personal_account = snils);

END;
$$ LANGUAGE plpgsql;

GRANT select, update, insert on all tables in schema public to pension_worker;
grant select on all tables in schema public to pension_db;

-- +migrate StatementEnd

-- +migrate Down
-- +migrate StatementBegin

DROP FUNCTION if exists info_work_experience CASCADE;

DROP FUNCTION if exists info_summas CASCADE;
drop function if exists set_insert_sum cascade;
DROP TRIGGER IF EXISTS insert_sum ON pension_db CASCADE;
-- +migrate StatementEnd
