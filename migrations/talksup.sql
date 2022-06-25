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
    biography       varchar(500),
    profile_pic_url varchar(1500)
);

CREATE TABLE IF NOT EXISTS platforms
(
    platform_id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    name        varchar(50)   NOT NULL,
    logo_url    varchar(1500) NOT NULL
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
    first_name      varchar(300),
    last_name       varchar(300),
    birth_date      date,
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
    name           varchar(100) NOT NULL UNIQUE,
    description    varchar(300) NOT NULL,
    selected_count int  DEFAULT 0,
    icon_url       varchar(1500),
    lang_id        varchar(3)   NOT NULL
);

CREATE TABLE IF NOT EXISTS podcasts
(
    podcast_id     uuid  DEFAULT gen_random_uuid() PRIMARY KEY,
    name           varchar(100) NOT NULL,
    description    varchar(800) NOT NULL,
    total_views    int   DEFAULT 0,
    cover_pic_url  varchar(1000),
    trailer_url    varchar(1000),
    rating         float DEFAULT 0,
    total_episodes int,
    total_length   varchar(20),
    release_date   date,
    update_date    date,
    lang_id        varchar(3)   NOT NULL,
    author_id      uuid         NOT NULL
);

CREATE TABLE IF NOT EXISTS reviews
(
    review_id   uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    title       varchar(300) NOT NULL,
    review      varchar(500) NOT NULL,
    rate        float        NOT NULL CHECK (rate >= 0 and rate <= 5),
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
    podcast_id          uuid          NOT NULL,
    platform_id         uuid          NOT NULL,
    redirect_url        varchar(1000) NOT NULL
);

CREATE TABLE IF NOT EXISTS likes
(
    like_id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    list_id uuid NOT NULL,
    user_id uuid NOT NULL
);


-- Foreign keys

-- Passwords table
ALTER TABLE passwords
    ADD CONSTRAINT password_user_id_fk
        FOREIGN KEY (user_id)
            REFERENCES users (user_id) ON DELETE cascade;

-- Likes table
ALTER TABLE likes
    ADD CONSTRAINT likes_user_id_fk
        FOREIGN KEY (user_id)
            REFERENCES users (user_id) ON DELETE CASCADE;

ALTER TABLE likes
    ADD CONSTRAINT likes_list_id_fk
        FOREIGN KEY (list_id)
            REFERENCES lists (list_id) ON DELETE CASCADE;

ALTER TABLE likes
    ADD CONSTRAINT likes_list_user_uq UNIQUE (user_id, list_id);

-- Category_user table
ALTER TABLE category_user
    ADD CONSTRAINT category_user_user_id_fk
        FOREIGN KEY (user_id)
            REFERENCES users (user_id) ON DELETE CASCADE;

ALTER TABLE category_user
    ADD CONSTRAINT category_user_category_id_fk
        FOREIGN KEY (category_id)
            REFERENCES categories (category_id);

ALTER TAbLE category_user
    ADD CONSTRAINT category_user_uq UNIQUE (category_id, user_id);

-- Categories table
ALTER TABLE categories
    ADD CONSTRAINT categories_lang_id_fk
        FOREIGN KEY (lang_id)
            REFERENCES languages (lang_id);

-- Category_podcast table
ALTER TABLE category_podcast
    ADD CONSTRAINT category_podcast_podcast_id_fk
        FOREIGN KEY (podcast_id)
            REFERENCES podcasts (podcast_id) ON DELETE cascade;

ALTER TABLE category_podcast
    ADD CONSTRAINT category_podcast_category_id_fk
        FOREIGN KEY (category_id)
            REFERENCES categories (category_id);

ALTER TAbLE category_podcast
    ADD CONSTRAINT category_podcast_uq UNIQUE (category_id, podcast_id);

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
            REFERENCES languages (lang_id) ON DELETE CASCADE;

-- Reviews table
ALTER TABLE reviews
    ADD CONSTRAINT reviews_podcast_id_fk
        FOREIGN KEY (podcast_id)
            REFERENCES podcasts (podcast_id) ON DELETE CASCADE;

ALTER TAbLE reviews
    ADD CONSTRAINT reviews_user_podcast_uq UNIQUE (user_id, podcast_id);

ALTER TABLE reviews
    ADD CONSTRAINT reviews_user_id_fk
        FOREIGN KEY (user_id)
            REFERENCES users (user_id) ON DELETE CASCADE;


ALTER TABLE reviews
    ADD CONSTRAINT reviews_lang_id_fk
        FOREIGN KEY (lang_id)
            REFERENCES languages (lang_id);

-- Platform_podcast table
ALTER TABLE platform_podcast
    ADD CONSTRAINT platform_podcast_podcast_id_fk
        FOREIGN KEY (podcast_id)
            REFERENCES podcasts (podcast_id) ON DELETE cascade;

ALTER TABLE platform_podcast
    ADD CONSTRAINT platform_podcast_platform_id_fk
        FOREIGN KEY (platform_id)
            REFERENCES platforms (platform_id);

ALTER TAbLE platform_podcast
    ADD CONSTRAINT platform_podcast_uq UNIQUE (platform_id, podcast_id);

-- Podcasts table
ALTER TABLE podcasts
    ADD CONSTRAINT podcasts_lang_id_fk
        FOREIGN KEY (lang_id)
            REFERENCES languages (lang_id);

ALTER TABLE podcasts
    ADD CONSTRAINT podcasts_author_id_fk
        FOREIGN KEY (author_id)
            REFERENCES authors (author_id) ON DELETE CASCADE;


-- Lists table
ALTER TABLE lists
    ADD CONSTRAINT lists_user_id_fk
        FOREIGN KEY (user_id)
            REFERENCES users (user_id) ON DELETE CASCADE;

ALTER TABLE lists_podcast
    ADD CONSTRAINT lists_podcast_podcast_id_fk
        FOREIGN KEY (podcast_id)
            REFERENCES podcasts (podcast_id) ON DELETE CASCADE;

ALTER TABLE lists_podcast
    ADD CONSTRAINT lists_podcast_list_id_fk
        FOREIGN KEY (list_id)
            REFERENCES lists (list_id) ON DELETE cascade;

ALTER TAbLE lists_podcast
    ADD CONSTRAINT list_podcast_uq UNIQUE (list_id, podcast_id);


/*
=================================
=================================

Stored Procedures

=================================
=================================
*/

-- SP to get all users with full info
CREATE
    OR REPLACE FUNCTION SP_GetAllUsers()
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
                lang_id            varchar,
                country_id         varchar,
                role_id            varchar
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
       languages.lang_id,
       countries.country_id,
       roles.role_id
FROM users
         INNER JOIN roles on roles.role_id = users.role_id
         INNER JOIN countries on countries.country_id = users.country_id
         INNER JOIN languages on languages.lang_id = users.lang_id
$$ LANGUAGE sql;

-- SP to get likes by a given user ID
CREATE
    OR REPLACE FUNCTION SP_GetLikesByUserID(userID uuid)
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
CREATE
    OR REPLACE FUNCTION SP_GetUserRoleByEmail(userEmail varchar)
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
CREATE
    OR REPLACE FUNCTION SP_GetAllCategories()
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

-- SP to get all categories by lang code
CREATE
    OR REPLACE FUNCTION SP_GetAllCategoriesByLangCode(langCode varchar)
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

-- SP to get all categories of a podcast
CREATE
    OR REPLACE FUNCTION SP_GetPodcastCategories(podcastID uuid)
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
         INNER JOIN category_podcast cp on categories.category_id = cp.category_id
WHERE cp.podcast_id = podcastID
$$ LANGUAGE sql;

-- SP to get all platfors of a podcast
CREATE
    OR REPLACE FUNCTION SP_GetPodcastPlatform(podcastID uuid)
    RETURNS TABLE
            (
                platform_id  uuid,
                redirect_url varchar,
                name         varchar,
                logo_url     varchar
            )
AS
$$
SELECT (
        platforms.platform_id,
        pp.redirect_url,
        platforms.name,
        platforms.logo_url
           )
FROM platforms
         INNER JOIN platform_podcast pp on platforms.platform_id = pp.platform_id
WHERE pp.podcast_id = podcastID
$$ LANGUAGE sql;

-- SP to get all podcasts by category id
CREATE
    OR REPLACE FUNCTION SP_GetPodcastsByCategoryID(categoryID uuid)
    RETURNS TABLE
            (
                podcast_id     uuid,
                name           varchar,
                description    varchar,
                total_views    int,
                cover_pic_url  varchar,
                trailer_url    varchar,
                rating         float,
                total_episodes int,
                total_length   varchar,
                release_date   date,
                update_date    date,
                lang_id        varchar,
                author_id      uuid
            )
AS
$$
SELECT (
        podcasts.podcast_id,
        podcasts.name,
        podcasts.description,
        podcasts.total_views,
        podcasts.cover_pic_url,
        podcasts.trailer_url,
        podcasts.rating,
        podcasts.total_episodes,
        podcasts.total_length,
        podcasts.release_date,
        podcasts.update_date,
        podcasts.lang_id,
        podcasts.author_id
           )
FROM podcasts
         INNER JOIN category_podcast cp on podcasts.podcast_id = cp.podcast_id
WHERE cp.category_id = categoryID
ORDER BY podcasts.update_date DESC
$$ LANGUAGE sql;


