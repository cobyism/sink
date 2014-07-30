# Sink

Auto-sync for your GitHub repos.

## Setup

1. `gem install sink`
2. Generate a new [personal access token](https://github.com/settings/applications), and copy it to your clipboard.
3. Stick your token into `~/.sinkconfig` in the form of `GITHUB_TOKEN=<paste your token>` (replace everything after the equals sign).

## Usage

```
cd path/to/repo
sink
```

Any changes you make locally while `sink` is running will be committed and pushed,
and any changes made on the remote repository will be pulled down too.

## Todo

- [ ] loltests!

## License

[MIT](./LICENSE). Go nuts.
