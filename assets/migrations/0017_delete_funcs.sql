-- +migrate Up
-- +migrate StatementBegin
create or replace procedure delete_month(in snils varchar, in m integer, in y integer) as
$$
begin
    if date_part('month', current_date) > m then
        delete
        from result_summas
        where retiree_id = (select id from retirees where insurance_number_of_individual_personal_account = snils)
          and month_id = (select id from months where number = m)
          and year = y;
    end if;
end;
$$ language plpgsql;

create or replace procedure delete_work(in snils varchar, in place varchar, in w_exp int, in payment int) as
$$
begin
    delete
    from work_experience as w
    where retiree_id = (select id from retirees where insurance_number_of_individual_personal_account = snils)
      and place_of_work = place
      and w.work_experience = w_exp
      and w.insurance_payment = payment::numeric::money;
end;
$$ language plpgsql;

create or replace procedure delete_pension(in snils varchar, in type varchar) as
$$
begin

    delete
    from retirees_pensions
    where retiree_id = (select id from retirees where insurance_number_of_individual_personal_account = snils)
      and pension_id = (select id from pensions where rus_label = type);
end ;
$$ language plpgsql;

--grant delete on all tables in schema public to pension_worker;
-- +migrate StatementEnd
-- +migrate Down
-- +migrate StatementBegin
drop procedure if exists delete_pension(snils varchar, type varchar) cascade;
drop procedure if exists delete_work(snils varchar, place varchar, w_exp int, payment int) cascade;
drop procedure if exists delete_month(snils varchar, m integer, y integer) cascade;
-- +migrate StatementEnd