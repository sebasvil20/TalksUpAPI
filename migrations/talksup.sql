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
    rate        float        NOT NULL CHECK (rate > 0 and rate < 5),
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
            REFERENCES users (user_id);

-- Likes table
ALTER TABLE likes
    ADD CONSTRAINT likes_user_id_fk
        FOREIGN KEY (user_id)
            REFERENCES users (user_id);

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
            REFERENCES users (user_id);

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
            REFERENCES users (user_id);


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
    AFTER INSERT
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

INSERT INTO users (user_id, public_name, email, first_name, last_name, birth_date, phone_number, profile_pic_url,
                   biography, lang_id, country_id, role_id)
VALUES ('86f45ee6-c5a4-11ec-b46f-6a2f678b91f3', 'hinval', 'sebasvil20@gmail.com', 'Sebastian', 'Villegas',
        '2002-08-12',
        '3053190789', null, null, 'ESP', 'CO', 1),
       ('2bac0baa-cef6-11ec-b31f-acde48001122', 'Trueni', 'sansepulveda90@gmail.com', 'Santiago', 'Sepulveda',
        '2000-02-08',
        '3016395335', null, null, 'ESP', 'CO', 1);

INSERT INTO passwords (password_id, hashed_password, user_id)
VALUES ('1b937b4b-b43f-4a70-8b0b-2255c2615151', '$2a$14$nP6hIrQ/.Uf2Ll8sA88zjuy01KmY/DzyVExkt3XKNpMO2073i9Smy',
        '86f45ee6-c5a4-11ec-b46f-6a2f678b91f3'),
       ('7c750388-683a-46c0-920e-0aa763eb65c4', '$2a$14$O893ha7HsJFYaf9gpKsxBO2jpowoSAum76ygPG0OTj9VVVJOfihn6',
        '2bac0baa-cef6-11ec-b31f-acde48001122');

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

INSERT INTO public.category_user (category_user_id, category_id, user_id)
VALUES ('1cbb9c4d-2506-4c17-971a-736d7012cce1', '35b2881c-210c-4160-b3f7-6252b9ebee49',
        '86f45ee6-c5a4-11ec-b46f-6a2f678b91f3');
INSERT INTO public.category_user (category_user_id, category_id, user_id)
VALUES ('9d6ef767-6f19-4acf-bf42-678fe9b28c05', '55abaa24-b920-43ea-bf94-aee5f614e326',
        '86f45ee6-c5a4-11ec-b46f-6a2f678b91f3');
INSERT INTO public.category_user (category_user_id, category_id, user_id)
VALUES ('c51868b7-6346-4e6f-aafe-04d53502364b', '472aa79f-fc3a-46d7-8b4b-b4fab318bb6b',
        '2bac0baa-cef6-11ec-b31f-acde48001122');
INSERT INTO public.category_user (category_user_id, category_id, user_id)
VALUES ('cc81c61a-7c26-46a3-a540-7a113f45906d', 'f67a4547-31fe-4bba-8556-526cac7f4fa0',
        '2bac0baa-cef6-11ec-b31f-acde48001122');

INSERT INTO public.authors (author_id, name, biography, profile_pic_url)
VALUES ('546e8d6a-f13e-405b-8bff-977463b691bb', 'Hernán Melana', null,
        'https://www.losandes.com.ar/resizer/bHFmkWl9vjk7DAum019Ap_GuKtA=/1200x630/smart/cloudfront-us-east-1.images.arcpublishing.com/grupoclarin/DXA2YEF37JANJF2LDTI7T3M2GE.jpg');
INSERT INTO public.authors (author_id, name, biography, profile_pic_url)
VALUES ('2eaed1aa-0993-48c5-b95c-c0c2bb43ad1a', 'Cristian Diaz Rodriguez', null, null);
INSERT INTO public.authors (author_id, name, biography, profile_pic_url)
VALUES ('d6370d04-ec18-46a0-b995-a81a36c5a573', 'Bali Club', null, null);
INSERT INTO public.authors (author_id, name, biography, profile_pic_url)
VALUES ('587678a5-7fb8-49c2-b5d5-fcb0e4f36e0a', 'Relatos de la Noche', null, null);
INSERT INTO public.authors (author_id, name, biography, profile_pic_url)
VALUES ('e2ba8436-d160-11ec-86d2-acde48001122', 'Marina Mammoliti',
        'Soy una apasionada de cada historia, de cada persona. Amo ir descubriendo cómo cada una/o va formando determinados modos de ser, adaptándose al entorno y construyendo herramientas tanto conscientes como inconscientes para lidiar con la cotidianeidad',
        'https://psimammoliti.com/wp-content/uploads/2020/11/Marina-Mammoliti.jpg');