-- SP to get all podcasts that belongs to a list
CREATE
    OR REPLACE FUNCTION SP_GetPodcastsInList(listID uuid)
    RETURNS TABLE
            (
                podcast_id     uuid,
                name           varchar,
                description    varchar,
                total_views    int,
                cover_pic_url  varchar,
                trailer_url    varchar,
                rating         float,
                total_episodes int,
                total_length   varchar,
                release_date   date,
                update_date    date,
                lang_id        varchar,
                author_id      uuid
            )
AS
$$
SELECT (
        podcasts.podcast_id,
        podcasts.name,
        podcasts.description,
        podcasts.total_views,
        podcasts.cover_pic_url,
        podcasts.trailer_url,
        podcasts.rating,
        podcasts.total_episodes,
        podcasts.total_length,
        podcasts.release_date,
        podcasts.update_date,
        podcasts.lang_id,
        podcasts.author_id
           )
FROM podcasts
         INNER JOIN lists_podcast lp on podcasts.podcast_id = lp.podcast_id
WHERE lp.list_id = listID
$$ LANGUAGE sql;


/*
=================================
=================================

Triggers

=================================
=================================
*/


--Trigger to sum up rating

CREATE OR REPLACE FUNCTION TRG_CalculateAvgRate()
    RETURNS trigger AS
$$
BEGIN
    UPDATE podcasts
    SET rating = ((SELECT SUM(rate) FROM reviews WHERE podcast_id = NEW.podcast_id GROUP BY podcast_id) /
                  (SELECT COUNT(review_id) FROM reviews WHERE podcast_id = NEW.podcast_id)
        )
    WHERE podcasts.podcast_id = NEW.podcast_id;
    RETURN NEW;

END ;
$$
    LANGUAGE 'plpgsql';

CREATE TRIGGER CalculateAvgRate
    AFTER INSERT OR DELETE
    ON reviews
    FOR EACH ROW
EXECUTE PROCEDURE TRG_CalculateAvgRate();


-- Triger to sum up likes

CREATE OR REPLACE FUNCTION TRG_SumLikes()
    RETURNS trigger AS
$$
BEGIN
    UPDATE lists SET likes = lists.likes + 1 WHERE lists.list_id = NEW.list_id;
    RETURN NEW;

END;
$$
    LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION TRG_RestLikes()
    RETURNS trigger AS
$$
BEGIN
    UPDATE lists SET likes = (lists.likes - 1) WHERE lists.list_id = OLD.list_id;
    RETURN OLD;

END;
$$
    LANGUAGE 'plpgsql';


CREATE TRIGGER SumListsLikes
    AFTER INSERT
    ON likes
    FOR EACH ROW
EXECUTE PROCEDURE TRG_SumLikes();

CREATE TRIGGER RestListsLikes
    BEFORE DELETE
    ON likes
    FOR EACH ROW
EXECUTE PROCEDURE TRG_RestLikes();



/*
=================================
=================================
Example data
=================================
=================================
   */

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

INSERT INTO public.users (user_id, public_name, email, first_name, last_name, birth_date, phone_number, profile_pic_url, biography, lang_id, country_id, role_id) VALUES ('86f45ee6-c5a4-11ec-b46f-6a2f678b91f3', 'hinval', 'sebasvil20@gmail.com', 'Sebastian', 'Villegas', '2002-08-12', '3053190789', 'https://talksupcdn.sfo3.cdn.digitaloceanspaces.com/0dd33cc8-f257-11ec-89a7-d6922f1c06cc.jpeg', ' Un escritor, poeta, crítico y periodista romántico estadounidense, generalmente reconocido como uno de los maestros universales del relato corto, del cual fue uno de los primeros practicantes en su país. Fue renovador de la novela gótica, recordado especialmente por sus cuentos de terror.', 'ESP', 'CO', 1);
INSERT INTO public.users (user_id, public_name, email, first_name, last_name, birth_date, phone_number, profile_pic_url, biography, lang_id, country_id, role_id) VALUES ('f9b3da61-f257-11ec-89a7-d6922f1c06cc', 'Julicobain', 'juliana@gmail.com', 'Juliana', 'Cobain', '2009-12-31', '', 'https://talksupcdn.sfo3.cdn.digitaloceanspaces.com/2d1f756e-f258-11ec-89a7-d6922f1c06cc.jpeg', '', 'ESP', 'CO', 2);
INSERT INTO public.users (user_id, public_name, email, first_name, last_name, birth_date, phone_number, profile_pic_url, biography, lang_id, country_id, role_id) VALUES ('ca132fa7-f259-11ec-89a7-d6922f1c06cc', 'Joe the boss', 'joe@gmail.com', 'Joseph', 'Zap', '2009-12-30', '', 'https://talksupcdn.sfo3.cdn.digitaloceanspaces.com/f6d831aa-f259-11ec-89a7-d6922f1c06cc.jpeg', '', 'ESP', 'CO', 2);
INSERT INTO public.users (user_id, public_name, email, first_name, last_name, birth_date, phone_number, profile_pic_url, biography, lang_id, country_id, role_id) VALUES ('f3b0f750-f369-11ec-9e9a-064f6a232da8', 'Jhosuan ', 'andresavilez125@gmail.com', 'Jhosuan ', 'Avielez', '2001-04-18', '6464947979', '', '', 'ESP', 'CO', 2);
INSERT INTO public.users (user_id, public_name, email, first_name, last_name, birth_date, phone_number, profile_pic_url, biography, lang_id, country_id, role_id) VALUES ('0e6c7c39-f3ff-11ec-b6ff-7ee893ee5efc', 'Juanda', 'desmon2009@gmail.com', 'Juan', 'Arboleda', '1998-01-01', '6', '', 'asdas', 'ESP', 'CO', 2);
INSERT INTO public.users (user_id, public_name, email, first_name, last_name, birth_date, phone_number, profile_pic_url, biography, lang_id, country_id, role_id) VALUES ('809a9f57-f416-11ec-b6ff-7ee893ee5efc', 'Trueni', 'sansepulveda90@gmail.com', 'Santiago', 'Sepúlveda', '2000-02-08', '3016395335', 'https://talksupcdn.sfo3.cdn.digitaloceanspaces.com/bbc77096-f416-11ec-b6ff-7ee893ee5efc.jpg', 'Hola. Soy Trueni. Me gustan las papas y el tinto de la cafetería de afuera', 'ESP', 'CO', 1);

INSERT INTO public.passwords (password_id, hashed_password, last_hashed_password, update_date, user_id) VALUES ('1b937b4b-b43f-4a70-8b0b-2255c2615151', '$2a$14$nP6hIrQ/.Uf2Ll8sA88zjuy01KmY/DzyVExkt3XKNpMO2073i9Smy', null, null, '86f45ee6-c5a4-11ec-b46f-6a2f678b91f3');
INSERT INTO public.passwords (password_id, hashed_password, last_hashed_password, update_date, user_id) VALUES ('bfaec956-d9ad-486b-ba51-534a9af48775', '$2a$14$qGVoXpf4uDmT1onX1IKsOOXUlmEnx/KK5jvYCl4B2slGiBEXT1Bzm', '', null, 'f9b3da61-f257-11ec-89a7-d6922f1c06cc');
INSERT INTO public.passwords (password_id, hashed_password, last_hashed_password, update_date, user_id) VALUES ('10fd7aa2-f5d5-4b82-8c73-eaef6d9298c2', '$2a$14$3/TLmUyWnoaonUVeQvAzZe3vgPG1rfzrFZTOMdNT/0MKPfxnEhQua', '', null, 'ca132fa7-f259-11ec-89a7-d6922f1c06cc');
INSERT INTO public.passwords (password_id, hashed_password, last_hashed_password, update_date, user_id) VALUES ('0fc09a72-bb10-4f2a-94ce-8dcc1dbee1a1', '$2a$14$v8MZe5nb1u0wP3Rk1BwfwO/Ia5Fvrq2.Ygn3eF0801C.9/1V0ljQC', '', null, 'f3b0f750-f369-11ec-9e9a-064f6a232da8');
INSERT INTO public.passwords (password_id, hashed_password, last_hashed_password, update_date, user_id) VALUES ('4cf0c3f9-fe7d-4ce8-9154-4b28d06fbdf0', '$2a$14$ELSPHAzFke21FojEsmz30.jCplP7qgNZaTHCJuJZerntOLKEsNBRW', '', null, '0e6c7c39-f3ff-11ec-b6ff-7ee893ee5efc');
INSERT INTO public.passwords (password_id, hashed_password, last_hashed_password, update_date, user_id) VALUES ('4775f9be-5c0f-4aaa-8131-2ae3f5b5f45e', '$2a$14$cu1qc/Vh9D8PYVBOFUvwROmvydgiwlX4ofUDY0SHaVvJRKB9Izaom', '', null, '809a9f57-f416-11ec-b6ff-7ee893ee5efc');


INSERT INTO public.categories (category_id, name, description, selected_count, icon_url, lang_id)
VALUES ('7ffc646a-d168-11ec-8bd1-acde48001122', 'Fantasía',
        'Podcasts que te llevan a imaginar otro mundo fuera de las posibilidades de tu imaginación', 0,
        'https://talksupcdn.sfo3.cdn.digitaloceanspaces.com/7894e1a2-d168-11ec-8bd1-acde48001122.png', 'ESP');
