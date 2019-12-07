-- +migrate Up
-- +migrate StatementBegin
-- result_summas
INSERT INTO result_summas (id, january, id_retirees)
VALUES (uuid_generate_v4(), 7600, (SELECT id
                                   FROM retirees
                                   where name = 'Elena'
                                     and surname = 'Ivanova'
                                     and insurance_number_of_individual_personal_account = '163-648-564 96'));
-- CREATE VIEW information_about_retiree AS
--     SELECT name, surname, patronymic, registration_date, insurance_number_of_individual_personal_account, address FROM retirees
--     WHERE name
CREATE OR REPLACE FUNCTION info_retiree(IN namein varchar, IN surnamein varchar, IN snilsin VARCHAR)
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
                 WHERE r.name = namein
                   AND r.surname = surnamein
                   AND r.insurance_number_of_individual_personal_account = snilsin;
END;
$$ LANGUAGE plpgsql;


-- +migrate StatementEnd
-- +migrate Down
-- +migrate StatementBegin
--result_summas
DELETE
FROM result_summas
WHERE id_retirees = (SELECT id
                     FROM retirees
                     where name = 'Elena'
                       and surname = 'Ivanova'
                       and insurance_number_of_individual_personal_account = '163-648-564 96');
DROP FUNCTION if exists info_retiree CASCADE;
-- +migrate StatementEnd