INSERT INTO public.authors (author_id, name, biography, profile_pic_url)
VALUES ('14f108f6-d168-11ec-8bd1-acde48001122', 'Spotify Studios', 'Podcasts originales de Spotify',
        'https://i0.wp.com/hipertextual.com/wp-content/uploads/2021/03/Spotify-Logo-Green-Black.jpg');
INSERT INTO public.authors (author_id, name, biography, profile_pic_url)
VALUES ('74be97d2-d16b-11ec-8bd1-acde48001122', 'Sospechosamente light',
        'Liss Pereira, Tato Cepeda y Santiago Rendón, juntos en Sospechosamente Light.',
        'https://i.scdn.co/image/f2f2024adc4de90952b05e64c80a16cbd3cf92b5');
INSERT INTO public.authors (author_id, name, biography, profile_pic_url)
VALUES ('03de6f96-d16c-11ec-8bd1-acde48001122', 'La cotorrisa Podcast',
        'Ricardo Pérez y Slobotzky se ponen a cotorrear como siempre, pero ahora lo están grabando.',
        'https://i.scdn.co/image/ab6765630000ba8a9ed098b86b1f0b5cce92f0c1');
INSERT INTO public.authors (author_id, name, biography, profile_pic_url)
VALUES ('e8664e8a-d16d-11ec-8bd1-acde48001122', 'Con ánimo de ofender',
        'Canal de Comedia Colombiana Hogar de Con Ánimo De Ofender, la primera serie/documental/vlog de la comedia stand up de Colombia, donde el bullying es la moneda de cambio y el humor negro nuestro estilo de vida; Damas y Caballeros un programa de humor Colombiano no apto para tv, sin censura, sin presupuesto pero Con Ánimo De Ofender',
        'https://i.scdn.co/image/ab6765630000ba8afcc4827a5d17d080f5c66024');
INSERT INTO public.authors (author_id, name, biography, profile_pic_url)
VALUES ('a857e002-d194-11ec-a455-acde48001122', 'Andrés Acevedo Niño',
        'Andrés Acevedo Niño es cofundador de 13% Pasión por el trabajo, el principal podcast en español en temas de carrera profesional y trabajo. Escribe para CUMBRE, la plataforma especializada en liderazgo del Colegio de Estudios Superiores en Administración (CESA).',
        'https://media-exp1.licdn.com/dms/image/C4E03AQF0CTQHw-w-Vg/profile-displayphoto-shrink_200_200/0/1593875094690e=1657756800&v=beta&t=p2K6fDY_S64XiWkxNZUdr6PYbC1DA7xBWfbSJvqsUdU');

INSERT INTO public.platforms (platform_id, name, logo_url)
VALUES ('eb4b1438-da09-4b37-be59-4d921aeba947', 'Spotify',
        'https://talksupcdn.sfo3.cdn.digitaloceanspaces.com/spotify-logo.png');
INSERT INTO public.platforms (platform_id, name, logo_url)
VALUES ('6e1355a6-a6d0-4206-90d9-1ca2b4498318', 'iTunes',
        'https://talksupcdn.sfo3.cdn.digitaloceanspaces.com/e39a212a-d16c-11ec-8bd1-acde48001122.png');
INSERT INTO public.platforms (platform_id, name, logo_url)
VALUES ('3eca4a4b-50fd-48e1-a683-fb1ed323eb1e', 'YouTube',
        'https://talksupcdn.sfo3.cdn.digitaloceanspaces.com/1fff8664-d16d-11ec-8bd1-acde48001122.png');

INSERT INTO public.podcasts (podcast_id, name, description, total_views, cover_pic_url, trailer_url, rating,
                             total_episodes, total_length, release_date, update_date, lang_id, author_id)