INSERT INTO public.categories (category_id, name, description, selected_count, icon_url, lang_id)
VALUES ('dc9c3550-d169-11ec-8bd1-acde48001122', 'Ciencia',
        'Interesantes temas que te harán re-descubrir el mundo desde una perspectiva científica', 0,
        'https://talksupcdn.sfo3.cdn.digitaloceanspaces.com/d561d31c-d169-11ec-8bd1-acde48001122.png', 'ESP');
INSERT INTO public.categories (category_id, name, description, selected_count, icon_url, lang_id)
VALUES ('73220619-faf6-498d-8800-e1d5f468d88a', 'Filosofía', 'Reflexiones', 0,
        'https://talksupcdn.sfo3.cdn.digitaloceanspaces.com/8497a06a-d169-11ec-8bd1-acde48001122.png', 'ESP');
INSERT INTO public.categories (category_id, name, description, selected_count, icon_url, lang_id)
VALUES ('2da2f856-e235-436c-bdce-7471b0162846', 'Psicología', 'Análisis', 0,
        'https://talksupcdn.sfo3.cdn.digitaloceanspaces.com/f7dac07a-d169-11ec-8bd1-acde48001122.png', 'ESP');
INSERT INTO public.categories (category_id, name, description, selected_count, icon_url, lang_id)
VALUES ('35b2881c-210c-4160-b3f7-6252b9ebee49', 'Terror', 'Podcasts que te hacen la piel de gallina', 0,
        'https://talksupcdn.sfo3.cdn.digitaloceanspaces.com/7e0139d6-d16a-11ec-8bd1-acde48001122.png', 'ESP');
INSERT INTO public.categories (category_id, name, description, selected_count, icon_url, lang_id)
VALUES ('55abaa24-b920-43ea-bf94-aee5f614e326', 'Misterio',
        'Perfectos para una tarde donde te sientes todo un detective', 0,
        'https://talksupcdn.sfo3.cdn.digitaloceanspaces.com/51ecb71c-d16a-11ec-8bd1-acde48001122.png', 'ESP');
INSERT INTO public.categories (category_id, name, description, selected_count, icon_url, lang_id)
VALUES ('472aa79f-fc3a-46d7-8b4b-b4fab318bb6b', 'Historia', 'Aprende con los mejores en el tema', 0,
        'https://talksupcdn.sfo3.cdn.digitaloceanspaces.com/89204ec4-d16a-11ec-8bd1-acde48001122.png', 'ESP');
INSERT INTO public.categories (category_id, name, description, selected_count, icon_url, lang_id)
VALUES ('f67a4547-31fe-4bba-8556-526cac7f4fa0', 'Influencers',
        'Escucha la historia de vida de tus influences favoritos', 0,
        'https://talksupcdn.sfo3.cdn.digitaloceanspaces.com/a7731492-d16a-11ec-8bd1-acde48001122.png', 'ESP');
INSERT INTO public.categories (category_id, name, description, selected_count, icon_url, lang_id)
VALUES ('4a0f3c26-d16b-11ec-8bd1-acde48001122', 'Comedia',
        'Perfectos para esas tardes aburridas donde solo quieres reir sin parar.', 0,
        'https://talksupcdn.sfo3.cdn.digitaloceanspaces.com/3a0c00a2-d16b-11ec-8bd1-acde48001122.png', 'ESP');
INSERT INTO public.categories (category_id, name, description, selected_count, icon_url, lang_id)
VALUES ('9562cf3e-d194-11ec-a455-acde48001122', 'Negocios y tecnología',
        'Inversiones, criptomonedas, poder y mas en Negocios y Tecnología', 0,
        'https://talksupcdn.sfo3.cdn.digitaloceanspaces.com/83b0103a-d194-11ec-a455-acde48001122.png', 'ESP');

INSERT INTO public.category_user (category_user_id, category_id, user_id) VALUES ('1cbb9c4d-2506-4c17-971a-736d7012cce1', '35b2881c-210c-4160-b3f7-6252b9ebee49', '86f45ee6-c5a4-11ec-b46f-6a2f678b91f3');
INSERT INTO public.category_user (category_user_id, category_id, user_id) VALUES ('9d6ef767-6f19-4acf-bf42-678fe9b28c05', '55abaa24-b920-43ea-bf94-aee5f614e326', '86f45ee6-c5a4-11ec-b46f-6a2f678b91f3');
INSERT INTO public.category_user (category_user_id, category_id, user_id) VALUES ('607399db-4082-4565-919b-006b661d9ddb', '55abaa24-b920-43ea-bf94-aee5f614e326', 'f9b3da61-f257-11ec-89a7-d6922f1c06cc');
INSERT INTO public.category_user (category_user_id, category_id, user_id) VALUES ('ddf8dd67-34e8-4be3-9c83-e1fa8b6be708', '35b2881c-210c-4160-b3f7-6252b9ebee49', 'f9b3da61-f257-11ec-89a7-d6922f1c06cc');
INSERT INTO public.category_user (category_user_id, category_id, user_id) VALUES ('b64feca0-7bc6-436d-ae1e-d0b68106ea8f', '7ffc646a-d168-11ec-8bd1-acde48001122', 'f9b3da61-f257-11ec-89a7-d6922f1c06cc');
INSERT INTO public.category_user (category_user_id, category_id, user_id) VALUES ('3209c34c-8f4c-4472-b5b4-aa076ca0e8fd', '55abaa24-b920-43ea-bf94-aee5f614e326', 'ca132fa7-f259-11ec-89a7-d6922f1c06cc');
INSERT INTO public.category_user (category_user_id, category_id, user_id) VALUES ('e0935f3d-1859-4b65-bb48-786f83aaab14', '35b2881c-210c-4160-b3f7-6252b9ebee49', 'ca132fa7-f259-11ec-89a7-d6922f1c06cc');

INSERT INTO public.authors (author_id, name, biography, profile_pic_url) VALUES ('2eaed1aa-0993-48c5-b95c-c0c2bb43ad1a', 'Cristian Diaz Rodriguez', null, null);
INSERT INTO public.authors (author_id, name, biography, profile_pic_url) VALUES ('d6370d04-ec18-46a0-b995-a81a36c5a573', 'Bali Club', null, null);
INSERT INTO public.authors (author_id, name, biography, profile_pic_url) VALUES ('587678a5-7fb8-49c2-b5d5-fcb0e4f36e0a', 'Relatos de la Noche', null, null);
INSERT INTO public.authors (author_id, name, biography, profile_pic_url) VALUES ('74be97d2-d16b-11ec-8bd1-acde48001122', 'Sospechosamente light', 'Liss Pereira, Tato Cepeda y Santiago Rendón, juntos en Sospechosamente Light.', 'https://i.scdn.co/image/f2f2024adc4de90952b05e64c80a16cbd3cf92b5');
INSERT INTO public.authors (author_id, name, biography, profile_pic_url) VALUES ('03de6f96-d16c-11ec-8bd1-acde48001122', 'La cotorrisa Podcast', 'Ricardo Pérez y Slobotzky se ponen a cotorrear como siempre, pero ahora lo están grabando.', 'https://i.scdn.co/image/ab6765630000ba8a9ed098b86b1f0b5cce92f0c1');
INSERT INTO public.authors (author_id, name, biography, profile_pic_url) VALUES ('e8664e8a-d16d-11ec-8bd1-acde48001122', 'Con ánimo de ofender', 'Canal de Comedia Colombiana Hogar de Con Ánimo De Ofender, la primera serie/documental/vlog de la comedia stand up de Colombia, donde el bullying es la moneda de cambio y el humor negro nuestro estilo de vida; Damas y Caballeros un programa de humor Colombiano no apto para tv, sin censura, sin presupuesto pero Con Ánimo De Ofender', 'https://i.scdn.co/image/ab6765630000ba8afcc4827a5d17d080f5c66024');
INSERT INTO public.authors (author_id, name, biography, profile_pic_url) VALUES ('14719931-fb66-4d03-a16c-b04ddc64435b', 'Dudas Media', null, null);
INSERT INTO public.authors (author_id, name, biography, profile_pic_url) VALUES ('a857e002-d194-11ec-a455-acde48001122', 'Andrés Acevedo Niño', 'Andrés Acevedo Niño es cofundador de 13% Pasión por el trabajo, el principal podcast en español en temas de carrera profesional y trabajo. Escribe para CUMBRE, la plataforma especializada en liderazgo del Colegio de Estudios Superiores en Administración (CESA).', 'https://talksupcdn.sfo3.cdn.digitaloceanspaces.com/e2817988-f01a-11ec-b01c-acde48001122.jpeg');
INSERT INTO public.authors (author_id, name, biography, profile_pic_url) VALUES ('14f108f6-d168-11ec-8bd1-acde48001122', 'Spotify Studios', 'Podcasts originales de Spotify', 'https://talksupcdn.sfo3.cdn.digitaloceanspaces.com/5247693e-f01c-11ec-b01c-acde48001122.webp');
INSERT INTO public.authors (author_id, name, biography, profile_pic_url) VALUES ('e2ba8436-d160-11ec-86d2-acde48001122', 'Marina Mammoliti', 'Soy una apasionada de cada historia, de cada persona. Amo ir descubriendo cómo cada una/o va formando determinados modos de ser, adaptándose al entorno y construyendo herramientas tanto conscientes como inconscientes para lidiar con la cotidianeidad', 'https://talksupcdn.sfo3.cdn.digitaloceanspaces.com/4dfbb802-f01d-11ec-b01c-acde48001122.jpeg');
INSERT INTO public.authors (author_id, name, biography, profile_pic_url) VALUES ('546e8d6a-f13e-405b-8bff-977463b691bb', 'Hernán Melana', null, 'https://talksupcdn.sfo3.cdn.digitaloceanspaces.com/6d800f84-f01d-11ec-b01c-acde48001122.jpeg');
INSERT INTO public.authors (author_id, name, biography, profile_pic_url) VALUES ('c0c0efc6-6e17-4ca4-afae-a8e5c15d8638', 'El Extraordinario', 'El Extraordinario es un sello de pódcast, documentales sonoros y cosas que todavía no existen. Somos pocos pero valientes. Y nos remangamos cada mañana para hacer pódcast periodísticos, pódcast de historia, pódcast de ciencia o lo que haya que hacer.', 'https://talksupcdn.sfo3.cdn.digitaloceanspaces.com/dbd0a800-f251-11ec-84f2-acde48001122.png');
INSERT INTO public.authors (author_id, name, biography, profile_pic_url) VALUES ('687b4f4f-472d-477c-ad79-8bf2fbeb9d50', 'Roberto Mtz', 'Autor independiente, host de Creativo y Cosas', 'https://talksupcdn.sfo3.cdn.digitaloceanspaces.com/9e7eac08-f252-11ec-84f2-acde48001122.jpeg');
INSERT INTO public.authors (author_id, name, biography, profile_pic_url) VALUES ('f5466a78-2360-497a-b735-17e96fe2d0f7', 'Robbie J Frye', 'Robbie J Frye es el host de The Frye Show. Este podcast es una celebración de personas que no aceptan la vida tal como es, la abrazan, la cambian, la mejoran y dejan su huella en ella. ¡They leave a dent in the universe! ', 'https://talksupcdn.sfo3.cdn.digitaloceanspaces.com/b27110c4-f253-11ec-84f2-acde48001122.jpeg');
INSERT INTO public.authors (author_id, name, biography, profile_pic_url) VALUES ('8e34cba2-4694-451b-8ee2-682c78e78098', 'Alvaro Rodriguez', 'Álvaro Rodríguez, es economista de la Universidad Javeriana con magíster en Economía Marítima y Logística de la Universidad Erasmus de Rotterdam, según su cuenta de Linkedin. Es además reconocido por ser creador de la empresa Merqueo y gracias a este ‘emprendimiento’ ha logrado adquirir el conocimiento suficiente para aumentar su capital y así llegar a la posición económica con la que espera seguir ayudando a otros empresarios.', 'https://talksupcdn.sfo3.cdn.digitaloceanspaces.com/e1a8d042-f254-11ec-84f2-acde48001122.jpeg');

