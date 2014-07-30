# Sink

Auto-sync your GitHub repos to local folders.

## Install

`gem install sink`

## Setup

1. Generate a new [personal access token](https://github.com/settings/applications).
2. Copy it to your clipboard.
3. Create a file at `~/.sinkconfig` and  `GITHUB_TOKEN=<paste your token>` (replace everything after the equals sign).

## Usage

```
cd path/to/repo
sink
```

Any changes you make locally while `sink` is running will be committed and pushed,
and any changes made on the remote repository will be pulled down too.

## Todo

- [ ] tests :laughing:
- [ ] make it way more performant, rather than just sitting there polling (use guard for local changes? use webhook for remote?).
- [ ] rework so the `sink` command checks a config file for a list of folders to watch,
  so you can run it once from wherever instead of having to run a `sink` instance in each folder.
- [ ] add support for pausing and resuming syncing on a per folder basis.
- [ ] give this a UI somehow.
- [ ] add support for branching and PRs.

## License

[MIT](./LICENSE). Go nuts.