VALUES ('57a179b8-d692-4c04-85f7-f95004f86565', 'Colombia Paranormal', 'Investigaciones, audios, noticias y todo un mundo visto desde la fantasía, el terror,
        el cielo y el infierno. Soy Cristian Díaz un joven colombiano que ama todo lo paranormal y quiero que ustedes me acompañen en este viaje extra dimensional y escuche los horrores que nadie se atreve a escuchar.',
        0, 'https://i.scdn.co/image/f87fb665cf17b6332cd51c8f3076e5613cbf2d08',
        'https://open.spotify.com/episode/5pJJYf5rxQIWYTnBsf75tg?si=tPDe2CT3Su-sGI9XV7lZJA', 0, 75, '15h', '2020-06-01',
        '2022-05-06', 'ESP', '2eaed1aa-0993-48c5-b95c-c0c2bb43ad1a');
INSERT INTO public.podcasts (podcast_id, name, description, total_views, cover_pic_url, trailer_url, rating,
                             total_episodes, total_length, release_date, update_date, lang_id, author_id)
VALUES ('a6d465df-738c-4974-a5bc-6c2bdf8780e6', 'Filosofía, Psicología e Historias varias',
        'Relatos breves de filosofía, Psicología e Historias varias, con biografías y algunas reflexiones, leyendas y fantasías.',
        0, 'https://i.scdn.co/image/2bc2a9e504540994ea5bfbe55e8c358c8db5c96b',
        'https://open.spotify.com/episode/4sv9Pu5rH4hgr6bBZ4i5s0?si=vVnRH4UZTH2oi4fdSbzIRQ', 0, 177, '36h',
        '2020-03-01', '2022-05-06', 'ESP', '546e8d6a-f13e-405b-8bff-977463b691bb');
INSERT INTO public.podcasts (podcast_id, name, description, total_views, cover_pic_url, trailer_url, rating,
                             total_episodes, total_length, release_date, update_date, lang_id, author_id)
VALUES ('fbe8d232-d160-11ec-86d2-acde48001122', 'Psicologia al desnudo',
        'En este podcast hablamos de emociones. De tus mecanismos internos: ¿Por qué hacés lo que hacés? ¿Por qué no podés expresar ciertas emociones y otras sí? ¿Por qué te sentís mal a veces? ¿Por qué hay cosas que te angustian, que te generan miedo, nostalgia, o que te dan placer? ¿Cómo regular tus emociones para sentirte equilibrado La gestión emocional es la CLAVE para vivir una vida con sentido. ¡Y está en tus manos aprenderlo! ¿La puerta de entrada a este proceso? Psicología al Desnudo',
        0, 'https://i.scdn.co/image/ab6765630000ba8a412808f7b7b39ba17f687936', '', 0, 71, '27h', '2020-06-20',
        '2022-05-05', 'ESP', 'e2ba8436-d160-11ec-86d2-acde48001122');
INSERT INTO public.podcasts (podcast_id, name, description, total_views, cover_pic_url, trailer_url, rating,
                             total_episodes, total_length, release_date, update_date, lang_id, author_id)
VALUES ('92e70ea4-d168-11ec-8bd1-acde48001122', 'Caso 63',
        'La psiquiatra Elisa Aldunate graba las sesiones de un enigmático paciente, registrado como Caso 63, quien asegura ser un viajero en el tiempo. Lo que comienza como rutinarias sesiones terapéuticas, se transforma rápidamente en un relato que amenaza las fronteras de lo posible y de lo real. Una historia que se mueve libremente entre el futuro y el pasado de dos personajes que, quizás, tienen en sus manos el futuro de la humanidad.',
        0, 'https://i.scdn.co/image/ab6765630000ba8a222c470a223d7e56b1b68d08', '', 0, 23, '7h', '2020-11-01',
        '2021-11-10', 'ESP', '14f108f6-d168-11ec-8bd1-acde48001122');
INSERT INTO public.podcasts (podcast_id, name, description, total_views, cover_pic_url, trailer_url, rating,
                             total_episodes, total_length, release_date, update_date, lang_id, author_id)