INSERT INTO public.platforms (platform_id, name, logo_url)
VALUES ('3eca4a4b-50fd-48e1-a683-fb1ed323eb1e', 'YouTube',
        'https://talksupcdn.sfo3.cdn.digitaloceanspaces.com/1d65925a-e1f2-11ec-9f43-acde48001122.png');
INSERT INTO public.platforms (platform_id, name, logo_url)
VALUES ('eb4b1438-da09-4b37-be59-4d921aeba947', 'Spotify',
        'https://talksupcdn.sfo3.cdn.digitaloceanspaces.com/060bb832-e1f2-11ec-9f43-acde48001122.png');
INSERT INTO public.platforms (platform_id, name, logo_url)
VALUES ('6e1355a6-a6d0-4206-90d9-1ca2b4498318', 'iTunes',
        'https://talksupcdn.sfo3.cdn.digitaloceanspaces.com/1227870e-e1f2-11ec-9f43-acde48001122.png');

INSERT INTO public.podcasts (podcast_id, name, description, total_views, cover_pic_url, trailer_url, rating, total_episodes, total_length, release_date, update_date, lang_id, author_id) VALUES ('a6d465df-738c-4974-a5bc-6c2bdf8780e6', 'Filosofía, Psicología e Historias varias', 'Relatos breves de filosofía, Psicología e Historias varias, con biografías y algunas reflexiones, leyendas y fantasías.', 0, 'https://i.scdn.co/image/2bc2a9e504540994ea5bfbe55e8c358c8db5c96b', 'https://open.spotify.com/episode/4sv9Pu5rH4hgr6bBZ4i5s0?si=vVnRH4UZTH2oi4fdSbzIRQ', 0, 177, '36h', '2020-03-01', '2022-05-06', 'ESP', '546e8d6a-f13e-405b-8bff-977463b691bb');
INSERT INTO public.podcasts (podcast_id, name, description, total_views, cover_pic_url, trailer_url, rating, total_episodes, total_length, release_date, update_date, lang_id, author_id) VALUES ('fbe8d232-d160-11ec-86d2-acde48001122', 'Psicologia al desnudo', 'En este podcast hablamos de emociones. De tus mecanismos internos: ¿Por qué hacés lo que hacés? ¿Por qué no podés expresar ciertas emociones y otras sí? ¿Por qué te sentís mal a veces? ¿Por qué hay cosas que te angustian, que te generan miedo, nostalgia, o que te dan placer? ¿Cómo regular tus emociones para sentirte equilibrado La gestión emocional es la CLAVE para vivir una vida con sentido. ¡Y está en tus manos aprenderlo! ¿La puerta de entrada a este proceso? Psicología al Desnudo', 0, 'https://i.scdn.co/image/ab6765630000ba8a412808f7b7b39ba17f687936', '', 0, 71, '27h', '2020-06-20', '2022-05-05', 'ESP', 'e2ba8436-d160-11ec-86d2-acde48001122');
INSERT INTO public.podcasts (podcast_id, name, description, total_views, cover_pic_url, trailer_url, rating, total_episodes, total_length, release_date, update_date, lang_id, author_id) VALUES ('92e70ea4-d168-11ec-8bd1-acde48001122', 'Caso 63', 'La psiquiatra Elisa Aldunate graba las sesiones de un enigmático paciente, registrado como Caso 63, quien asegura ser un viajero en el tiempo. Lo que comienza como rutinarias sesiones terapéuticas, se transforma rápidamente en un relato que amenaza las fronteras de lo posible y de lo real. Una historia que se mueve libremente entre el futuro y el pasado de dos personajes que, quizás, tienen en sus manos el futuro de la humanidad.', 0, 'https://i.scdn.co/image/ab6765630000ba8a222c470a223d7e56b1b68d08', '', 0, 23, '7h', '2020-11-01', '2021-11-10', 'ESP', '14f108f6-d168-11ec-8bd1-acde48001122');
INSERT INTO public.podcasts (podcast_id, name, description, total_views, cover_pic_url, trailer_url, rating, total_episodes, total_length, release_date, update_date, lang_id, author_id) VALUES ('dec1ec4c-d16b-11ec-8bd1-acde48001122', 'Sospechosamente light', 'Los han llamado inmaduros, malcrecidos, adolescentes eternos y no les choca, el tiempo perdido los trajo justo donde no querían al punto donde están muy jóvenes para morir pero muy viejos para vivir.', 0, 'https://i.scdn.co/image/f2f2024adc4de90952b05e64c80a16cbd3cf92b5', '', 0, 50, '35h', '2020-03-01', '2022-05-08', 'ESP', '74be97d2-d16b-11ec-8bd1-acde48001122');
INSERT INTO public.podcasts (podcast_id, name, description, total_views, cover_pic_url, trailer_url, rating, total_episodes, total_length, release_date, update_date, lang_id, author_id) VALUES ('304f7b64-d16d-11ec-8bd1-acde48001122', 'La cotorrisa', 'Ricardo Pérez y Slobotzky se ponen a cotorrear como siempre, pero ahora lo están grabando. Escuchalos todos los miercoles hablando de noticias extrañas, datos curiosos, anecdotas hilarantes y aliviana el ombligo de la semana.', 0, 'https://i.scdn.co/image/ab6765630000ba8a9ed098b86b1f0b5cce92f0c1', '', 0, 161, '230', '2020-03-01', '2019-03-01', 'ESP', '03de6f96-d16c-11ec-8bd1-acde48001122');
INSERT INTO public.podcasts (podcast_id, name, description, total_views, cover_pic_url, trailer_url, rating, total_episodes, total_length, release_date, update_date, lang_id, author_id) VALUES ('fd9fadaa-d16d-11ec-8bd1-acde48001122', 'Con ánimo de ofender', 'Con ánimo de ofender, la primera serie - documental - blog - película porno, de comedia, hecha para que sepan lo que es la comedia abajo de la tarima. Sin censura, no apta para la tv ! Ni para internet ! Ni para menores ni mayores de edad, ni pa` ni mierda.', 0, 'https://i.scdn.co/image/ab6765630000ba8afcc4827a5d17d080f5c66024', '', 0, 126, '41h', '2021-01-01', '2022-01-01', 'ESP', 'e8664e8a-d16d-11ec-8bd1-acde48001122');
INSERT INTO public.podcasts (podcast_id, name, description, total_views, cover_pic_url, trailer_url, rating, total_episodes, total_length, release_date, update_date, lang_id, author_id) VALUES ('7e8381f4-3118-4483-b4b2-c24eaa81c06a', 'Se regalan dudas', 'Se regalan dudas nace de la infinita necesidad de cuestionarnos todo, todo lo que está a nuestro alrededor. ¿Por qué creemos lo que creemos? ¿Qué alternativas hay? ¿De dónde venimos y hacia dónde vamos? ¿Cómo tomar decisiones informadas? Coexistir para vivir más intensamente sin dejar de crecer. Tenemos tantas dudas que te las queremos regalar.  y  crearon este podcast para abrir un espacio donde invitan a expertos, amigos y gente que admiran, que sabe y no sabe de todo eso de lo que tendríamos que estar hablando.', 0, 'https://i.scdn.co/image/ab6765630000ba8a49715a42dbf536cd56a90930', null, 0, 264, '220h', '2018-08-01', '2022-06-02', 'ESP', '14719931-fb66-4d03-a16c-b04ddc64435b');
INSERT INTO public.podcasts (podcast_id, name, description, total_views, cover_pic_url, trailer_url, rating, total_episodes, total_length, release_date, update_date, lang_id, author_id) VALUES ('ea6bb042-51bb-4adc-a4f9-508ab9be1e47', 'Creativo', 'Roberto Mtz se sienta a platicar con personas creativas destacadas de distintas industrias para aprender un poco sobre su forma de ver la vida.', 0, 'https://i.scdn.co/image/ab6765630000ba8aba86ec9cfd1d10492edae6e8', null, 0, 230, '360h', '2018-12-01', '2022-06-01', 'ESP', '687b4f4f-472d-477c-ad79-8bf2fbeb9d50');
INSERT INTO public.podcasts (podcast_id, name, description, total_views, cover_pic_url, trailer_url, rating, total_episodes, total_length, release_date, update_date, lang_id, author_id) VALUES ('57a179b8-d692-4c04-85f7-f95004f86565', 'Colombia Paranormal', 'Investigaciones, audios, noticias y todo un mundo visto desde la fantasía, el terror, el cielo y el infierno. Soy Cristian Díaz un joven colombiano que ama todo lo paranormal y quiero que ustedes me acompañen en este viaje extra dimensional y escuche los horrores que nadie se atreve a escuchar.', 0, 'https://i.scdn.co/image/f87fb665cf17b6332cd51c8f3076e5613cbf2d08', 'https://open.spotify.com/episode/5pJJYf5rxQIWYTnBsf75tg?si=tPDe2CT3Su-sGI9XV7lZJA', 4, 75, '15h', '2020-06-01', '2022-05-06', 'ESP', '2eaed1aa-0993-48c5-b95c-c0c2bb43ad1a');
INSERT INTO public.podcasts (podcast_id, name, description, total_views, cover_pic_url, trailer_url, rating, total_episodes, total_length, release_date, update_date, lang_id, author_id) VALUES ('da66e8cc-d194-11ec-a455-acde48001122', '13%', 'Contamos historias de personas que aman lo que hacen. Son una minoría especial: no odian los lunes, ni esperan toda la semana a que llegue el viernes.', 0, 'https://i.scdn.co/image/75f167805352b849105b87f889f521243c4af71f', '', 3, 78, '40h', '2018-01-20', '2022-03-27', 'ESP', 'a857e002-d194-11ec-a455-acde48001122');
INSERT INTO public.podcasts (podcast_id, name, description, total_views, cover_pic_url, trailer_url, rating, total_episodes, total_length, release_date, update_date, lang_id, author_id) VALUES ('153c8e32-d16f-11ec-8bd1-acde48001122', 'La hora perturbadora', 'Un impactante podcast con Luisito Comunica sobre temas paranormales y divertidos. En cada episodio, Luis narrará experiencias paranormales y de ultratumba de la mano de expertos y testigos que nos darán toda la información para hablar de todos los sucesos. Asesinos en serie, experiencias con fantasmas, posesiones, teorías conspirativas, avistamientos extraterrestres y todos los temas que sin duda, serán una experiencia auditiva que mantendrá a los oyentes al filo de sus audífonos y los hará cuestionarse sobre las cosas perturbadoras que los rodean.', 0, 'https://i.scdn.co/image/ab6765630000ba8a02cdada849659a40ccb53945', 'https://open.spotify.com/episode/3MIGIPRQhaXg1dsfvj7fGO?si=w8b1FDhmSTqkQJnBxrqzpg', 2.3333333333333335, 24, '16h', '2021-11-01', '2022-05-08', 'ESP', '14f108f6-d168-11ec-8bd1-acde48001122');
INSERT INTO public.podcasts (podcast_id, name, description, total_views, cover_pic_url, trailer_url, rating, total_episodes, total_length, release_date, update_date, lang_id, author_id) VALUES ('6f548f1e-9753-46b4-8d23-a9196976ef99', 'Teorías de conspiración', 'La verdad rara vez es la mejor historia. Y cuando no es la única historia, la verdad merece otra mirada. Todos los miércoles, contamos las historias complicadas detrás de los eventos más controversiales del mundo y los posibles encubrimientos. ¿Conspiración? Tal vez. ¿Coincidencia? Tal vez. ¿Complicado? Absolutamente. Teorías de Conspiración es un original de Spotify y Parcast.', 0, 'https://i.scdn.co/image/ab6765630000ba8a20308585f0727bbb0dcf12e9', null, 5, 151, '105h', '2020-07-01', '2022-06-01', 'ESP', '14f108f6-d168-11ec-8bd1-acde48001122');
INSERT INTO public.podcasts (podcast_id, name, description, total_views, cover_pic_url, trailer_url, rating, total_episodes, total_length, release_date, update_date, lang_id, author_id) VALUES ('6691d9c4-7226-47f6-a528-df7e835180fe', 'Crímenes, El musical', 'En la prensa de la España del XIX, los crímenes fueron un hit. Les gustaban tanto como hoy nos gusta el True Crime. A la vez fue asentándose la ciencia forense. En esta serie relatamos algunos de los crímenes más famosos de entonces, con mucha música y algunos coros. Y entrevistamos a una criminóloga y a científicos forenses de varias disciplinas: medicina, psicología, antropología, lingüística, biología...', 0, 'https://i.scdn.co/image/ab6765630000ba8a922f8b0368219ebc56b08734', 'https://open.spotify.com/episode/56Yk2Vo6Ej51rHbhrwcyBl?si=VZbsf0iPST2nD-RlR0ogtQ', 0, 16, '10h', '2021-01-06', '2022-06-21', 'ESP', 'c0c0efc6-6e17-4ca4-afae-a8e5c15d8638');
INSERT INTO public.podcasts (podcast_id, name, description, total_views, cover_pic_url, trailer_url, rating, total_episodes, total_length, release_date, update_date, lang_id, author_id) VALUES ('701a09b3-f754-4a30-99d4-a00e4a5e0419', 'The Frye Show', 'Esta es una cápsula del tiempo en dónde puedo aprender sobre los Mindsets, filosofías e historias y compartirlas con ustedes. En las palabras de Larry King, “Me recuerdo a mí mismo todas las mañanas: nada de lo que diga este día me enseñará nada. Entonces, si voy a aprender, debo hacerlo escuchando. - Larry King', 0, 'https://i.scdn.co/image/b8371c739ff8753e49202cceaf1142ea19f4bad4', null, 0, 190, '230h', '2021-01-01', '2022-05-26', 'ESP', 'f5466a78-2360-497a-b735-17e96fe2d0f7');
INSERT INTO public.podcasts (podcast_id, name, description, total_views, cover_pic_url, trailer_url, rating, total_episodes, total_length, release_date, update_date, lang_id, author_id) VALUES ('b7b8c3a0-975e-46f0-88f0-3f1d9bc7b667', 'Asesinos Seriales', 'Asesinos Seriales adopta un enfoque psicológico y entretenido para proporcionar una visión poco común de la mente, los métodos y la locura de los asesinos seriales más notorios, con la esperanza de comprender su perfil psicológico. Con la ayuda de una investigación a profundidad, contamos sus vidas e historias. Asesinos Seriales es un original de Spotify y Parcast.', 0, 'https://i.scdn.co/image/ab67656300005f1f51fbc111b50f1f10ef81c0a4', 'https://open.spotify.com/episode/4CBOMD9LEejutts1eJCZhw?si=Du0vkSvVTW6tLxa5WysKoA', 0, 50, '40h', '2021-12-01', '2022-06-22', 'ESP', '14f108f6-d168-11ec-8bd1-acde48001122');
INSERT INTO public.podcasts (podcast_id, name, description, total_views, cover_pic_url, trailer_url, rating, total_episodes, total_length, release_date, update_date, lang_id, author_id) VALUES ('7959981e-f605-4a7f-8050-d625dedcd733', 'Boss Tank: Ser tu propio jefe', 'Mi objetivo es ser un aliado de negocios para que emprendedores latinoamericanos puedan lograr todo lo que se proponen. Para ello he logrado convertirme en un puente entre las nuevas empresas y la empresa tradicional. ¿Qué significa esto? Que apuesto firmemente por la economía naranja y del conocimiento. Entiendo al emprendimiento como una de las fuentes más importantes del crecimiento de un país.', 0, 'https://i.scdn.co/image/ab67656300005f1f54b881d961dc8167aa75c51b', 'https://open.spotify.com/episode/4CBOMD9LEejutts1eJCZhw?si=Du0vkSvVTW6tLxa5WysKoA', 0, 50, '35h', '2021-12-01', '2022-06-27', 'ESP', '8e34cba2-4694-451b-8ee2-682c78e78098');

