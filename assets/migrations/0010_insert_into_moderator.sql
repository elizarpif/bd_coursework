
-- +migrate Up
-- +migrate StatementBegin
INSERT INTO moderator.users (id, login, password) VALUES (uuid_generate_v4(), 'worker', 'worker');
INSERT INTO moderator.users (id, login, password) VALUES (uuid_generate_v4(), 'liza', 'liza');

create or replace function moderator(IN loginIn varchar, IN passwIN varchar) returns bool
AS
$$
DECLARE
    record  uuid;
BEGIN
    SELECT id INTO STRICT record FROM moderator.users WHERE login = loginIn AND password = passwIN;

    return FOUND;
        EXCEPTION
        WHEN NO_DATA_FOUND THEN
            return FOUND;
        WHEN TOO_MANY_ROWS THEN
            return FOUND;

END;
$$ LANGUAGE plpgsql;
-- +migrate StatementEnd
-- +migrate Down
-- +migrate StatementBegin
DELETE from moderator.users;
DROP FUNCTION if exists moderator() CASCADE;
-- +migrate StatementEnd