VALUES ('dec1ec4c-d16b-11ec-8bd1-acde48001122', 'Sospechosamente light',
        'Los han llamado inmaduros, malcrecidos, adolescentes eternos y no les choca, el tiempo perdido los trajo justo donde no querían al punto donde están muy jóvenes para morir pero muy viejos para vivir.',
        0, 'https://i.scdn.co/image/f2f2024adc4de90952b05e64c80a16cbd3cf92b5', '', 0, 50, '35h', '2020-03-01',
        '2022-05-08', 'ESP', '74be97d2-d16b-11ec-8bd1-acde48001122');
INSERT INTO public.podcasts (podcast_id, name, description, total_views, cover_pic_url, trailer_url, rating,
                             total_episodes, total_length, release_date, update_date, lang_id, author_id)
VALUES ('304f7b64-d16d-11ec-8bd1-acde48001122', 'La cotorrisa',
        'Ricardo Pérez y Slobotzky se ponen a cotorrear como siempre, pero ahora lo están grabando. Escuchalos todos los miercoles hablando de noticias extrañas, datos curiosos, anecdotas hilarantes y aliviana el ombligo de la semana.',
        0, 'https://i.scdn.co/image/ab6765630000ba8a9ed098b86b1f0b5cce92f0c1', '', 0, 161, '230', '2020-03-01',
        '2019-03-01', 'ESP', '03de6f96-d16c-11ec-8bd1-acde48001122');
INSERT INTO public.podcasts (podcast_id, name, description, total_views, cover_pic_url, trailer_url, rating,
                             total_episodes, total_length, release_date, update_date, lang_id, author_id)
VALUES ('fd9fadaa-d16d-11ec-8bd1-acde48001122', 'Con ánimo de ofender',
        'Con ánimo de ofender, la primera serie - documental - blog - película porno, de comedia, hecha para que sepan lo que es la comedia abajo de la tarima. Sin censura, no apta para la tv ! Ni para internet ! Ni para menores ni mayores de edad, ni pa` ni mierda.',
        0, 'https://i.scdn.co/image/ab6765630000ba8afcc4827a5d17d080f5c66024', '', 0, 126, '41h', '2021-01-01',
        '2022-01-01', 'ESP', 'e8664e8a-d16d-11ec-8bd1-acde48001122');
INSERT INTO public.podcasts (podcast_id, name, description, total_views, cover_pic_url, trailer_url, rating,
                             total_episodes, total_length, release_date, update_date, lang_id, author_id)
VALUES ('153c8e32-d16f-11ec-8bd1-acde48001122', 'La hora perturbadora',
        'Un impactante podcast con Luisito Comunica sobre temas paranormales y divertidos. En cada episodio, Luis narrará experiencias paranormales y de ultratumba de la mano de expertos y testigos que nos darán toda la información para hablar de todos los sucesos. Asesinos en serie, experiencias con fantasmas, posesiones, teorías conspirativas, avistamientos extraterrestres y todos los temas que sin duda, serán una experiencia auditiva que mantendrá a los oyentes al filo de sus audífonos y los hará cuestionarse sobre las cosas perturbadoras que los rodean.',
        0, 'https://i.scdn.co/image/ab6765630000ba8a02cdada849659a40ccb53945',
        'https://open.spotify.com/episode/3MIGIPRQhaXg1dsfvj7fGO?si=w8b1FDhmSTqkQJnBxrqzpg', 0, 24, '16h', '2021-11-01',
        '2022-05-08', 'ESP', '14f108f6-d168-11ec-8bd1-acde48001122');
INSERT INTO public.podcasts (podcast_id, name, description, total_views, cover_pic_url, trailer_url, rating,
                             total_episodes, total_length, release_date, update_date, lang_id, author_id)
VALUES ('da66e8cc-d194-11ec-a455-acde48001122', '13%',
        'Contamos historias de personas que aman lo que hacen. Son una minoría especial: no odian los lunes, ni esperan toda la semana a que llegue el viernes.',
        0, 'https://i.scdn.co/image/75f167805352b849105b87f889f521243c4af71f', '', 0, 78, '40h', '2018-01-20',
        '2022-03-27', 'ESP', 'a857e002-d194-11ec-a455-acde48001122');

