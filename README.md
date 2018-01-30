TXUM
====

|Project Status|Communication|
|:-----------:|:-----------:|
|[![Build status](https://api.travis-ci.org/pearl-hub/txum.png?branch=master)](https://travis-ci.org/pearl-hub/txum) | [![Join the gitter chat at https://gitter.im/pearl-core/pearl](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/pearl-core/pearl?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge) |

**Table of Contents**
- [Description](#description)
- [Quickstart](#quickstart)
- [Installation](#installation)
- [Troubleshooting](#troubleshooting)

Description
===========

- name: `txum`
- description: A wrapper that enhances Tmux capabilities.
- author: Filippo Squillace
- username: fsquillace
- OS compatibility: linux, osx

Quickstart
==========

Add a new alias with `txum`:

```sh
$ txum add myproject /path/to/your/project
```

List all available aliases:

```sh
$ txum list
myproject:/path/to/your/project
```

The following will create a `tmux` session with `/path/to/your/project` as
current working directory. If the session already exists the following will just
attach to that session:

```sh
$ txum go myproject
```

Remove the previous alias:

```sh
$ txum remove myproject
```

The bookmarks are stored in `$PEARL_HOME/bookmarks` file.
The content of such file contains each line with the alias
and the corresponding directory separated by `:`. For instance:

    myalias:/home/myuser/myproject

`txum` can be also executed inside any other existing `tmux` session.

Installation
============
This package needs to be installed via [Pearl](https://github.com/pearl-core/pearl) system.

```sh
pearl install txum
```

Dependencies
------------
The main dependencies are the following:

- [Pearl](https://github.com/pearl-core/pearl)
- [GNU coreutils](https://www.gnu.org/software/coreutils/)
- [grep](https://www.gnu.org/software/grep/)

Troubleshooting
===============
This section has been left blank intentionally.
It will be filled up as soon as troubles come in!

