CREATE TABLE IF NOT EXISTS api_keys
(
    api_key uuid DEFAULT gen_random_uuid() PRIMARY KEY
    );

CREATE TABLE IF NOT EXISTS roles
(
    role_id int PRIMARY KEY,
    name    varchar(20) NOT NULL
    );

CREATE TABLE IF NOT EXISTS countries
(
    country_id varchar(2)  NOT NULL PRIMARY KEY,
    name       varchar(50) NOT NULL
    );

CREATE TABLE IF NOT EXISTS languages
(
    lang_id varchar(3)  NOT NULL PRIMARY KEY,
    name    varchar(50) NOT NULL
    );

CREATE TABLE IF NOT EXISTS authors
(
    author_id       uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    name            varchar(150) NOT NULL,
    profile_pic_url varchar(1500)
    );

CREATE TABLE IF NOT EXISTS platforms
(
    platform_id  uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    name         varchar(50)   NOT NULL,
    redirect_url varchar(1500) NOT NULL,
    logo_url     varchar(1500) NOT NULL
    );

CREATE TABLE IF NOT EXISTS passwords
(
    password_id          uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    hashed_password      varchar(1500) NOT NULL,
    last_hashed_password varchar(1500),
    update_date          date,
    user_id              uuid          NOT NULL
    );

CREATE TABLE IF NOT EXISTS users
(
    user_id         uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    public_name     varchar(50)  NOT NULL,
    email           varchar(300) NOT NULL UNIQUE,
    first_name      varchar(300) NOT NULL,
    last_name       varchar(300) NOT NULL,
    birth_date      date         NOT NULL,
    phone_number    varchar(30),
    profile_pic_url varchar(1500),
    biography       varchar(1000),
    lang_id         varchar(3)   NOT NULL,
    country_id      varchar(2)   NOT NULL,
    role_id         int          NOT NULL
    );

CREATE TABLE IF NOT EXISTS categories
(
    category_id    uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    name           varchar(100) NOT NULL,
    description    varchar(300) NOT NULL,
    selected_count int  DEFAULT 0,
    icon_url       varchar(1500),
    lang_id        varchar(3)   NOT NULL
    );

CREATE TABLE IF NOT EXISTS podcasts
(
    podcast_id     uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    name           varchar(100)  NOT NULL,
    description    varchar(300)  NOT NULL,
    total_views    int  DEFAULT 0,
    redirect_url   varchar(1000) NOT NULL,
    cover_pic_url  varchar(1000),
    trailer_url    varchar(1000),
    rating         float,
    total_episodes int,
    total_length   varchar(20),
    release_date   date,
    update_date    date,
    lang_id        varchar(3)    NOT NULL,
    platform_id    uuid          NOT NULL,
    author_id      uuid          NOT NULL
    );

CREATE TABLE IF NOT EXISTS reviews
(
    review_id   uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    title       varchar(300) NOT NULL,
    review      varchar(500) NOT NULL,
    rate        float        NOT NULL,
    review_date date         NOT NULL,
    lang_id     varchar(3)   NOT NULL,
    user_id     uuid         NOT NULL,
    podcast_id  uuid         NOT NULL
    );

CREATE TABLE IF NOT EXISTS lists
(
    list_id       uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    name          varchar(300) NOT NULL,
    description   varchar(500) NOT NULL,
    icon_url      varchar(1000),
    cover_pic_url varchar(1000),
    likes         int  DEFAULT 0,
    user_id       uuid         NOT NULL
    );

CREATE TABLE IF NOT EXISTS lists_podcast
(
    lists_podcast_id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    podcast_id       uuid NOT NULL,
    list_id          uuid NOT NULL
    );

CREATE TABLE IF NOT EXISTS category_user
(
    category_user_id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    category_id      uuid NOT NULL,
    user_id          uuid NOT NULL
    );

CREATE TABLE IF NOT EXISTS category_podcast
(
    category_podcast_id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    podcast_id          uuid NOT NULL,
    category_id         uuid NOT NULL
    );

CREATE TABLE IF NOT EXISTS platform_podcast
(
    platform_podcast_id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    podcast_id          uuid NOT NULL,
    platform_id         uuid NOT NULL
    );

-- Foreign keys

-- Passwords table
ALTER TABLE passwords
    ADD CONSTRAINT password_user_id_fk
        FOREIGN KEY (user_id)
            REFERENCES users (user_id);

