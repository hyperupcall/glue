# Glue

Hypergeneral boilerplate manager and task runner

## Archived

Superceded by [Foxxy](https://github.com/hyperupcall/foxxy)

---


Glue is the manifestation of a generalized task runner with respect to language agnosticity

If you have a Node project, are you tired of the following monotonous tasks?

- Integrating Husky/pre-commit with applicable bullets
- Integrating lint-staged
- Running Jest/Ava tests and generating code coverage
- Hooking up Prettier/eslint linting
- Automatically versioning each build
- Uploading build artifacts to a particular registry
- Create a documentation website
- Creating/building/uploading Docker images
- Configuring CI
- etc.

If you have a Go project, are you tired of the following monotonous tasks?

- Setting up goreleaser
- Integrating Husky/pre-commit with applicable bullets
- Running tests
- Hooking up golangci-lint
- Automatically versioning each build
- Creating/building/uploading Docker images
- Packaging/Distributing your app in the form of a Snap, Debian package, AppImage, etc.
- Configuring CI
- etc.

Indeed, `cookiecutter`, `yeoman`, and in general, project template generators help, but if you want to add functionality to an existing project that has already had its boilerplate initialized, you would have to add it manually in every case. This makes consistent behavior across similar project types somewhat tricky since localized configuration drift is inevitable. If you're anything like me, you probably ended up not procuring the best configuration for any given project since it's quite laborious to do and it isn't automated

Some benefits of Glue include

- It can be used for any language, technology, or framework
- Automation scripts can be writen in any language (Bash, Python)
- Scripts are automatically copied to each project and stored in version control (Reproducible Builds / Transparency / Traceability)
- Escape hatches to override or modify the behavior of any particular script
- Written in pure Bash
- Written for speed (Uses subshells quite sporadically (excluding the 'sync' command))
- Configuration decoupled from traditional configuration locations

Some detriments of Glue include

- User scripts can have a boilerplate nature due to the inherit caveats of the `.glue` folder structure and the fact that Glue is a task runner framework, rather than a script library
- It's general nature means you must write bootstrap strings to be eval'd later given the language of implementation of your script files (see `bootstrap.sh` in a Glue store)

### Details

CURRENT STATE: IN DEVELOPMENT

For concrete examples see [glue-example](https://github.com/eankeen/glue-example) and it's respective [glue-store](https://github.com/eankeen/glue-store)

See [details.md](./docs/details.md)

## Installation

Use [Basalt](https://github.com/hyperupcall/basalt), a Bash package manager, to install this project globally

```sh
basalt global add hyperupcall/glue
```