INSERT INTO public.category_podcast (category_podcast_id, podcast_id, category_id) VALUES ('91c75c52-eea5-4bbd-8bfa-4be542bfedbc', '57a179b8-d692-4c04-85f7-f95004f86565', '35b2881c-210c-4160-b3f7-6252b9ebee49');
INSERT INTO public.category_podcast (category_podcast_id, podcast_id, category_id) VALUES ('ada4deff-fcbb-41ce-84c6-eac01287a97f', '57a179b8-d692-4c04-85f7-f95004f86565', '55abaa24-b920-43ea-bf94-aee5f614e326');
INSERT INTO public.category_podcast (category_podcast_id, podcast_id, category_id) VALUES ('afb437f8-6025-47c9-a0ee-e6c647d89e5e', 'a6d465df-738c-4974-a5bc-6c2bdf8780e6', '472aa79f-fc3a-46d7-8b4b-b4fab318bb6b');
INSERT INTO public.category_podcast (category_podcast_id, podcast_id, category_id) VALUES ('1b780ac5-03f2-4a16-bb70-d97232a81e53', 'a6d465df-738c-4974-a5bc-6c2bdf8780e6', '73220619-faf6-498d-8800-e1d5f468d88a');
INSERT INTO public.category_podcast (category_podcast_id, podcast_id, category_id) VALUES ('d35cccd6-83e3-436e-89fe-00d290e82e31', 'a6d465df-738c-4974-a5bc-6c2bdf8780e6', '2da2f856-e235-436c-bdce-7471b0162846');
INSERT INTO public.category_podcast (category_podcast_id, podcast_id, category_id) VALUES ('15672656-698f-45a8-9bac-79794935179c', 'fbe8d232-d160-11ec-86d2-acde48001122', '2da2f856-e235-436c-bdce-7471b0162846');
INSERT INTO public.category_podcast (category_podcast_id, podcast_id, category_id) VALUES ('f6725d61-50e2-48b9-a951-97d5a86256a1', 'fbe8d232-d160-11ec-86d2-acde48001122', '73220619-faf6-498d-8800-e1d5f468d88a');
INSERT INTO public.category_podcast (category_podcast_id, podcast_id, category_id) VALUES ('a7dc6ef2-25a9-4d24-abc1-66c44cbee762', '92e70ea4-d168-11ec-8bd1-acde48001122', '55abaa24-b920-43ea-bf94-aee5f614e326');
INSERT INTO public.category_podcast (category_podcast_id, podcast_id, category_id) VALUES ('01b14b20-9651-4f28-aa38-2026ac4f584e', '92e70ea4-d168-11ec-8bd1-acde48001122', '7ffc646a-d168-11ec-8bd1-acde48001122');
INSERT INTO public.category_podcast (category_podcast_id, podcast_id, category_id) VALUES ('dae08bca-e763-44eb-a8ca-4ff1b5c057a5', 'dec1ec4c-d16b-11ec-8bd1-acde48001122', '4a0f3c26-d16b-11ec-8bd1-acde48001122');
INSERT INTO public.category_podcast (category_podcast_id, podcast_id, category_id) VALUES ('727d2a45-75ed-44ad-b5c2-ec218815050e', 'dec1ec4c-d16b-11ec-8bd1-acde48001122', 'f67a4547-31fe-4bba-8556-526cac7f4fa0');
INSERT INTO public.category_podcast (category_podcast_id, podcast_id, category_id) VALUES ('3ead30b2-6189-47e8-81c1-bd4622a00d04', '304f7b64-d16d-11ec-8bd1-acde48001122', '4a0f3c26-d16b-11ec-8bd1-acde48001122');
INSERT INTO public.category_podcast (category_podcast_id, podcast_id, category_id) VALUES ('30590534-5cf3-4322-ae6a-740a8462919a', '304f7b64-d16d-11ec-8bd1-acde48001122', 'f67a4547-31fe-4bba-8556-526cac7f4fa0');
INSERT INTO public.category_podcast (category_podcast_id, podcast_id, category_id) VALUES ('94474ac2-a2c1-44be-876b-209a4e26a057', 'fd9fadaa-d16d-11ec-8bd1-acde48001122', '4a0f3c26-d16b-11ec-8bd1-acde48001122');
INSERT INTO public.category_podcast (category_podcast_id, podcast_id, category_id) VALUES ('e6b444b4-59f0-46d7-b887-988a4db4f2e7', 'fd9fadaa-d16d-11ec-8bd1-acde48001122', 'f67a4547-31fe-4bba-8556-526cac7f4fa0');
INSERT INTO public.category_podcast (category_podcast_id, podcast_id, category_id) VALUES ('0e5b9713-d40e-4f5a-bd36-4c0f6e1f3c82', '153c8e32-d16f-11ec-8bd1-acde48001122', '35b2881c-210c-4160-b3f7-6252b9ebee49');
INSERT INTO public.category_podcast (category_podcast_id, podcast_id, category_id) VALUES ('83cef2e2-6ee6-4a05-a32d-dfb8df2fd289', '153c8e32-d16f-11ec-8bd1-acde48001122', '55abaa24-b920-43ea-bf94-aee5f614e326');
INSERT INTO public.category_podcast (category_podcast_id, podcast_id, category_id) VALUES ('2b79433d-65a7-4942-ac4c-718311e4ecea', '153c8e32-d16f-11ec-8bd1-acde48001122', 'f67a4547-31fe-4bba-8556-526cac7f4fa0');
INSERT INTO public.category_podcast (category_podcast_id, podcast_id, category_id) VALUES ('363a3876-a9e7-4ffc-9b30-61bee10537c2', 'da66e8cc-d194-11ec-a455-acde48001122', '9562cf3e-d194-11ec-a455-acde48001122');
INSERT INTO public.category_podcast (category_podcast_id, podcast_id, category_id) VALUES ('246e9af1-612a-4a09-af4d-5cd4786e4caf', '6f548f1e-9753-46b4-8d23-a9196976ef99', '55abaa24-b920-43ea-bf94-aee5f614e326');
INSERT INTO public.category_podcast (category_podcast_id, podcast_id, category_id) VALUES ('5ec91f47-0b48-412b-a386-ddde243f8f34', '6f548f1e-9753-46b4-8d23-a9196976ef99', '7ffc646a-d168-11ec-8bd1-acde48001122');
INSERT INTO public.category_podcast (category_podcast_id, podcast_id, category_id) VALUES ('671b5340-3b1f-47d7-bab1-6a66beb85c04', '7e8381f4-3118-4483-b4b2-c24eaa81c06a', '73220619-faf6-498d-8800-e1d5f468d88a');
INSERT INTO public.category_podcast (category_podcast_id, podcast_id, category_id) VALUES ('6cf5aec6-af18-44c9-8575-211c163f9f6c', '7e8381f4-3118-4483-b4b2-c24eaa81c06a', '2da2f856-e235-436c-bdce-7471b0162846');
INSERT INTO public.category_podcast (category_podcast_id, podcast_id, category_id) VALUES ('dd21c6d2-4cb4-4d7c-87d7-17e8359c8222', '6691d9c4-7226-47f6-a528-df7e835180fe', '35b2881c-210c-4160-b3f7-6252b9ebee49');
INSERT INTO public.category_podcast (category_podcast_id, podcast_id, category_id) VALUES ('6ef43fc1-c52f-4e77-972c-c1aab09fcfee', '6691d9c4-7226-47f6-a528-df7e835180fe', '55abaa24-b920-43ea-bf94-aee5f614e326');
INSERT INTO public.category_podcast (category_podcast_id, podcast_id, category_id) VALUES ('0594b43a-1643-4d56-8492-3d313e254789', '6691d9c4-7226-47f6-a528-df7e835180fe', '472aa79f-fc3a-46d7-8b4b-b4fab318bb6b');
INSERT INTO public.category_podcast (category_podcast_id, podcast_id, category_id) VALUES ('c92238b1-5d30-407b-805b-98df9eeeac77', 'ea6bb042-51bb-4adc-a4f9-508ab9be1e47', 'f67a4547-31fe-4bba-8556-526cac7f4fa0');
INSERT INTO public.category_podcast (category_podcast_id, podcast_id, category_id) VALUES ('5cee83c7-120c-48bd-9e0a-fa5f1d3a6f07', 'ea6bb042-51bb-4adc-a4f9-508ab9be1e47', '73220619-faf6-498d-8800-e1d5f468d88a');
INSERT INTO public.category_podcast (category_podcast_id, podcast_id, category_id) VALUES ('b03abaa1-56db-48b5-917a-1f35b0f5758e', '701a09b3-f754-4a30-99d4-a00e4a5e0419', '9562cf3e-d194-11ec-a455-acde48001122');
INSERT INTO public.category_podcast (category_podcast_id, podcast_id, category_id) VALUES ('cab21ba6-46a7-4a29-ae92-16455aae0c3c', 'b7b8c3a0-975e-46f0-88f0-3f1d9bc7b667', '35b2881c-210c-4160-b3f7-6252b9ebee49');
INSERT INTO public.category_podcast (category_podcast_id, podcast_id, category_id) VALUES ('8bcd36d3-bc36-4072-b216-fa70728db43c', 'b7b8c3a0-975e-46f0-88f0-3f1d9bc7b667', '55abaa24-b920-43ea-bf94-aee5f614e326');
INSERT INTO public.category_podcast (category_podcast_id, podcast_id, category_id) VALUES ('8d7164e5-e95f-4674-9663-2b781ae75c55', '7959981e-f605-4a7f-8050-d625dedcd733', '9562cf3e-d194-11ec-a455-acde48001122');

