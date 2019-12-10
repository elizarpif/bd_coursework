-- +migrate Up
-- +migrate StatementBegin
CREATE SCHEMA moderator;
ALTER SCHEMA moderator OWNER TO pension_dba;

CREATE TABLE moderator.users
(
    id       uuid         NOT NULL,
    login    varchar(30)  NOT NULL,
    password varchar(128) NOT NULL,
    CONSTRAINT moderator_pkey PRIMARY KEY (id)

);

ALTER TABLE moderator.users
    OWNER TO pension_dba;
GRANT USAGE
   ON SCHEMA moderator
   TO pension_worker;
-- ddl-end --

-- object: grant_8bf061a24e | type: PERMISSION --
GRANT SELECT
   ON TABLE moderator.users
   TO pension_worker;

-- +migrate StatementEnd
-- +migrate Down
-- +migrate StatementBegin

DROP TABLE IF EXISTS moderator.users CASCADE;
DROP SCHEMA IF EXISTS moderator CASCADE;
-- +migrate StatementEnd