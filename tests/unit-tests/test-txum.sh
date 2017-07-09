#!/usr/bin/env bash
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

function test_help(){
    assertCommandSuccess cli_wrap -h
    cat $STDOUTF | grep -q "txum"
    assertEquals 0 $?
    assertCommandSuccess cli_wrap --help
    cat $STDOUTF | grep -q "txum"
    assertEquals 0 $?
}

function test_txum_go(){
    assertCommandSuccess cli_wrap myalias
    assertEquals "$(echo -e "go_command myalias")" "$(cat $STDOUTF)"
}

function test_check_cli(){
    assertCommandFail cli_wrap
    assertCommandFail cli_wrap -h myalias
    assertCommandFail cli_wrap myalias wrong_arg
    assertCommandFail cli_wrap -n myalias
}

source $PKG_ROOT/tests/bunit/utils/shunit2