INSERT INTO public.platform_podcast (platform_podcast_id, podcast_id, platform_id, redirect_url) VALUES ('06c802cb-5f3d-47d5-a252-b1566a35ae26', '57a179b8-d692-4c04-85f7-f95004f86565', 'eb4b1438-da09-4b37-be59-4d921aeba947', 'https://open.spotify.com/show/3XUm8M13zg1jaaUxCRJE64');
INSERT INTO public.platform_podcast (platform_podcast_id, podcast_id, platform_id, redirect_url) VALUES ('43dbe3cf-4022-46b9-b25a-4537b56e2fef', 'a6d465df-738c-4974-a5bc-6c2bdf8780e6', 'eb4b1438-da09-4b37-be59-4d921aeba947', 'https://open.spotify.com/show/17dk0hYDmVq7EzGXC8y4u6');
INSERT INTO public.platform_podcast (platform_podcast_id, podcast_id, platform_id, redirect_url) VALUES ('e23677c9-9451-4be7-ab54-f187fbdbd9b7', 'fbe8d232-d160-11ec-86d2-acde48001122', 'eb4b1438-da09-4b37-be59-4d921aeba947', 'https://open.spotify.com/show/1TDJJoHWEq7Nbh3yEBOJOj');
INSERT INTO public.platform_podcast (platform_podcast_id, podcast_id, platform_id, redirect_url) VALUES ('02f9962b-1b81-4b25-9a9a-d15dc6532371', '92e70ea4-d168-11ec-8bd1-acde48001122', 'eb4b1438-da09-4b37-be59-4d921aeba947', 'https://open.spotify.com/show/20ch3IIqtWSSM4nfy11ZzP');
INSERT INTO public.platform_podcast (platform_podcast_id, podcast_id, platform_id, redirect_url) VALUES ('a8c0b80b-4449-4e4d-96e7-d0ba1d5eaec4', 'dec1ec4c-d16b-11ec-8bd1-acde48001122', 'eb4b1438-da09-4b37-be59-4d921aeba947', 'https://open.spotify.com/show/1aYPBvV7AIilRkyORTD1X3');
INSERT INTO public.platform_podcast (platform_podcast_id, podcast_id, platform_id, redirect_url) VALUES ('d6cd3112-3131-4b4c-9467-1805bbed9a5a', '304f7b64-d16d-11ec-8bd1-acde48001122', 'eb4b1438-da09-4b37-be59-4d921aeba947', 'https://open.spotify.com/show/3a36uQneX1imRuopaknUqw');
INSERT INTO public.platform_podcast (platform_podcast_id, podcast_id, platform_id, redirect_url) VALUES ('186de648-39d7-4ae2-a774-dd5197577355', '304f7b64-d16d-11ec-8bd1-acde48001122', '6e1355a6-a6d0-4206-90d9-1ca2b4498318', 'https://podcasts.apple.com/co/podcast/la-cotorrisa/id1458792155');
INSERT INTO public.platform_podcast (platform_podcast_id, podcast_id, platform_id, redirect_url) VALUES ('4546e5ee-bedd-492f-9d11-9faadc2cc33b', '304f7b64-d16d-11ec-8bd1-acde48001122', '3eca4a4b-50fd-48e1-a683-fb1ed323eb1e', 'https://youtube.com/playlist?list=PLTlY-r_NNnuJPwVNbolOymptC6SeFUewJ');
INSERT INTO public.platform_podcast (platform_podcast_id, podcast_id, platform_id, redirect_url) VALUES ('c05bc622-4f98-4c9d-b050-9e1cc6462617', 'fd9fadaa-d16d-11ec-8bd1-acde48001122', 'eb4b1438-da09-4b37-be59-4d921aeba947', 'https://open.spotify.com/show/0oIhHZSGWIjkJh27DlB5uv');
INSERT INTO public.platform_podcast (platform_podcast_id, podcast_id, platform_id, redirect_url) VALUES ('ef25d02a-d32d-47fd-bd10-9fb68993fe33', 'fd9fadaa-d16d-11ec-8bd1-acde48001122', '3eca4a4b-50fd-48e1-a683-fb1ed323eb1e', 'https://www.youtube.com/playlist?list=PLI-lha5pHEe7eq2X4W2vDI4upqy-GrawQ');
INSERT INTO public.platform_podcast (platform_podcast_id, podcast_id, platform_id, redirect_url) VALUES ('19f12935-e0ab-4533-b06a-b6b4fb3c85b8', '153c8e32-d16f-11ec-8bd1-acde48001122', 'eb4b1438-da09-4b37-be59-4d921aeba947', 'https://open.spotify.com/show/7A90TRFsavNZ2WE1m55jeU');
INSERT INTO public.platform_podcast (platform_podcast_id, podcast_id, platform_id, redirect_url) VALUES ('172d3f06-0e48-4052-bd3c-c9444c1551b7', 'da66e8cc-d194-11ec-a455-acde48001122', 'eb4b1438-da09-4b37-be59-4d921aeba947', 'https://open.spotify.com/show/3PR2zd9DZNCDWefPlVwCA2');
INSERT INTO public.platform_podcast (platform_podcast_id, podcast_id, platform_id, redirect_url) VALUES ('a8e2e278-3aa7-49db-a511-06ff2d8456fd', '7e8381f4-3118-4483-b4b2-c24eaa81c06a', 'eb4b1438-da09-4b37-be59-4d921aeba947', 'https://open.spotify.com/show/0KUjSzqMyxrTyXuw15j4e8');
INSERT INTO public.platform_podcast (platform_podcast_id, podcast_id, platform_id, redirect_url) VALUES ('a0bd340f-ad22-4483-8e93-3e32e980d16e', '6f548f1e-9753-46b4-8d23-a9196976ef99', 'eb4b1438-da09-4b37-be59-4d921aeba947', 'https://open.spotify.com/show/7wQ5NNrWVmC7wDE9Y7cbwR');
INSERT INTO public.platform_podcast (platform_podcast_id, podcast_id, platform_id, redirect_url) VALUES ('adf2b744-3eef-4ba2-a715-e1c286127d36', '6691d9c4-7226-47f6-a528-df7e835180fe', 'eb4b1438-da09-4b37-be59-4d921aeba947', 'https://open.spotify.com/show/7HLQS94367cb8XXZOqMNE5');
INSERT INTO public.platform_podcast (platform_podcast_id, podcast_id, platform_id, redirect_url) VALUES ('1d75e8ad-f67e-47c2-8651-26c3ad6f346a', 'ea6bb042-51bb-4adc-a4f9-508ab9be1e47', 'eb4b1438-da09-4b37-be59-4d921aeba947', 'https://open.spotify.com/show/5Wik1DfA7kLiqRP9wNwFap');
INSERT INTO public.platform_podcast (platform_podcast_id, podcast_id, platform_id, redirect_url) VALUES ('959dc356-c8f5-472f-9310-687094653bc1', 'ea6bb042-51bb-4adc-a4f9-508ab9be1e47', '3eca4a4b-50fd-48e1-a683-fb1ed323eb1e', 'https://www.youtube.com/watch?v=x1WEx3ZGe-Q&list=PLarzDke3cEZ_fdKaUbbjkTYWJlOj_htPV&ab_channel=RobertoMtz');
INSERT INTO public.platform_podcast (platform_podcast_id, podcast_id, platform_id, redirect_url) VALUES ('866d8b84-aeb4-44ea-be11-e3986cb8056f', '701a09b3-f754-4a30-99d4-a00e4a5e0419', 'eb4b1438-da09-4b37-be59-4d921aeba947', 'https://open.spotify.com/show/50XIGcu4u0lh49mK4cPOWy');
INSERT INTO public.platform_podcast (platform_podcast_id, podcast_id, platform_id, redirect_url) VALUES ('0183f94a-cfb5-4f8b-9942-22d2e723955f', '701a09b3-f754-4a30-99d4-a00e4a5e0419', '6e1355a6-a6d0-4206-90d9-1ca2b4498318', 'https://podcasts.apple.com/co/podcast/the-frye-show/id1092995967');
INSERT INTO public.platform_podcast (platform_podcast_id, podcast_id, platform_id, redirect_url) VALUES ('5f5c3ed2-5356-464e-8817-1522beefe35e', 'b7b8c3a0-975e-46f0-88f0-3f1d9bc7b667', 'eb4b1438-da09-4b37-be59-4d921aeba947', 'https://open.spotify.com/show/2KLVyvPJ3m1UFwoV1fr7nb');
INSERT INTO public.platform_podcast (platform_podcast_id, podcast_id, platform_id, redirect_url) VALUES ('326cbf8f-6c9e-4190-8f62-c55efe8b3861', '7959981e-f605-4a7f-8050-d625dedcd733', 'eb4b1438-da09-4b37-be59-4d921aeba947', 'https://open.spotify.com/show/0Axsz7z8PrkX9jWRIqWwlJ');

