# bump-everywhere

> 🚀 Automate versioning, changelog creation, README updates and GitHub releases using GitHub Actions,npm, docker or bash.

[![contributions welcome](https://img.shields.io/badge/contributions-welcome-brightgreen.svg?style=flat)](https://github.com/undergroundwires/bump-everywhere/issues)
[![Quality checks](https://github.com/undergroundwires/bump-everywhere/workflows/Quality%20checks/badge.svg)](./.github/workflows/quality-checks.yaml)
[![Bump & release](https://github.com/undergroundwires/bump-everywhere/workflows/Bump%20&%20release/badge.svg)](./.github/workflows/bump-and-release.yaml)
[![Publish](https://github.com/undergroundwires/bump-everywhere/workflows/Publish/badge.svg)](./.github/workflows/publish.yaml)
[![Test](https://github.com/undergroundwires/bump-everywhere/workflows/Test/badge.svg)](./.github/workflows/test.yaml)
[![Code size](https://img.shields.io/github/languages/code-size/undergroundwires/bump-everywhere)](./scripts)
[![Docker image size](https://img.shields.io/docker/image-size/undergroundwires/bump-everywhere)](https://hub.docker.com/r/undergroundwires/bump-everywhere)
[![Auto-versioned by bump-everywhere](https://github.com/undergroundwires/bump-everywhere/blob/master/badge.svg?raw=true)](https://github.com/undergroundwires/bump-everywhere)

<!-- [![npm](https://img.shields.io/npm/v/bump-everywhere/latest)](https://www.npmjs.com/package/bump-everywhere) -->

![functions of bump-everywhere](./img/functions.png)

## Features

🤖 Allows you to automatically:

- Bump your semantic git tag by increasing the patch version.
- Create & commit a changelog file.
- If `npm` project then bump `package.json` version and commit.
- Check `README.md` file, if it has references to older version, update with never version.
- Create a release on GitHub with auto-generated release notes.

✅ Other features include:

- Zero-configuration for most use-cases, but can still be customized.
- It supports safe re-runs, it means that if you can run it for an already bumped or tagged repository, it'll not increase the version as everything is still up-to-date. It protects against recursive runs.

## Usage

### Option 1. Use GitHub actions

```yaml
- uses: undergroundwires/bump-everywhere@master
  with:
    # Repository name with owner to bump & release. For example, undergroundwires/bump-everywhere
    # (Optional) Default: ${{ github.repository  }}
    repository: ""

    # Name of the user who will do the bump commit
    # (Optional) Default: ${{ github.actor }}
    user: ""

    # Commit message that will be used in the bump commit
    # (Optional) Default: ⬆️ bump everywhere to {{version}}
    commit-message: ""

    # Personal access token (PAT) used to clone & push to the repository.
    # If you use default, it'll not trigger other actions, but your own PAT then it triggers new actions
    # (Optional) Default: ${{ github.token }}
    git-token: ""

    # The type of the GitHub release
    # Options: 'release' | 'prerelease' | 'draft' | 'none' (does not release)
    # (Optional) Default: 'release'
    release-type: ""

    # Personal access token (PAT) used to release to GitHub.
    # Used only if release-type is not "none"
    # If you use default, it'll not trigger other actions, but your own PAT then it triggers new actions
    # (Optional) Default: ${{ github.token }}
    release-token: ""

    # Git branch to push the changes such as version tags, CHANGELOG file, version changes...
    # Configuring this should not be needed for most use-cases.
    # Use this only if you DO NOT use a single main default branch (e.g. `master` or `main`).
    # (Optional) Default: Default "git clone" behavior. Checks out to default branch of remote.
    branch: ""
```

[↑](#bump-everywhere)

### Option 2. Use Docker

- To get the image you can either:
  - Pull from docker hub using `docker pull undergroundwires/bump-everywhere:latest`
  - Or build image yourself using `docker build . --tag undergroundwires/bump-everywhere:latest`
- Run with arguments:

  ```sh
    args=(
      # Required:
      --repository "undergroundwires/privacy.sexy"
      --user "bot-user"
      --git-token "GitHub PAT for pushes"
      --release-type "prerelease"
      --release-token "GitHub PAT for releases"
      --commit-message "⬆️ bump to {{version}}"
      # Optional:
      --branch 'custom branch name'
    )
    docker run undergroundwires/bump-everywhere "${args[@]}"
  ```

[↑](#bump-everywhere)

### Option 3. Use `npm`

1. (Optionally) install globally: `npm install -g bump-everywhere`
   - or locally: `npm install bump-every-where --save-dev`
2. Run `npx bump-everywhere <parameters...>`
   - See [docker example](#option-2-use-docker) for parameter usage

[↑](#bump-everywhere)

### Option 4. Use scripts

1. Ensure `bash` (4 or newer), `git`, `curl`, `jq` exists in your environment
   - On Alpine: `apk add bash git curl jq`
   - On Windows: `choco install git curl jq` and use Git Bash
2. Clone this repository: `git clone https://github.com/undergroundwires/bump-everywhere`
   - or optionally add this repository as git submodule: `git submodule add https://github.com/undergroundwires/bump-everywhere`
3. Call the script: `bash "scripts/bump-everywhere.sh" <parameters>`
   - See [docker example](#option-2-use-docker) for parameter usage

[↑](#bump-everywhere)

## Updating minor & major versions

bump-everywhere only increases your patch versions. You manually tag your last commit to update major & minor versions.

E.g. :

```sh
  git commit -m "bumped version to 1.4.0" --allow-empty
  git tag 1.4.0
  git push && git push origin 1.4.0
```

[↑](#bump-everywhere)

## All scripts

You can also use following scripts individually (check script files for usage, prerequisites & dependencies):

- **[bump-and-tag-version.sh](./scripts/bump-and-tag-version.sh)**: Automate versioning.
- **[create-github-release.sh](./scripts/create-github-release.sh)**: Automate creating GitHub releases
- **[print-changelog.sh](./scripts/print-changelog.sh)**: Automate creation of changelogs, e.g. `CHANGELOG.md`.
- **[configure-github-repo.sh](./scripts/configure-github-repo.sh)**: Set-up CI/CD user for current repository.
- **[log-commits.sh](./scripts/shared/log-commits.sh)**: Filters & logs commits as bullet points in markdown form.
- **[bump-npm-version.sh](./scripts/bump-npm-version.sh)**: Updates `packages.json` to match the latest version.
- **[bump-readme-versions.sh](./scripts/bump-readme-versions.sh)**: Updates old references to `README.md` to the latest version.

[↑](#bump-everywhere)

## Some example usages

- [bump-everywhere](https://github.com/undergroundwires/bump-everywhere#gitops): Repository itself is automatically versioned & released using its own action
- [privacy.sexy](https://github.com/undergroundwires/privacy.sexy#gitops-cicd-to-aws)
- [safe-email](https://github.com/undergroundwires/safe-email#gitops)
- [ez-consent](https://github.com/undergroundwires/ez-consent#gitops)
- [aws-static-site-with-cd](https://github.com/undergroundwires/aws-static-site-with-cd)

[↑](#bump-everywhere)

## Support

**Sponsor 💕**. Consider one time or recurring donation on [GitHub Sponsors](https://github.com/sponsors/undergroundwires) or [any other way (undrgroundwires.dev/donate)](https://undergroundwires.dev/donate), every penny you leave will help development and maintenance of the project .

**Star 🤩**. If you do cannot do that you can just give it a star ⭐ . It helps me to see that the project is appreciated.

**Badge 📛**. If you use the project, feel free to use the badge in the `README.md` of repository where you use bump-everywhere so we can have larger community that can help improving the project. It would look like [![Auto-versioned by bump-everywhere](https://github.com/undergroundwires/bump-everywhere/blob/master/badge.svg?raw=true)](https://github.com/undergroundwires/bump-everywhere)). You can add following in your markdown file:

```markdown
[![Auto-versioned by bump-everywhere](https://github.com/undergroundwires/bump-everywhere/blob/master/badge.svg?raw=true)](https://github.com/undergroundwires/bump-everywhere)
```

[↑](#bump-everywhere)

## GitOps

CI/CD is fully automated for this repo using different GIT events and GitHub actions.

[![GitOps flow](./img/gitops.png)](./.github/workflows)

[↑](#bump-everywhere)
