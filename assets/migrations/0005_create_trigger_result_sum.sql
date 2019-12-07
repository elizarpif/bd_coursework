-- +migrate Up
-- +migrate StatementBegin

CREATE OR REPLACE FUNCTION set_insert_sum() RETURNS TRIGGER AS $$

BEGIN
    IF    TG_OP = 'INSERT' THEN
        UPDATE result_summas SET result=NEW.january + NEW.february+NEW.march+NEW.april +NEW.may + NEW.june + NEW.july +new.august + NEW.september + NEW.october + NEW.november+ NEW.december WHERE id=NEW.id;
        RETURN NEW;
    END IF;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER insert_sum
AFTER INSERT ON result_summas FOR EACH ROW EXECUTE PROCEDURE set_insert_sum ();

CREATE OR REPLACE FUNCTION set_update_sum() RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'UPDATE' THEN
        UPDATE result_summas SET result=NEW.january + NEW.february+NEW.march+NEW.april +NEW.may + NEW.june + NEW.july +new.august + NEW.september + NEW.october + NEW.november+ NEW.december WHERE id=OLD.id;
        RETURN NEW;
    END IF;
END;
$$ LANGUAGE plpgsql;


create trigger update_sum
after update of january,february,march,april,may,june,july,august,september,october,november,december
on result_summas
for each row
execute procedure set_update_sum();

-- +migrate StatementEnd
-- +migrate Down
-- +migrate StatementBegin
DROP FUNCTION IF EXISTS public.set_insert_sum() CASCADE;
DROP TRIGGER IF EXISTS update_sum ON pension_db CASCADE;
DROP TRIGGER IF EXISTS insert_sum ON pension_db CASCADE;
DROP FUNCTION IF EXISTS set_insert_sum() CASCADE ;
DROP FUNCTION IF EXISTS set_update_sum() CASCADE ;
-- +migrate StatementEnd