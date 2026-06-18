# Chamber Cardio — Tuva Fork

This is Chamber Cardio's fork of the [Tuva Project](https://github.com/tuva-health/tuva). It contains Chamber-specific customizations on top of the upstream package and is installed as a dbt package in [chamber/dbt-development](https://github.com/Chamber-Cardio/dbt-development).


---

## Branch Structure

| Branch | Purpose | Who touches it |
|---|---|---|
| `chamber-dev` | Chamber customizations — **default branch** | Team PRs |
| `main` | Exact mirror of `upstream/main` | Maintained by syncing on GitHub or by a hard reset |
ß
> **Start here:** Clone the repo and you will automatically land on `chamber-dev`. Do not commit directly to `main`.

## Rules of the Road

- **Never commit directly to `main`** — it is the upstream mirror and will be overwritten on the next sync
- **Always target `chamber-dev`** for PRs with Chamber-specific work
- **Always target `tuva-health/tuva:main`** for PRs contributing back upstream
- **Use `git pull --rebase`** when updating your local `chamber-dev`

## First-Time Setup

```bash
git clone git@github.com:Chamber-Cardio/tuva.git
cd tuva

# Confirm you are on chamber-dev
git branch
# * chamber-dev

# Verify remotes
git remote -v
# origin    git@github.com:Chamber-Cardio/tuva.git (fetch)
# origin    git@github.com:Chamber-Cardio/tuva.git (push)
# upstream  https://github.com/tuva-health/tuva.git (fetch)
# upstream  https://github.com/tuva-health/tuva.git (push)
```

If the `upstream` remote is missing, add it:

```bash
git remote add upstream https://github.com/tuva-health/tuva.git
```

## Syncing with Upstream

Run this whenever the Tuva Project cuts a new release. We could do this anytime commits are added to tuva/main, but releases are generally more stable.

In order to force push to the `main` and `chamber-dev` branches the following steps must be done:
- Commit author must be added as an `admin` role under `Settings` > `Collaborators and teams`
- Branch protection must be **temporarily** disabled by updating `Settings` > `Branches`
  - Uncheck `Require a pull request before merging`
  - Check `Allow force pushes`
  - Select `Save changes`

```bash
# 1. Pull the latest upstream changes
git fetch upstream

# 2. Fast-forward main to match upstream exactly
git checkout main
git merge upstream/main --ff-only
git push origin main --force-with-lease

# 3. Rebase Chamber customizations onto the updated main
git checkout chamber-dev
git rebase main

# 4. Resolve any conflicts, then push
git push origin chamber-dev --force-with-lease
```

After syncing, team members should update their local branch with:

```bash
git pull --rebase origin chamber-dev
```

> Use `--rebase` rather than plain `git pull` because `chamber-dev` is a rebasing branch. A regular merge pull will create unnecessary merge commits.

After changes are complete, branch protection must be re-enabled by updating `Settings` > `Branches`
  - Check `Require a pull request before merging`
  - Uncheck `Allow force pushes`
  - Select `Save changes`

## Contributing Chamber-Specific Changes

All Chamber customizations go into `chamber-dev` via pull request.

```bash
# 1. Branch from chamber-dev
git checkout chamber-dev
git checkout -b feature/your-feature-name

# 2. Make changes and commit
git add .
git commit -m "Description of change"

# 3. Push and open a PR against Chamber-Cardio/tuva:chamber-dev
git push origin feature/your-feature-name
```

Open the PR against **`chamber-dev`**, not `main`.

## Contributing a Fix Back to Upstream

