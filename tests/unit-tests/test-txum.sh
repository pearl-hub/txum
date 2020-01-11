#!/usr/bin/env bash

export TXUM_VARDIR=$(dirname $0)

PKG_ROOT="$(dirname $0)/../.."
source "$PKG_ROOT/tests/bunit/utils/utils.sh"
source "$PKG_ROOT/tests/test-utils/utils.sh"

pearlSetUp
source $PKG_ROOT/bin/txum -h &> /dev/null

# Disable the exiterr
set +e

function oneTimeSetUp(){
    setUpUnitTests
}

function oneTimeTearDown(){
    pearlTearDown
}

function setUp(){
    :
}

function tearDown(){
    :
}

function cli_wrap(){
    parse_arguments "$@"
    check_cli
    execute_operation
}

function go_command(){
    echo "go_command $@"
}

function add_command(){
    echo "add_command $@"
}

function remove_command(){
    echo "remove_command $@"
}

function list_command(){
    echo "list_command $@"
}

function test_help(){
    assertCommandSuccess cli_wrap -h
    cat $STDOUTF | grep -q "txum"
    assertEquals 0 $?
    assertCommandSuccess cli_wrap --help
    cat $STDOUTF | grep -q "txum"
    assertEquals 0 $?
    assertCommandSuccess cli_wrap h
    cat $STDOUTF | grep -q "txum"
    assertEquals 0 $?
    assertCommandSuccess cli_wrap help
    cat $STDOUTF | grep -q "txum"
    assertEquals 0 $?
}

function test_txum_go(){
    assertCommandSuccess cli_wrap go myalias
    assertEquals "$(echo -e "go_command myalias")" "$(cat $STDOUTF)"

    assertCommandSuccess cli_wrap g myalias
    assertEquals "$(echo -e "go_command myalias")" "$(cat $STDOUTF)"
}

function test_txum_add(){
    assertCommandSuccess cli_wrap add myalias mypath
    assertEquals "$(echo -e "add_command myalias mypath")" "$(cat $STDOUTF)"

    assertCommandSuccess cli_wrap a myalias mypath
    assertEquals "$(echo -e "add_command myalias mypath")" "$(cat $STDOUTF)"
}

function test_txum_list(){
    assertCommandSuccess cli_wrap list
    assertEquals "$(echo -e "list_command ")" "$(cat $STDOUTF)"

    assertCommandSuccess cli_wrap l
    assertEquals "$(echo -e "list_command ")" "$(cat $STDOUTF)"
}

function test_txum_remove(){
    assertCommandSuccess cli_wrap remove myalias
    assertEquals "$(echo -e "remove_command myalias")" "$(cat $STDOUTF)"

    assertCommandSuccess cli_wrap r myalias
    assertEquals "$(echo -e "remove_command myalias")" "$(cat $STDOUTF)"
}

function test_check_cli(){
    assertCommandFail cli_wrap
    assertCommandFail cli_wrap -h myalias
    assertCommandFail cli_wrap myalias wrong_arg
    assertCommandFail cli_wrap -n myalias
    assertCommandFail cli_wrap r myalias myalias2
    assertCommandFail cli_wrap l myalias myalias2
    assertCommandFail cli_wrap g myalias myalias2
}

source $PKG_ROOT/tests/bunit/utils/shunit2
