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

`txum` command relies heavily in the `$PEARL_HOME/bookmarks` file
for identifying the user favourite directories.
The content of such file contains each line with the alias
and the corresponding directory separated by `:`. For instance:

    myalias:/home/myuser/myproject

- To create a Tmux session in the directory specified by `myalias`:

```sh
$ txum myalias
```

In case the Tmux session already exists, the previous command
will move to the existing session instead.
Moreover, `txum` will also work in case it gets executed
inside an existing Tmux session.

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

Troubleshooting
===============
This section has been left blank intentionally.
It will be filled up as soon as troubles come in!

