-- +migrate Up
-- +migrate StatementBegin

-- изменить информацию о пенсионере
create or replace procedure changeRetireeInfo(IN s varchar, IN n varchar, IN p varchar, IN snils varchar,
                                              IN addr varchar, IN old_snils varchar)
as
$$
begin
    update retirees
    set name=n,
        surname=s,
        patronymic=p,
        insurance_number_of_individual_personal_account=snils,
        address=addr
    where insurance_number_of_individual_personal_account = old_snils;
end;
$$ LANGUAGE plpgsql;


-- вывести пенсии
create or replace function InfoPension(IN snils varchar)
    returns table
            (
                pension_type varchar,
                pension      varchar,
                payment      money
            )
as
$$
begin
    return query
        select pt.rus_label, p.rus_label, p.standart_payment
        from pensions_type as pt
                 join pensions p on pt.id = p.pension_type_id
                 join retirees_pensions rp on p.id = rp.pension_id
        where rp.retiree_id = (select id from retirees where insurance_number_of_individual_personal_account = snils);
end;
$$ language plpgsql;
-- добавить пенсию
create or replace procedure addPension(IN pension_type varchar, IN snils varchar) as
$$
begin
    insert into retirees_pensions(id, pension_id, retiree_id)
    values (uuid_generate_v4(),
            (select id
             from pensions
             where rus_label = pension_type),
            (select id from retirees where insurance_number_of_individual_personal_account = snils));
end;
$$ LANGUAGE plpgsql;

-- добавить место работы
create or replace procedure addWork(IN w_exp int, IN ins_pay pg_catalog.money, IN place varchar, IN coef float,
                                    IN snils varchar) as
$$
begin
    insert into work_experience(id, work_experience, insurance_payment, place_of_work, coeff, retiree_id)
    values (uuid_generate_v4(), w_exp, ins_pay, place, coef,
            (select id from retirees where insurance_number_of_individual_personal_account = snils));
end;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION info_retiree(IN snilsin VARCHAR)
    returns TABLE
            (
                surname           varchar,
                name              varchar,
                patronymic        varchar,
                registration_date date,
                snils             varchar,
                address           text
            )
AS
$$
BEGIN
    return query SELECT r.surname,
                        r.name,
                        r.patronymic,
                        r.registration_date,
                        r.insurance_number_of_individual_personal_account,
                        r.address
                 FROM retirees AS r
                 WHERE r.insurance_number_of_individual_personal_account = snilsin;
END;
$$ LANGUAGE plpgsql;

create or replace function isExistPension(in pension_type varchar, in snils varchar)
    returns bool
as
$$
DECLARE
    record uuid;
BEGIN
    SELECT id
    INTO STRICT record
    FROM retirees_pensions
    WHERE retiree_id = (select id from retirees where insurance_number_of_individual_personal_account = snils)
      and pension_id = (select id
                        from pensions
                        where pension_type_id =
                              (select id from pensions_type where pensions_type.rus_label = pension_type));

    return FOUND;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        return FOUND;
    WHEN TOO_MANY_ROWS THEN
        return FOUND;

end;
$$ LANGUAGE plpgsql;

create or replace procedure addMonthPayment(in snils varchar, in num_month int, in yearIN int)
as
$$
declare
    rec double precision;
    rid uuid;
begin
    rid = (select id from retirees where insurance_number_of_individual_personal_account = snils limit 1);
    rec = (select sum(work_experience) from work_experience where retiree_id = rid) *
          (select sum(coeff) from work_experience where retiree_id = rid) *
          12;

    insert into result_summas(id, retiree_id, month_id, month_payment, year)
    VALUES (uuid_generate_v4(), rid,
            (select id from months where number = num_month),
            rec::numeric::money + (select sum(standart_payment)
                                   from pensions
                                   where id in (select pension_id from retirees_pensions where retiree_id = rid)),
            yearIN);
end;
$$ language plpgsql;

create or replace function get_year(in snils varchar)
    returns integer
as
$$
select max(year)::integer
from result_summas
where retiree_id = (select id from retirees where insurance_number_of_individual_personal_account = $1);

$$ language sql;

create or replace function get_month(in snils varchar, in y int)
    returns integer
as
$$
select max(m.number)::integer
from result_summas
         join months m on result_summas.month_id = m.id
where retiree_id = (select id from retirees where insurance_number_of_individual_personal_account = $1) and year=$2;

$$ language sql;

-- +migrate StatementEnd
-- +migrate Down
-- +migrate StatementBegin
drop function if exists get_month(snils varchar) cascade;
drop function if exists get_year(snils varchar) cascade;
drop function if exists addMonthPayment(snils varchar, num_month int) cascade;
drop function InfoPension(IN snils varchar) cascade;
drop function if exists isExistPension(pension_type varchar, snils varchar) cascade;
drop function if exists info_retiree(snilsin VARCHAR) cascade;
drop function if exists addWork(w_exp int, ins_pay pg_catalog.money, place varchar, coef float, snils varchar) cascade;
drop function if exists changeRetireeInfo(s varchar, n varchar, p varchar, snils varchar, addr varchar, old_snils varchar) cascade;
drop function if exists addPension(pension_type varchar, snils varchar) cascade;
-- +migrate StatementEnd