#!/bin/bash

txum help

txum list

mkdir -p $HOME/new-project
txum add myalias $HOME/new-project

txum list

txum remove myalias

