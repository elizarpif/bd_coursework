
-- +migrate Up
-- +migrate StatementBegin
ALTER TABLE public.pensions ALTER COLUMN name TYPE varchar(128);
ALTER TABLE public.pensions ALTER COLUMN rus_label TYPE varchar(128);
ALTER TABLE public.pensions_type ALTER COLUMN rus_label TYPE varchar(128);

create or replace function info_about_pensions(IN snils varchar)
    returns table
            (
                pension_name varchar,
                pension_type varchar,
                standart_payment money
            )
            AS
$$
  BEGIN
      return query
      SELECT p.name, pt.rus_label, p.standart_payment FROM pensions AS p
      JOIN pensions_type AS pt on p.id_pension_type = pt.id
      JOIN retirees_pensions rp on p.id = rp.id_pension
      WHERE rp.id_retirees=(SELECT id from retirees where insurance_number_of_individual_personal_account=snils);
   end;
    $$language plpgsql;
-- +migrate StatementEnd
-- +migrate Down
-- +migrate StatementBegin
drop function if exists info_about_pensions()  cascade ;

ALTER TABLE public.pensions ALTER COLUMN name TYPE text;
ALTER TABLE public.pensions ALTER COLUMN rus_label TYPE text;
ALTER TABLE public.pensions_type ALTER COLUMN rus_label TYPE text;
-- +migrate StatementEnd
