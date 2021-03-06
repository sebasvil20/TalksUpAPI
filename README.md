# TalksUp API

[![forthebadge made-with-go](http://ForTheBadge.com/images/badges/made-with-go.svg)](https://go.dev/)
[![digital ocean](https://img.shields.io/badge/Digital_Ocean-0080FF?style=for-the-badge&logo=DigitalOcean&logoColor=white)]()
[![postgresql](https://img.shields.io/badge/PostgreSQL-316192?style=for-the-badge&logo=postgresql&logoColor=white)]()

[![GoDoc reference example](https://img.shields.io/badge/godoc-reference-blue.svg)](https://godoc.org/nanomsg.org/go/mangos/v2) [![MIT license](https://img.shields.io/badge/License-MIT-blue.svg)](https://lbesson.mit-license.org/)

Made with ♥️ by [@Sebasvil20](https://www.linkedin.com/in/sebasvil20/)
and [@Santisepulveda90](https://www.linkedin.com/in/santiago-sep%C3%BAlveda-bonilla-70ab32208/)

This is the backend API to TalksUp project, a podcast recommendations based on user likes

Main features

* RESTful API
* API Key required, otherwise API cannot be consumed
* Dependency Injection
* Standard CRUD operations on database tables
* JWT-based authentication
* Environment dependent application configuration management

## Getting Started

If this is your first time encountering Go, please follow [the instructions](https://golang.org/doc/install) to install Go on your computer.
The API requires **Go 1.14 or above**.

After installing Go, run the following commands to start experiencing with the API:

```shell
# download the TalksUp API
git clone git@github.com:sebasvil20/TalksUpAPI.git

cd TalksUpAPI

# Install dependencies
go mod tidy

# start a PostgreSQL database server
brew services start postgresql

# Create database
createdb talksup

# run migrations script from migrations/talksup.sql

# Run API
SCOPE=DEV
go build src/api/main.go
```

At this time, you have a RESTful API server running at `http://127.0.0.1:8080`. It provides the following endpoints:

### Utils

| Method | Endpoint                       | Description                                                                                   |
|--------|--------------------------------|-----------------------------------------------------------------------------------------------|
| `GET`  | `/health`                      | Healthcheck service provided for health checking purpose                                      |
| `PUT`  | `/upload`                      | Requires a form-data content type with a file on it. Uploads an image and returns the cdn url |

### Auth

| Method | Endpoint           | Description                                      |
|--------|--------------------|--------------------------------------------------|
| `GET`  | `/auth/login`      | Login with user credentials to receive jwt token |
| `GET`  | `/auth/validate`   | Validates the given jwt (passed by headers)      |   

### Users

| Method | Endpoint                  | Description                                      |
|--------|---------------------------|--------------------------------------------------|
| `GET`  | `/users`                  | Get all users with their likes *                 |
| `GET`  | `/users/:user_id/reviews` | Get all reviews by user id                       |
| `POST` | `/users`                  | Create new user                                  |
| `PUT`  | `/users`                  | Updates given user                               |
| `POST` | `/users/associate`        | Associate user with a list of categories (likes) |

### Categories

| Method | Endpoint                       | Description                                                                                  |
|--------|--------------------------------|----------------------------------------------------------------------------------------------|
| `GET`  | `/categories?lang=`            | Get all categories, optional lang query param e.g. ESP                                       |
| `GET`  | `/categories`                  | Get all users with their likes *                                                             |
| `POST` | `/categories`                  | Create new category *                                                                        |

### Authors

| Method   | Endpoint              | Description                                             |
|----------|-----------------------|---------------------------------------------------------|
| `GET`    | `/authors`            | Get all authors                                         |
| `GET`    | `/authors/:authod_id` | Get author by id. Returns author info and its podcasts  |
| `POST`   | `/authors`            | Create new author *                                     |
| `DELETE` | `/authors/:id`        | Delete author *                                         |

### Podcasts

| Method | Endpoint                        | Description                                                            |
|--------|---------------------------------|------------------------------------------------------------------------|
| `GET`  | `/podcasts?category_id=&lang=`  | Get all podcasts with fully info (categories, author, lang, platforms) |
| `GET`  | `/podcasts/:podcast_id/reviews` | Get all reviews by podcast id                                          |
| `POST` | `/podcasts`                     | Create new podcast *                                                   |
| `POST` | `/podcasts/associate`           | Associate podcast with a list of categories                            |

### Lists

| Method   | Endpoint           | Description                               |
|----------|--------------------|-------------------------------------------|
| `GET`    | `/lists`           | Get all podcast list                      |
| `GET`    | `/lists/:id`       | Get detailed podcast list                 |
| `POST`   | `/lists`           | Create new list                           |
| `POST`   | `/lists/associate` | Associate a slice of podcasts with a list |
| `POST`   | `/lists/like`      | Likes a list                              |
| `DELETE` | `/lists/:id`       | Delete a list                             |

### Reviews

| Method   | Endpoint       | Description                 |
|----------|----------------|-----------------------------|
| `POST`   | `/reviews`     | Create review for a podcast |
| `DELETE` | `/reviews/:id` | Delete an owned review      |

> (*) Admin role required

> (**) Admin role not required but admin approval required

Try the URL `http://localhost:8080/health` in a browser, and you should see something like `"PONG"` displayed.

## Project Layout

The TalksUpAPI uses the following project layout:

```
.
├── migrations                   SQL Files with db struct
├── src                 
│    └── api                     main applications of the project
│        └── app                 dependency injection providers and router handler
│        └── config              configurations and global vars
│        └── controllers         first cape of API where the request is received
│        └── models              all API structs
│        └── repository          access to database data
│        └── service             all business logic
│        └── utils               several util funcs
│              └── middleware    middleware funcs to handle api keys and auth
│              └── auth          jwt related funcs (Generate and validate)
└── 
```

The top level directories `src`, `internal`, `pkg` are commonly found in other popular Go projects, as explained in
[Standard Go Project Layout](https://github.com/golang-standards/project-layout).

Within each feature package, code are organized in layers (API, service, repository), following the dependency guidelines as described in
the [clean architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html).

## Deployment

Open a Pull Request to `main` branch, if all checks of CI pass and you merge the branch, the CD'll start running and the app will be
automatically updated