INSERT INTO public.lists (list_id, name, description, icon_url, cover_pic_url, likes, user_id) VALUES ('43f3e1dc-70c0-4f2d-88a4-355e8050a661', 'Psicologia a otro level', 'Podcasts de filosofia y psicologia', null, null, 1, '86f45ee6-c5a4-11ec-b46f-6a2f678b91f3');
INSERT INTO public.lists (list_id, name, description, icon_url, cover_pic_url, likes, user_id) VALUES ('462a5028-f257-11ec-89a7-d6922f1c06cc', 'Para empresarios de verdad', 'Lista con los mejores podcasts sobre empresas, aprovechalo', 'https://talksupcdn.sfo3.cdn.digitaloceanspaces.com/427669d0-f257-11ec-89a7-d6922f1c06cc.jpeg', 'https://talksupcdn.sfo3.cdn.digitaloceanspaces.com/44fd57ea-f257-11ec-89a7-d6922f1c06cc.jpeg', 2, '86f45ee6-c5a4-11ec-b46f-6a2f678b91f3');
INSERT INTO public.lists (list_id, name, description, icon_url, cover_pic_url, likes, user_id) VALUES ('44e98fc0-f258-11ec-89a7-d6922f1c06cc', 'Buuu! Solo terror', 'Soy amante del terror, cree esta lista para compartirte mis favoritos', 'https://talksupcdn.sfo3.cdn.digitaloceanspaces.com/41d6dfce-f258-11ec-89a7-d6922f1c06cc.jpeg', 'https://talksupcdn.sfo3.cdn.digitaloceanspaces.com/43b9c8cb-f258-11ec-89a7-d6922f1c06cc.jpeg', 3, 'f9b3da61-f257-11ec-89a7-d6922f1c06cc');

