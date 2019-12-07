-- +migrate Up
-- +migrateStatementBegin
INSERT INTO retirees (id, name, surname, patronymic, registration_date, insurance_number_of_individual_personal_account,
                      address)
VALUES (uuid_generate_v4(),'Гарри','Поттер','Альфред', '2013-07-23', '103-048-564 90', 'Лондон, ул Некая, д 3');
-- +migrateStatementEnd

-- +migrate Down
-- +migrateStatementBegin
delete from retirees where insurance_number_of_individual_personal_account='103-048-564 90';
-- +migrateStatementEnd