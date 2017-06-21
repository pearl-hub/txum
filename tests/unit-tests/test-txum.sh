#!/usr/bin/env bash
source "$(dirname $0)/../utils/utils.sh"

pearlSetUp
CMD_ROOT=$(dirname $0)/../../
source $CMD_ROOT/bin/txum -h &> /dev/null

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
    assertCommandSuccess cli_wrap help
    cat $STDOUTF | grep -q "txum"
    assertEquals 0 $?
    assertCommandSuccess cli_wrap h
    cat $STDOUTF | grep -q "txum"
    assertEquals 0 $?
}

function test_txum_no_pearl_root_defined(){
    OLD_PEARL_ROOT=$PEARL_ROOT
    unset PEARL_ROOT
    assertCommandFailOnStatus 1 source $CMD_ROOT/bin/txum -h
    PEARL_ROOT=$OLD_PEARL_ROOT
}

function test_txum_no_pearl_root_directory(){
    OLD_PEARL_ROOT=$PEARL_ROOT
    PEARL_ROOT="not-a-directory"
    assertCommandFailOnStatus 2 source $CMD_ROOT/bin/txum -h
    PEARL_ROOT=$OLD_PEARL_ROOT
}

function test_txum_go(){
    assertCommandSuccess cli_wrap go myalias
    assertEquals "$(echo -e "go_command myalias")" "$(cat $STDOUTF)"

    assertCommandSuccess cli_wrap g myalias
    assertEquals "$(echo -e "go_command myalias")" "$(cat $STDOUTF)"
}

function test_check_cli(){
    assertCommandFail cli_wrap
    assertCommandFail cli_wrap -h g myalias
    assertCommandFail cli_wrap g myalias wrong_arg
    assertCommandFail cli_wrap k myalias
}

source $(dirname $0)/../utils/shunit2