INSERT INTO public.likes (like_id, list_id, user_id) VALUES ('38fbeab4-9cdb-4fe0-b22a-5153681731ce', '43f3e1dc-70c0-4f2d-88a4-355e8050a661', '86f45ee6-c5a4-11ec-b46f-6a2f678b91f3');
INSERT INTO public.likes (like_id, list_id, user_id) VALUES ('5082e43d-2a57-40b3-b31c-cf3b4244c378', '462a5028-f257-11ec-89a7-d6922f1c06cc', '86f45ee6-c5a4-11ec-b46f-6a2f678b91f3');
INSERT INTO public.likes (like_id, list_id, user_id) VALUES ('79c7983b-d317-4270-b5d4-7334e93f44be', '462a5028-f257-11ec-89a7-d6922f1c06cc', 'f9b3da61-f257-11ec-89a7-d6922f1c06cc');
INSERT INTO public.likes (like_id, list_id, user_id) VALUES ('caff67d8-2891-4dd1-8d24-1ec726b15f8a', '44e98fc0-f258-11ec-89a7-d6922f1c06cc', 'f9b3da61-f257-11ec-89a7-d6922f1c06cc');
INSERT INTO public.likes (like_id, list_id, user_id) VALUES ('8ad9bd6e-0cb2-40ab-99be-3383b90bc8f2', '44e98fc0-f258-11ec-89a7-d6922f1c06cc', '86f45ee6-c5a4-11ec-b46f-6a2f678b91f3');
INSERT INTO public.likes (like_id, list_id, user_id) VALUES ('a5c03ebd-09cd-411f-84ba-9fc59e2be94f', '44e98fc0-f258-11ec-89a7-d6922f1c06cc', 'ca132fa7-f259-11ec-89a7-d6922f1c06cc');

INSERT INTO public.lists_podcast (lists_podcast_id, podcast_id, list_id) VALUES ('e54eed98-df85-488b-b260-a3f248d704c8', '57a179b8-d692-4c04-85f7-f95004f86565', '43f3e1dc-70c0-4f2d-88a4-355e8050a661');
INSERT INTO public.lists_podcast (lists_podcast_id, podcast_id, list_id) VALUES ('4956baab-c863-4192-89a9-5695beb5caaf', 'fbe8d232-d160-11ec-86d2-acde48001122', '43f3e1dc-70c0-4f2d-88a4-355e8050a661');
INSERT INTO public.lists_podcast (lists_podcast_id, podcast_id, list_id) VALUES ('b651b3a1-e5fb-4bd4-974a-769b83b75257', '7959981e-f605-4a7f-8050-d625dedcd733', '462a5028-f257-11ec-89a7-d6922f1c06cc');
INSERT INTO public.lists_podcast (lists_podcast_id, podcast_id, list_id) VALUES ('1b1d8f72-200c-4a56-99c7-61bbb6e9aee3', '701a09b3-f754-4a30-99d4-a00e4a5e0419', '462a5028-f257-11ec-89a7-d6922f1c06cc');
INSERT INTO public.lists_podcast (lists_podcast_id, podcast_id, list_id) VALUES ('bafca807-798e-4e45-80c5-58b9e2023345', 'da66e8cc-d194-11ec-a455-acde48001122', '462a5028-f257-11ec-89a7-d6922f1c06cc');
INSERT INTO public.lists_podcast (lists_podcast_id, podcast_id, list_id) VALUES ('70d2d343-af33-480e-a968-5ea7945bd526', 'ea6bb042-51bb-4adc-a4f9-508ab9be1e47', '462a5028-f257-11ec-89a7-d6922f1c06cc');
INSERT INTO public.lists_podcast (lists_podcast_id, podcast_id, list_id) VALUES ('014bfeb8-cf7d-4b37-9758-9e9b1f07ed04', '6691d9c4-7226-47f6-a528-df7e835180fe', '44e98fc0-f258-11ec-89a7-d6922f1c06cc');
INSERT INTO public.lists_podcast (lists_podcast_id, podcast_id, list_id) VALUES ('b6aff45a-0f45-4ab4-9fb2-dba88ea55eba', 'b7b8c3a0-975e-46f0-88f0-3f1d9bc7b667', '44e98fc0-f258-11ec-89a7-d6922f1c06cc');
INSERT INTO public.lists_podcast (lists_podcast_id, podcast_id, list_id) VALUES ('3d786fb8-b51c-452a-aadd-bcd3e93df509', '57a179b8-d692-4c04-85f7-f95004f86565', '44e98fc0-f258-11ec-89a7-d6922f1c06cc');

INSERT INTO public.reviews (review_id, title, review, rate, review_date, lang_id, user_id, podcast_id) VALUES ('9da38a26-f257-11ec-89a7-d6922f1c06cc', 'No es para todos', 'Es un podcast excelente que toma en cuenta muchos factores que ni habia pensado. Recomendadisimo!', 5, '2022-06-22', 'ESP', '86f45ee6-c5a4-11ec-b46f-6a2f678b91f3', '7959981e-f605-4a7f-8050-d625dedcd733');
INSERT INTO public.reviews (review_id, title, review, rate, review_date, lang_id, user_id, podcast_id) VALUES ('a1727340-f258-11ec-89a7-d6922f1c06cc', 'Aburrido, no hay mas', 'Me parece aburrido, un podcast que habla sobre los privilegios...', 1, '2022-06-22', 'ESP', 'f9b3da61-f257-11ec-89a7-d6922f1c06cc', '7959981e-f605-4a7f-8050-d625dedcd733');
INSERT INTO public.reviews (review_id, title, review, rate, review_date, lang_id, user_id, podcast_id) VALUES ('eedd353f-f258-11ec-89a7-d6922f1c06cc', 'Increible! es brutal', 'Me encató este podcasts, es super interesante, espero ver más de este autor!', 5, '2022-06-22', 'ESP', 'f9b3da61-f257-11ec-89a7-d6922f1c06cc', '6691d9c4-7226-47f6-a528-df7e835180fe');
INSERT INTO public.reviews (review_id, title, review, rate, review_date, lang_id, user_id, podcast_id) VALUES ('a2c310c5-f259-11ec-89a7-d6922f1c06cc', 'Interesante', 'Es un podcasts demasiado interesante, un formato nuevo e innovador', 4, '2022-06-22', 'ESP', '86f45ee6-c5a4-11ec-b46f-6a2f678b91f3', '6691d9c4-7226-47f6-a528-df7e835180fe');
INSERT INTO public.reviews (review_id, title, review, rate, review_date, lang_id, user_id, podcast_id) VALUES ('15a03ab0-f25a-11ec-89a7-d6922f1c06cc', 'Creo que es el mejor que he escuchado', 'Un podcast innovador, con cosas completamente nuevas que nunca he escuchado en otro lado. Es increible! Recomendado', 5, '2022-06-22', 'ESP', 'ca132fa7-f259-11ec-89a7-d6922f1c06cc', '6691d9c4-7226-47f6-a528-df7e835180fe');
INSERT INTO public.reviews (review_id, title, review, rate, review_date, lang_id, user_id, podcast_id) VALUES ('051ad224-f25b-11ec-89a7-d6922f1c06cc', 'Maso, ni tan mal', 'Esta bueno, interesante, pero algunos capitulos son re aburridos', 3, '2022-06-22', 'ESP', 'ca132fa7-f259-11ec-89a7-d6922f1c06cc', 'b7b8c3a0-975e-46f0-88f0-3f1d9bc7b667');

GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO apptalksup;