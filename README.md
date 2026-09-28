# Ng-life Personal

## How do I install these formulae?

`brew install ng-life/personal/<formula>`

Or `brew tap ng-life/personal` and then `brew install <formula>`.

## ZooKeeper Explorer

Install the web-based ZooKeeper browser and its default configuration:

```sh
brew install ng-life/personal/zookeeper-explorer
```

Add ZooKeeper clusters to `$(brew --prefix)/etc/zookeeper-explorer.toml`, then manage the app with:

```sh
brew services start ng-life/personal/zookeeper-explorer
brew services restart ng-life/personal/zookeeper-explorer
brew services stop ng-life/personal/zookeeper-explorer
```

By default, the web UI listens on `127.0.0.1:8080`, and recursive deletion is disabled.

## Documentation

`brew help`, `man brew` or check [Homebrew's documentation](https://docs.brew.sh).
