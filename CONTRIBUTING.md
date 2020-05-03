# Contributing

Contributions are very welcome. Please follow the below guidelines when opening an issue or pull request.

## Format with shfmt

This repo uses [mvdan/sh/shfmt](https://github.com/mvdan/sh#shfmt) for shell script formatting. 

### Install

```shell
sudo snap install shfmt
```

### Use

When you're in the repo, execute 

```shell
shfmt -w .
```

to format all shell scripts in place.