INSERT INTO public.category_podcast (category_podcast_id, podcast_id, category_id)
VALUES ('91c75c52-eea5-4bbd-8bfa-4be542bfedbc', '57a179b8-d692-4c04-85f7-f95004f86565',
        '35b2881c-210c-4160-b3f7-6252b9ebee49');
INSERT INTO public.category_podcast (category_podcast_id, podcast_id, category_id)
VALUES ('ada4deff-fcbb-41ce-84c6-eac01287a97f', '57a179b8-d692-4c04-85f7-f95004f86565',
        '55abaa24-b920-43ea-bf94-aee5f614e326');
INSERT INTO public.category_podcast (category_podcast_id, podcast_id, category_id)
VALUES ('afb437f8-6025-47c9-a0ee-e6c647d89e5e', 'a6d465df-738c-4974-a5bc-6c2bdf8780e6',
        '472aa79f-fc3a-46d7-8b4b-b4fab318bb6b');
INSERT INTO public.category_podcast (category_podcast_id, podcast_id, category_id)
VALUES ('1b780ac5-03f2-4a16-bb70-d97232a81e53', 'a6d465df-738c-4974-a5bc-6c2bdf8780e6',
        '73220619-faf6-498d-8800-e1d5f468d88a');
INSERT INTO public.category_podcast (category_podcast_id, podcast_id, category_id)
VALUES ('d35cccd6-83e3-436e-89fe-00d290e82e31', 'a6d465df-738c-4974-a5bc-6c2bdf8780e6',
        '2da2f856-e235-436c-bdce-7471b0162846');
INSERT INTO public.category_podcast (category_podcast_id, podcast_id, category_id)
VALUES ('15672656-698f-45a8-9bac-79794935179c', 'fbe8d232-d160-11ec-86d2-acde48001122',
        '2da2f856-e235-436c-bdce-7471b0162846');
INSERT INTO public.category_podcast (category_podcast_id, podcast_id, category_id)
VALUES ('f6725d61-50e2-48b9-a951-97d5a86256a1', 'fbe8d232-d160-11ec-86d2-acde48001122',
        '73220619-faf6-498d-8800-e1d5f468d88a');
INSERT INTO public.category_podcast (category_podcast_id, podcast_id, category_id)
VALUES ('a7dc6ef2-25a9-4d24-abc1-66c44cbee762', '92e70ea4-d168-11ec-8bd1-acde48001122',
        '55abaa24-b920-43ea-bf94-aee5f614e326');
INSERT INTO public.category_podcast (category_podcast_id, podcast_id, category_id)
VALUES ('01b14b20-9651-4f28-aa38-2026ac4f584e', '92e70ea4-d168-11ec-8bd1-acde48001122',
        '7ffc646a-d168-11ec-8bd1-acde48001122');
INSERT INTO public.category_podcast (category_podcast_id, podcast_id, category_id)
VALUES ('dae08bca-e763-44eb-a8ca-4ff1b5c057a5', 'dec1ec4c-d16b-11ec-8bd1-acde48001122',
        '4a0f3c26-d16b-11ec-8bd1-acde48001122');
INSERT INTO public.category_podcast (category_podcast_id, podcast_id, category_id)
VALUES ('727d2a45-75ed-44ad-b5c2-ec218815050e', 'dec1ec4c-d16b-11ec-8bd1-acde48001122',
        'f67a4547-31fe-4bba-8556-526cac7f4fa0');
INSERT INTO public.category_podcast (category_podcast_id, podcast_id, category_id)
VALUES ('3ead30b2-6189-47e8-81c1-bd4622a00d04', '304f7b64-d16d-11ec-8bd1-acde48001122',
        '4a0f3c26-d16b-11ec-8bd1-acde48001122');
INSERT INTO public.category_podcast (category_podcast_id, podcast_id, category_id)
VALUES ('30590534-5cf3-4322-ae6a-740a8462919a', '304f7b64-d16d-11ec-8bd1-acde48001122',
        'f67a4547-31fe-4bba-8556-526cac7f4fa0');
INSERT INTO public.category_podcast (category_podcast_id, podcast_id, category_id)
VALUES ('94474ac2-a2c1-44be-876b-209a4e26a057', 'fd9fadaa-d16d-11ec-8bd1-acde48001122',
        '4a0f3c26-d16b-11ec-8bd1-acde48001122');