If a fix is general enough to benefit the broader Tuva community, contribute it back to [tuva-health/tuva](https://github.com/tuva-health/tuva).

```bash
# 1. Branch from main (clean upstream base — no Chamber customizations)
git checkout main
git checkout -b fix/your-fix-name

# 2. Make changes and commit
git add .
git commit -m "Fix: description of fix"

# 3. Push and open a PR against tuva-health/tuva:main
git push origin fix/your-fix-name
```

When opening the PR on GitHub, make sure the **base repository** is set to `tuva-health/tuva` and the base branch is `main`.

Once upstream merges and releases the fix, it will automatically come back into `main` the next time you run the sync workflow above — no need to keep the commit on `chamber-dev`.

### Cherry-Picking Existing Commits to Upstream

If fixes already landed on `chamber-dev` and you want to contribute them back upstream, cherry-pick them onto a clean branch from `main`:

```bash
# 1. Fetch the latest upstream
git fetch upstream

# 2. Create a new branch from upstream/main
git checkout -b snapshot-improvements upstream/main

# 3. Cherry-pick the commits (oldest first)
git cherry-pick 713dbbfe   # [SC-4404] Bug fix for cms hcc snapshots
git cherry-pick eaee0cf5   # [SC-4422] Snapshot improvements

# 4. Push and open a PR against tuva-health/tuva:main
git push -u origin snapshot-improvements
```

If you hit conflicts during cherry-pick, resolve them and run `git cherry-pick --continue`.

## Releases

Chamber tags a fork release whenever we cut a new version for consumption by [chamber/dbt-development](https://github.com/Chamber-Cardio/dbt-development). Tags follow the pattern `<upstream-version>+chamber.<N>`, where:

- `<upstream-version>` is the Tuva release the fork is based on (e.g. `0.17.1`).
- `+chamber.<N>` is a monotonically increasing Chamber build number against that upstream version, reset to `.0` whenever we sync to a new upstream release.

All releases live at [Chamber-Cardio/tuva/releases](https://github.com/Chamber-Cardio/tuva/releases).

### Cutting a release

1. Merge all Chamber PRs into `chamber-dev`.
2. On GitHub, draft a new release pointing at the tip of `chamber-dev`.
3. Use the tag format above and title it `[<tag>] <short description>`.
4. In the body, list each change with its SC ticket (where applicable) and PR number.
5. Publish the release, then bump the pinned revision in `chamber/dbt-development/packages.yml`.

### Release history

| Release | Date | Based on upstream | Contents |
|---|---|---|---|
| [`0.17.1+chamber.1`](https://github.com/Chamber-Cardio/tuva/releases/tag/0.17.1%2Bchamber.1) | 2026-04-22 | `0.17.1` | CMS HCC snapshots bug fix (SC-4404, #6); Snapshot improvements (SC-4422, #7); README update (#8); ED encounters bug fix (#9) |

---
---
<br><br><br>

# The Tuva Project

[![Apache License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0) ![dbt logo and version](https://img.shields.io/static/v1?logo=dbt&label=dbt-version&message=1.10%2B&color=orange)

![Tuva Project Overview](./docs/static/img/tuva_project_overview_from_downloads.jpg)

## What is the Tuva Project?

The Tuva Project is a dbt package for transforming raw healthcare data into analytics-ready data. The package includes:

- Input Layer
- Claims Preprocessing
- Core Data Model
- Data Marts
- Terminology and Value Sets

## Docs

- [Getting Started](https://www.thetuvaproject.com/getting-started)
- [dbt Variables](https://www.thetuvaproject.com/dbt-variables)
- [Full Documentation](https://www.thetuvaproject.com/)

The docs source for the getting-started runbook lives in [docs/docs/getting-started.md](./docs/docs/getting-started.md).

## Local Development

Recommended local setup:

- Python 3.10 or later
- DuckDB
- `dbt-core` and `dbt-duckdb`

Use `integration_tests` as your development project. Configure a DuckDB connection in `profiles.yml`, then run from the repo root:

```bash
./scripts/dbt-local deps
./scripts/dbt-local build --full-refresh
```

`dbt seed` and `dbt build` load package-owned synthetic data into `synthetic_data` from versioned S3 artifacts. `dbt run` assumes those relations already exist, so on a fresh database you should run `seed` or `build` first.

Once the synthetic data is loaded, iterate with:

```bash
./scripts/dbt-local run
```

## Agentic Workflow

If you are using coding agents in this repo, the local workflow guidance lives in [AGENTS.md](AGENTS.md).

## dbt Variables

Set Tuva vars under the `vars:` key in your `dbt_project.yml`. Use dbt selectors to run individual marts; the vars below control broad data domains, shared runtime behavior, and the synthetic bootstrap flow used by `integration_tests`.

### Broad Enablement

| Variable | Root Default | `integration_tests` Default | Description |
|----------|--------------|-----------------------------|-------------|
| `claims_enabled` | `false` | `true` | Enable claims-based models. |
| `clinical_enabled` | `false` | `true` | Enable clinical-based models. |
| `provider_attribution_enabled` | `false` | `true` | Enable provider attribution models. Claims input must also be enabled. |
| `semantic_layer_enabled` | `false` | `true` | Enable semantic-layer models. Claims-dependent semantic models also require `claims_enabled`. |
| `fhir_preprocessing_enabled` | `false` | `false` | Enable FHIR preprocessing models. |

### Shared Runtime Configuration

| Variable | Default | Description |
|----------|---------|-------------|
| `tuva_last_run` | Current UTC timestamp | Populates the `tuva_last_run` column in output models. |
| `tuva_schema_prefix` | unset | Prefixes output schemas, for example `myprefix_core`. |
| `cms_hcc_payment_year` | Current year | CMS-HCC payment year used for risk scoring. |
| `quality_measures_period_end` | Current year-end | Optional reporting-period end date for quality measures. |
| `record_type` | `"ip"` | CCSR record type: `"ip"` for inpatient or `"op"` for outpatient. |
| `dxccsr_version` | `"2023.1"` | CCSR diagnosis mapping version. |
| `prccsr_version` | `"2023.1"` | CCSR procedure mapping version. |
| `provider_attribution_as_of_date` | unset | Optional `YYYY-MM-DD` override for provider attribution current-state calculations. |

### Seed And Feature Configuration

| Variable | Default | Description |
|----------|---------|-------------|
| `custom_bucket_name` | `"tuva-public-resources"` | Default bucket for versioned Tuva seed artifacts. |
| `tuva_seed_version` | `"1.0.0"` | Default versioned seed folder used when no per-database override is provided. Leading `v` is optional. |
| `tuva_seed_versions` | `{concept_library: "1.0.1", reference_data: "1.0.0", terminology: "1.1.1", value_sets: "1.0.0", provider_data: "1.0.0", synthetic_data: "1.1.0"}` | Optional per-database version overrides keyed by `concept_library`, `reference_data`, `terminology`, `value_sets`, `provider_data`, or `synthetic_data`. |
| `tuva_seed_buckets` | `{}` | Optional per-database bucket overrides for `concept_library`, `reference_data`, `terminology`, `value_sets`, `provider_data`, or `synthetic_data`. |
| `synthetic_data_size` | `small` in `integration_tests` | Selects the `small` or `large` synthetic input payload when running `integration_tests`. |
| `enable_input_layer_testing` | `true` | Runs DQI checks on the input layer. |
| `enable_legacy_data_quality` | `false` | Builds the legacy pre-DQI data-quality models. |
| `enable_normalize_engine` | `false` | Set to `unmapped` to surface unmapped code models, or `true` to also use custom mappings. |

See the maintained docs reference at [thetuvaproject.com/dbt-variables](https://www.thetuvaproject.com/dbt-variables) for examples and more detail.

## Publishing Versioned Seed Artifacts

Use `scripts/publish-dolthub-seeds` to publish the latest public DoltHub databases to versioned S3 folders.

Required inputs:
- `--version v1.0.0`
- AWS CLI credentials via `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`

Optional inputs:
- `--bucket reference_data=my-bucket`
- `--bucket value_sets=my-other-bucket/prefix`
- `--database terminology`
- `--download-only`

The script publishes to the normalized layout:
- `s3://<bucket>/<database-folder>/<version>/<table>.csv.gz`

## Mirroring Seed Releases To GCS And Azure

Use `scripts/mirror-seed-release` after an S3 publish to copy the same versioned release to GCS and Azure Blob Storage.

Required access:
- AWS CLI access to read `s3://tuva-public-resources`
- `gsutil` access to write `gs://tuva-public-resources`
- Azure `Storage Blob Data Contributor` or equivalent on storage account `tuvapublicresources`, container `tuva-public-resources`

Example:

```bash
scripts/mirror-seed-release --version v1.0.0
```

The script mirrors:
- `s3://tuva-public-resources/<database-folder>/<version>/...`
- `gs://tuva-public-resources/<database-folder>/<version>/...`
- `https://tuvapublicresources.blob.core.windows.net/tuva-public-resources/<database-folder>/<version>/...`

Current published defaults:
- `concept-library` uses `1.0.1`
- `terminology` uses `1.1.1`
- `reference-data`, `value-sets`, `provider-data`, and `synthetic-data` use `1.0.0`