-- Category_user table
ALTER TABLE category_user
    ADD CONSTRAINT category_user_user_id_fk
        FOREIGN KEY (user_id)
            REFERENCES users (user_id);

ALTER TABLE category_user
    ADD CONSTRAINT category_user_category_id_fk
        FOREIGN KEY (category_id)
            REFERENCES categories (category_id);

-- Categories table
ALTER TABLE categories
    ADD CONSTRAINT categories_lang_id_fk
        FOREIGN KEY (lang_id)
            REFERENCES languages (lang_id);

-- Category_podcast table
ALTER TABLE category_podcast
    ADD CONSTRAINT category_podcast_podcast_id_fk
        FOREIGN KEY (podcast_id)
            REFERENCES podcasts (podcast_id);

ALTER TABLE category_podcast
    ADD CONSTRAINT category_podcast_category_id_fk
        FOREIGN KEY (category_id)
            REFERENCES categories (category_id);

-- Users table
ALTER TABLE users
    ADD CONSTRAINT users_role_id_fk
        FOREIGN KEY (role_id)
            REFERENCES roles (role_id);

ALTER TABLE users
    ADD CONSTRAINT users_country_id_fk
        FOREIGN KEY (country_id)
            REFERENCES countries (country_id);

ALTER TABLE users
    ADD CONSTRAINT users_lang_id_fk
        FOREIGN KEY (lang_id)
            REFERENCES languages (lang_id);

-- Reviews table
ALTER TABLE reviews
    ADD CONSTRAINT reviews_podcast_id_fk
        FOREIGN KEY (podcast_id)
            REFERENCES podcasts (podcast_id);

ALTER TABLE reviews
    ADD CONSTRAINT reviews_user_id_fk
        FOREIGN KEY (user_id)
            REFERENCES users (user_id);

ALTER TABLE reviews
    ADD CONSTRAINT reviews_lang_id_fk
        FOREIGN KEY (lang_id)
            REFERENCES languages (lang_id);

-- Platform_podcast table
ALTER TABLE platform_podcast
    ADD CONSTRAINT foreign_key
        FOREIGN KEY (podcast_id)
            REFERENCES podcasts (podcast_id);

ALTER TABLE platform_podcast
    ADD CONSTRAINT platform_podcast_id_fk
        FOREIGN KEY (platform_id)
            REFERENCES platforms (platform_id);

-- Podcasts table
ALTER TABLE podcasts
    ADD CONSTRAINT podcasts_lang_id_fk
        FOREIGN KEY (lang_id)
            REFERENCES languages (lang_id);

ALTER TABLE podcasts
    ADD CONSTRAINT podcasts_podcast_id_fk
        FOREIGN KEY (platform_id)
            REFERENCES platforms (platform_id);

ALTER TABLE podcasts
    ADD CONSTRAINT podcasts_author_id_fk
        FOREIGN KEY (author_id)
            REFERENCES authors (author_id);


-- Lists table
ALTER TABLE lists
    ADD CONSTRAINT lists_user_id_fk
        FOREIGN KEY (user_id)
            REFERENCES users (user_id);

ALTER TABLE lists_podcast
    ADD CONSTRAINT lists_podcast_podcast_id_fk
        FOREIGN KEY (podcast_id)
            REFERENCES podcasts (podcast_id);

ALTER TABLE lists_podcast
    ADD CONSTRAINT lists_podcast_list_id_fk
        FOREIGN KEY (list_id)
            REFERENCES lists (list_id);

--
-- Stored Procedures
--

CREATE OR REPLACE FUNCTION SP_GetAllUsers()
    RETURNS TABLE
            (
                user_id         uuid,
                public_name     varchar,
                email           varchar,
                first_name      varchar,
                last_name       varchar,
                birth_date      date,
                phone_number    varchar,
                profile_pic_url varchar,
                biography       varchar,
                lang            varchar,
                country         varchar,
                role            varchar
            )
AS
$$
SELECT users.user_id,
       users.public_name,
       users.email,
       users.first_name,
       users.last_name,
       users.birth_date,
       users.phone_number,
       users.profile_pic_url,
       users.biography,
       languages.name as lang,
       countries.name as country,
       roles.name     as role
FROM users
         INNER JOIN roles on roles.role_id = users.role_id
         INNER JOIN countries on countries.country_id = users.country_id
         INNER JOIN languages on languages.lang_id = users.lang_id
    $$ LANGUAGE sql;

