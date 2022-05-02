# TalksUp API 

[![forthebadge made-with-go](http://ForTheBadge.com/images/badges/made-with-go.svg)](https://go.dev/) 

[![GoDoc reference example](https://img.shields.io/badge/godoc-reference-blue.svg)](https://godoc.org/nanomsg.org/go/mangos/v2) [![MIT license](https://img.shields.io/badge/License-MIT-blue.svg)](https://lbesson.mit-license.org/)


Made with ♥️ by [@Sebasvil20](https://www.linkedin.com/in/sebasvil20/) and [@Santisepulveda90](https://www.linkedin.com/in/santiago-sep%C3%BAlveda-bonilla-70ab32208/)

This is the backend API to TalksUp project, a podcast recommendations based on user likes

Main features
* API Key required, otherwise API cannot be consumed
* RESTful endpoints
* Dependency Injection and N capes structure
* Standard CRUD operations of a database table
* JWT-based authentication
* Environment dependent application configuration management

## Getting Started

If this is your first time encountering Go, please follow [the instructions](https://golang.org/doc/install) to
install Go on your computer. The API requires **Go 1.14 or above**.

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

* `GET /health`: a healthcheck service provided for health checking purpose
* `POST /users/new`: create new user
* `POST /users/login`: login with user credentials to receive jwt token
* `GET /users`: get all users with their likes *
* `GET /categories?lang=`: get all categories, optional lang query param e.g. ESP

(*) Admin role required

Try the URL `http://localhost:8080/health` in a browser, and you should see something like `"PONG"` displayed.

## Project Layout

The TalksUpAPI uses the following project layout:
 
```
.
├── migrations                   SQL Files with db struct
├── src                 
│    └── api                      main applications of the project
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

Within each feature package, code are organized in layers (API, service, repository), following the dependency guidelines
as described in the [clean architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html).

## Deployment

Open a Pull Request to `main` branch, if all checks of CI pass and you merge the branch, the CD'll start running and the app will be automatically updated
