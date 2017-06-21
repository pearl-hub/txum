#!/bin/sh
set -ex

brew update
brew install bash
# Coreutils and git should be already installed on OSX 7.3+ images:
#brew install coreutils git
