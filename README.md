# Sink

Auto-sync your GitHub repos to local folders.

Here’s `sink` syncing two folders both linked to the same git remote.

![gh-sync](https://cloud.githubusercontent.com/assets/296432/3754176/adedbaa2-1818-11e4-91e8-8ddd6b988bd4.gif)

In the above illustration, `sink` is watching both folders via the command line:

![gh-sync](https://cloud.githubusercontent.com/assets/296432/3754334/0f60f7e4-181a-11e4-8bfd-9b727ec79864.png)

It’s up to you to imagine they’re on two different computers.

## Install

`gem install sink`

## Setup

1. Generate a new [personal access token](https://github.com/settings/applications).
2. Copy it to your clipboard.
3. Create a file at `~/.sinkconfig` with the contents `GITHUB_TOKEN=…` (put your token after the equals).

## Usage

```
cd path/to/repo
sink
```

Any changes you make locally while `sink` is running will be committed and pushed,
and any changes made on the remote repository will be pulled down too.

## Todo

- [ ] tests :laughing:
- [ ] make it way more performant, rather than just sitting there polling (use guard?), also consider multi-threading stuff.
- [ ] rework so the `sink` command checks a config file for a list of folders to watch,
  so you can run it once from wherever instead of having to run a `sink` instance in each folder.
- [ ] add support for pausing and resuming syncing on a per folder basis.
- [ ] give this a UI somehow (or just use [SparkleShare](http://sparkleshare.org/) instead?).
- [ ] add support for branching and PRs.

## Contributing

I’d :heart: to receive contributions to this project. It doesn’t matter if it’s just a typo, or if you’re proposing an overhaul of the entire project—I’ll gladly take a look at your changes. Fork at will! :grinning:

## License

[MIT](./LICENSE). Go nuts.
