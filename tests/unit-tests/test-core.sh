#!/usr/bin/env bash
source "$(dirname $0)/../utils/utils.sh"

pearlSetUp
source $PEARL_ROOT/lib/utils/utils.sh
source "$(dirname $0)/../../lib/core.sh"

# Disable the exiterr
set +e

function oneTimeSetUp(){
    setUpUnitTests
}

function oneTimeTearDown(){
    pearlTearDown
}

function setUp(){
    cwdSetUp

    # Suppose we are not in a tmux session as default
    TMUX=
}

function tearDown(){
    cwdTearDown
}

function test_go_command_null_alias(){
    assertCommandFailOnStatus 11 go_command
}

function test_go_command_without_bookmark_file(){
    BOOKMARKS_FILE='not-exists'
    CWD=$PWD
    tmux_command(){
        echo "tmux $@"
        [[ $PWD == $CWD ]] || return 1
    }
    TMUX_CMD=tmux_command
    assertCommandSuccess go_command "myalias"
    assertEquals "tmux new-session -AD -s myalias" "$(cat $STDOUTF)"
}

function test_go_command_no_alias(){
    echo "" > $BOOKMARKS_FILE
    CWD=$PWD
    tmux_command(){
        echo "tmux $@"
        [[ $PWD == $CWD ]] || return 1
    }
    TMUX_CMD=tmux_command
    assertCommandSuccess go_command "myalias"
    assertEquals "tmux new-session -AD -s myalias" "$(cat $STDOUTF)"
}

function test_go_command_new_session(){
    mkdir mydir
    CWD=$PWD/mydir
    echo "myalias:$CWD" > $BOOKMARKS_FILE
    tmux_command(){
        echo "tmux $@"
        [[ $PWD == $CWD ]] || return 1
    }
    TMUX_CMD=tmux_command
    assertCommandSuccess go_command "myalias"
    assertEquals "tmux new-session -AD -s myalias" "$(cat $STDOUTF)"
}

function test_go_command_new_session_in_tmux(){
    TMUX='something'
    mkdir mydir
    CWD=$PWD/mydir
    echo "myalias:$CWD" > $BOOKMARKS_FILE
    tmux_command(){
        echo "tmux $@"
        [[ $PWD == $CWD ]] || return 1
        [[ $1 == "has-session" ]] && return 1
        return 0
    }
    TMUX_CMD=tmux_command
    assertCommandSuccess go_command "myalias"
    assertEquals "$(echo -e "tmux has-session -t myalias\ntmux new-session -d -s myalias\ntmux switch-client -t myalias")" "$(cat $STDOUTF)"
}

function test_go_command_existing_session_in_tmux(){
    TMUX='something'
    mkdir mydir
    CWD=$PWD/mydir
    echo "myalias:$CWD" > $BOOKMARKS_FILE
    tmux_command(){
        echo "tmux $@"
        [[ $PWD == $CWD ]] || return 1
        [[ $1 == "has-session" ]] && return 0
        return 0
    }
    TMUX_CMD=tmux_command
    assertCommandSuccess go_command "myalias"
    assertEquals "$(echo -e "tmux has-session -t myalias\ntmux switch-client -t myalias")" "$(cat $STDOUTF)"
}

source $(dirname $0)/../utils/shunit2
