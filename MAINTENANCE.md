# Site maintenance

The editable website source lives on `master`. GitHub Actions builds that source and publishes the generated site to `gh-pages`. Never edit `gh-pages` directly.

## Update content

- Homepage biography: `_pages/about.md`
- News: `_news/*.md`
- Publications: `_bibliography/papers.bib`
- Publication previews: `assets/img/publication_preview/`
- Site metadata and features: `_config.yml`
- Styling: `_sass/*.scss` and `assets/css/`

For a homepage publication, add `selected={true}` to its BibTeX entry. Store its `preview` image in `assets/img/publication_preview/`.

## Preview locally

Docker is the supported local preview path:

```bash
docker compose pull
docker compose up
```

Open `http://localhost:8080`. Content changes live-reload. Changes to `_config.yml` restart Jekyll automatically.

## Validate changes

After the required dependencies are installed, run:

```bash
git diff --check
PATH="/opt/homebrew/bin:$PATH" npm exec -- prettier . --check
docker compose run --rm jekyll bundle exec jekyll build
pre-commit run --all-files
```

The generated `_site/` directory is ignored by Git.

## Commit and deploy

Review and stage only the intended files:

```bash
git status --short
git diff
git add <specific-files>
git commit -m "[area] short lower-case summary"
git push origin master
```

After pushing, verify these GitHub Actions checks:

1. `Prettier code formatter`
2. `Check for broken links`
3. `Deploy site`
4. `Check for broken links on site`

The Lighthouse workflow is manual and requires the `LIGHTHOUSE_BADGER_TOKEN` repository secret.

For a manual redeploy, run `Deploy site` from the GitHub Actions page. Do not use `bin/deploy` for routine updates because it force-pushes the generated `gh-pages` branch.
