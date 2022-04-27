# TalksUp API 

[![forthebadge made-with-go](http://ForTheBadge.com/images/badges/made-with-go.svg)](https://go.dev/) 

[![GoDoc reference example](https://img.shields.io/badge/godoc-reference-blue.svg)](https://godoc.org/nanomsg.org/go/mangos/v2) [![MIT license](https://img.shields.io/badge/License-MIT-blue.svg)](https://lbesson.mit-license.org/)


Made with ♥️ by [@Sebasvil20](https://www.linkedin.com/in/sebasvil20/) and @Trueni

This is the backend API to TalksUp project, a podcast recommendations based on user likes

Main features
* RESTful endpoints
* Dependency Injection and N capes structure
* Standard CRUD operations of a database table
* JWT-based authentication
* Environment dependent application configuration management

## Getting Started

If this is your first time encountering Go, please follow [the instructions](https://golang.org/doc/install) to
install Go on your computer. The kit requires **Go 1.14 or above**.

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

* `GET /ping`: a healthcheck service provided for health checking purpose
* `POST /users`: create new user

Try the URL `http://localhost:8080/healthcheck` in a browser, and you should see something like `"PONG"` displayed.

To use the starter kit as a starting point of a real project whose package name is `github.com/abc/xyz`, do a global 
replacement of the string `github.com/qiangxue/go-rest-api` in all of project files with the string `github.com/abc/xyz`.


## Project Layout

The starter kit uses the following project layout:
 
```
.
├── migrations          SQL Files with db struct
├── src                 
│   └── api             main applications of the project
│        └── app        dependency injection providers and router handler
│        └── config     configurations and global vars
│        └── controllers first cape of API where the request is received
│        └── models     all API structs
│        └── repository access to database data
│        └── service    all business logic
│        └── utls       several util funcs
└── 
```

The top level directories `src`, `internal`, `pkg` are commonly found in other popular Go projects, as explained in
[Standard Go Project Layout](https://github.com/golang-standards/project-layout).

Within each feature package, code are organized in layers (API, service, repository), following the dependency guidelines
as described in the [clean architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html).

## Deployment

Open a Pull Request to `main` branch, if all checks of CI pass and you merge the branch, the CD'll start running and the app will be automatically updated