INSERT INTO public.category_podcast (category_podcast_id, podcast_id, category_id)
VALUES ('e6b444b4-59f0-46d7-b887-988a4db4f2e7', 'fd9fadaa-d16d-11ec-8bd1-acde48001122',
        'f67a4547-31fe-4bba-8556-526cac7f4fa0');
INSERT INTO public.category_podcast (category_podcast_id, podcast_id, category_id)
VALUES ('0e5b9713-d40e-4f5a-bd36-4c0f6e1f3c82', '153c8e32-d16f-11ec-8bd1-acde48001122',
        '35b2881c-210c-4160-b3f7-6252b9ebee49');
INSERT INTO public.category_podcast (category_podcast_id, podcast_id, category_id)
VALUES ('83cef2e2-6ee6-4a05-a32d-dfb8df2fd289', '153c8e32-d16f-11ec-8bd1-acde48001122',
        '55abaa24-b920-43ea-bf94-aee5f614e326');
INSERT INTO public.category_podcast (category_podcast_id, podcast_id, category_id)
VALUES ('2b79433d-65a7-4942-ac4c-718311e4ecea', '153c8e32-d16f-11ec-8bd1-acde48001122',
        'f67a4547-31fe-4bba-8556-526cac7f4fa0');
INSERT INTO public.category_podcast (category_podcast_id, podcast_id, category_id)
VALUES ('363a3876-a9e7-4ffc-9b30-61bee10537c2', 'da66e8cc-d194-11ec-a455-acde48001122',
        '9562cf3e-d194-11ec-a455-acde48001122');

INSERT INTO public.platform_podcast (platform_podcast_id, podcast_id, platform_id, redirect_url)
VALUES ('06c802cb-5f3d-47d5-a252-b1566a35ae26', '57a179b8-d692-4c04-85f7-f95004f86565',
        'eb4b1438-da09-4b37-be59-4d921aeba947', 'https://open.spotify.com/show/3XUm8M13zg1jaaUxCRJE64');
INSERT INTO public.platform_podcast (platform_podcast_id, podcast_id, platform_id, redirect_url)
VALUES ('43dbe3cf-4022-46b9-b25a-4537b56e2fef', 'a6d465df-738c-4974-a5bc-6c2bdf8780e6',
        'eb4b1438-da09-4b37-be59-4d921aeba947', 'https://open.spotify.com/show/17dk0hYDmVq7EzGXC8y4u6');
INSERT INTO public.platform_podcast (platform_podcast_id, podcast_id, platform_id, redirect_url)
VALUES ('e23677c9-9451-4be7-ab54-f187fbdbd9b7', 'fbe8d232-d160-11ec-86d2-acde48001122',
        'eb4b1438-da09-4b37-be59-4d921aeba947', 'https://open.spotify.com/show/1TDJJoHWEq7Nbh3yEBOJOj');
INSERT INTO public.platform_podcast (platform_podcast_id, podcast_id, platform_id, redirect_url)
VALUES ('02f9962b-1b81-4b25-9a9a-d15dc6532371', '92e70ea4-d168-11ec-8bd1-acde48001122',
        'eb4b1438-da09-4b37-be59-4d921aeba947', 'https://open.spotify.com/show/20ch3IIqtWSSM4nfy11ZzP');
INSERT INTO public.platform_podcast (platform_podcast_id, podcast_id, platform_id, redirect_url)
VALUES ('a8c0b80b-4449-4e4d-96e7-d0ba1d5eaec4', 'dec1ec4c-d16b-11ec-8bd1-acde48001122',
        'eb4b1438-da09-4b37-be59-4d921aeba947', 'https://open.spotify.com/show/1aYPBvV7AIilRkyORTD1X3');
INSERT INTO public.platform_podcast (platform_podcast_id, podcast_id, platform_id, redirect_url)
VALUES ('d6cd3112-3131-4b4c-9467-1805bbed9a5a', '304f7b64-d16d-11ec-8bd1-acde48001122',
        'eb4b1438-da09-4b37-be59-4d921aeba947', 'https://open.spotify.com/show/3a36uQneX1imRuopaknUqw');