-- Procedure to get likes by a given user ID
CREATE OR REPLACE FUNCTION SP_GetLikesByUserID(userID uuid)
    RETURNS TABLE
            (
                category_id uuid,
                name        varchar
            )
AS
$$
SELECT (
        categories.category_id,
        categories.name
           )
FROM categories
         INNER JOIN category_user cu on categories.category_id = cu.category_id
WHERE cu.user_id = userID
    $$ LANGUAGE sql;

-- Procedure to get user role by user email
CREATE OR REPLACE FUNCTION SP_GetUserRoleByEmail(userEmail varchar)
    RETURNS TABLE
            (
                role varchar
            )
AS
$$
SELECT (
           roles.name
           )
FROM roles
         INNER JOIN users u on u.role_id = roles.role_id
WHERE u.email = userEmail
    $$ LANGUAGE sql;

-- Get all categories with language name
CREATE OR REPLACE FUNCTION SP_GetAllCategories()
    RETURNS TABLE
            (
                category_id    uuid,
                name           varchar,
                description    varchar,
                selected_count int,
                icon_url       varchar,
                lang           varchar
            )
AS
$$
SELECT (
        categories.category_id,
        categories.name,
        categories.description,
        categories.selected_count,
        categories.icon_url,
        languages.name
           )
FROM categories
         INNER JOIN languages on categories.lang_id = languages.lang_id
    $$ LANGUAGE sql;

CREATE OR REPLACE FUNCTION SP_GetAllCategoriesByLangCode(langCode varchar)
    RETURNS TABLE
            (
                category_id    uuid,
                name           varchar,
                description    varchar,
                selected_count int,
                icon_url       varchar,
                lang           varchar
            )
AS
$$
SELECT (
        categories.category_id,
        categories.name,
        categories.description,
        categories.selected_count,
        categories.icon_url,
        languages.name
           )
FROM categories
         INNER JOIN languages on categories.lang_id = languages.lang_id
WHERE languages.lang_id = langCode
    $$ LANGUAGE sql;


-- Default roles
INSERT INTO roles (role_id, name)
VALUES (1, 'admin');
INSERT INTO roles (role_id, name)
VALUES (2, 'user');


-- Default langs
INSERT INTO languages (lang_id, name)
VALUES ('ESP', 'Español');
INSERT INTO languages (lang_id, name)
VALUES ('ENG', 'English');


INSERT INTO countries (country_id, name)
VALUES ('CO', 'Colombia');

INSERT INTO api_keys (api_key)
VALUES ('11635d96-098d-4869-b7cf-baeae575ab20');

-- GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO apptalksup;


-- Example data
-- REMOVE WHEN PROD!!
INSERT INTO users (user_id, public_name, email, first_name, last_name, birth_date, phone_number, profile_pic_url,
                   biography, lang_id, country_id, role_id)
VALUES ('86f45ee6-c5a4-11ec-b46f-6a2f678b91f3', 'hinval', 'sebasvil20@gmail.com', 'Sebastian', 'Villegas', '2002-08-12',
        '3053190789', null, null, 'ESP', 'CO', 1);

INSERT INTO passwords (password_id, hashed_password, user_id)
VALUES ('1b937b4b-b43f-4a70-8b0b-2255c2615151', '$2a$14$nP6hIrQ/.Uf2Ll8sA88zjuy01KmY/DzyVExkt3XKNpMO2073i9Smy',
        '86f45ee6-c5a4-11ec-b46f-6a2f678b91f3');

INSERT INTO categories (category_id, name, description, lang_id)
VALUES ('35b2881c-210c-4160-b3f7-6252b9ebee49', 'Terror', 'Podcasts que te hacen la piel de gallina', 'ESP');
INSERT INTO categories (category_id, name, description, lang_id)
VALUES ('55abaa24-b920-43ea-bf94-aee5f614e326', 'Misterio',
        'Perfectos para una tarde donde te sientes todo un detective', 'ESP');
INSERT INTO categories (name, description, lang_id)
VALUES ('Historia', 'Aprende con los mejores en el tema', 'ESP');


INSERT INTO category_user (category_id, user_id)
VALUES ('35b2881c-210c-4160-b3f7-6252b9ebee49', '86f45ee6-c5a4-11ec-b46f-6a2f678b91f3');
INSERT INTO category_user (category_id, user_id)
VALUES ('55abaa24-b920-43ea-bf94-aee5f614e326', '86f45ee6-c5a4-11ec-b46f-6a2f678b91f3');