INSERT INTO public.platform_podcast (platform_podcast_id, podcast_id, platform_id, redirect_url)
VALUES ('186de648-39d7-4ae2-a774-dd5197577355', '304f7b64-d16d-11ec-8bd1-acde48001122',
        '6e1355a6-a6d0-4206-90d9-1ca2b4498318', 'https://podcasts.apple.com/co/podcast/la-cotorrisa/id1458792155');
INSERT INTO public.platform_podcast (platform_podcast_id, podcast_id, platform_id, redirect_url)
VALUES ('4546e5ee-bedd-492f-9d11-9faadc2cc33b', '304f7b64-d16d-11ec-8bd1-acde48001122',
        '3eca4a4b-50fd-48e1-a683-fb1ed323eb1e', 'https://youtube.com/playlist?list=PLTlY-r_NNnuJPwVNbolOymptC6SeFUewJ');
INSERT INTO public.platform_podcast (platform_podcast_id, podcast_id, platform_id, redirect_url)
VALUES ('c05bc622-4f98-4c9d-b050-9e1cc6462617', 'fd9fadaa-d16d-11ec-8bd1-acde48001122',
        'eb4b1438-da09-4b37-be59-4d921aeba947', 'https://open.spotify.com/show/0oIhHZSGWIjkJh27DlB5uv');
INSERT INTO public.platform_podcast (platform_podcast_id, podcast_id, platform_id, redirect_url)
VALUES ('ef25d02a-d32d-47fd-bd10-9fb68993fe33', 'fd9fadaa-d16d-11ec-8bd1-acde48001122',
        '3eca4a4b-50fd-48e1-a683-fb1ed323eb1e',
        'https://www.youtube.com/playlist?list=PLI-lha5pHEe7eq2X4W2vDI4upqy-GrawQ');
INSERT INTO public.platform_podcast (platform_podcast_id, podcast_id, platform_id, redirect_url)
VALUES ('19f12935-e0ab-4533-b06a-b6b4fb3c85b8', '153c8e32-d16f-11ec-8bd1-acde48001122',
        'eb4b1438-da09-4b37-be59-4d921aeba947', 'https://open.spotify.com/show/7A90TRFsavNZ2WE1m55jeU');
INSERT INTO public.platform_podcast (platform_podcast_id, podcast_id, platform_id, redirect_url)
VALUES ('172d3f06-0e48-4052-bd3c-c9444c1551b7', 'da66e8cc-d194-11ec-a455-acde48001122',
        'eb4b1438-da09-4b37-be59-4d921aeba947', 'https://open.spotify.com/show/3PR2zd9DZNCDWefPlVwCA2');

INSERT INTO public.lists (list_id, name, description, icon_url, cover_pic_url, likes, user_id)
VALUES ('43f3e1dc-70c0-4f2d-88a4-355e8050a661', 'Psicologia a otro level', 'Podcasts de filosofia y psicologia', null,
        null, 0, '86f45ee6-c5a4-11ec-b46f-6a2f678b91f3');

INSERT INTO public.likes (like_id, list_id, user_id)
VALUES ('38fbeab4-9cdb-4fe0-b22a-5153681731ce', '43f3e1dc-70c0-4f2d-88a4-355e8050a661',
        '86f45ee6-c5a4-11ec-b46f-6a2f678b91f3');
INSERT INTO public.likes (like_id, list_id, user_id)
VALUES ('34a2c938-8a90-4f89-aa72-cfb0a35da75c', '43f3e1dc-70c0-4f2d-88a4-355e8050a661',
        '2bac0baa-cef6-11ec-b31f-acde48001122');

INSERT INTO public.lists_podcast (lists_podcast_id, podcast_id, list_id)
VALUES ('e54eed98-df85-488b-b260-a3f248d704c8', '57a179b8-d692-4c04-85f7-f95004f86565',
        '43f3e1dc-70c0-4f2d-88a4-355e8050a661');
INSERT INTO public.lists_podcast (lists_podcast_id, podcast_id, list_id)
VALUES ('4956baab-c863-4192-89a9-5695beb5caaf', 'fbe8d232-d160-11ec-86d2-acde48001122',
        '43f3e1dc-70c0-4f2d-88a4-355e8050a661');
-- GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO apptalksup;