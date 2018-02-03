#!/usr/bin/env bash
PKG_LOCATION="$(dirname $0)/../.."
source "$PKG_LOCATION/tests/bunit/utils/utils.sh"
source "$PKG_LOCATION/tests/test-utils/utils.sh"

pearlSetUp
source $PKG_LOCATION/buava/lib/utils.sh
source "$PKG_LOCATION/lib/core.sh"

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

    # Default bookmark file
    BOOKMARKS_FILE=$PWD/bookmarks
    touch $BOOKMARKS_FILE
}

function tearDown(){
    cwdTearDown
}

function test_go_command_null_alias(){
    assertCommandFailOnStatus 11 go_command
}

function test_go_command_without_bookmark_file(){
    ORIGIN_PATH='original-path'
    BOOKMARKS_FILE='not-exists'
    CWD=$PWD
    tmux_command(){
        echo "tmux $@"
        [[ $PWD == $CWD ]] || return 1
        [[ $PATH == 'original-path' ]] || return 1
    }
    TMUX_CMD=tmux_command
    assertCommandSuccess go_command "myalias"
    assertEquals "tmux new-session -AD -s myalias" "$(cat $STDOUTF)"
}

function test_go_command_no_alias(){
    ORIGIN_PATH='original-path'
    CWD=$PWD
    tmux_command(){
        echo "tmux $@"
        [[ $PWD == $CWD ]] || return 1
        [[ $PATH == 'original-path' ]] || return 1
    }
    TMUX_CMD=tmux_command
    assertCommandSuccess go_command "myalias"
    assertEquals "tmux new-session -AD -s myalias" "$(cat $STDOUTF)"
}

function test_go_command_new_session(){
    ORIGIN_PATH='original-path'
    mkdir mydir
    CWD=$PWD/mydir
    echo "myalias:$CWD" > $BOOKMARKS_FILE
    tmux_command(){
        echo "tmux $@"
        [[ $PWD == $CWD ]] || return 1
        [[ $PATH == 'original-path' ]] || return 1
    }
    TMUX_CMD=tmux_command
    assertCommandSuccess go_command "myalias"
    assertEquals "tmux new-session -AD -s myalias" "$(cat $STDOUTF)"
}

function test_go_command_new_session_in_tmux(){
    ORIGIN_PATH='original-path'
    TMUX='something'
    mkdir mydir
    CWD=$PWD/mydir
    echo "myalias:$CWD" > $BOOKMARKS_FILE
    tmux_command(){
        echo "tmux $@"
        [[ $PWD == $CWD ]] || return 1
        [[ $1 == "has-session" ]] && return 1
        [[ $PATH == 'original-path' ]] || return 1
        return 0
    }
    TMUX_CMD=tmux_command
    assertCommandSuccess go_command "myalias"
    assertEquals "$(echo -e "tmux has-session -t myalias\ntmux new-session -d -s myalias\ntmux switch-client -t myalias")" "$(cat $STDOUTF)"
}

function test_go_command_existing_session_in_tmux(){
    ORIGIN_PATH='original-path'
    TMUX='something'
    mkdir mydir
    CWD=$PWD/mydir
    echo "myalias:$CWD" > $BOOKMARKS_FILE
    tmux_command(){
        echo "tmux $@"
        [[ $PWD == $CWD ]] || return 1
        [[ $1 == "has-session" ]] && return 0
        [[ $PATH == 'original-path' ]] || return 1
        return 0
    }
    TMUX_CMD=tmux_command
    assertCommandSuccess go_command "myalias"
    assertEquals "$(echo -e "tmux has-session -t myalias\ntmux switch-client -t myalias")" "$(cat $STDOUTF)"
}

function test_add_command_null_alias(){
    assertCommandFailOnStatus 11 add_command
}

function test_add_command_wrong_directory(){
    assertCommandFailOnStatus 128 add_command "myalias" "bad-directory"
}

function test_add_command_default_path(){
    assertCommandSuccess add_command "myalias"
    assertEquals "$(cat $BOOKMARKS_FILE)" "myalias:$(readlink -f $PWD)"
}

function test_add_command_relative_path(){
    mkdir $PWD/my-directory
    assertCommandSuccess add_command "myalias" "my-directory"
    assertEquals "$(cat $BOOKMARKS_FILE)" "myalias:$(readlink -f $PWD)/my-directory"
}

function test_add_command_absolute_path(){
    mkdir $PWD/my-directory
    assertCommandSuccess add_command "myalias" "$PWD/my-directory"
    assertEquals "$(cat $BOOKMARKS_FILE)" "myalias:$(readlink -f $PWD)/my-directory"
}

function test_add_command_wrong_alias(){
    assertCommandFailOnStatus 128 add_command "mya%lias"
    assertEquals "$(cat $BOOKMARKS_FILE)" ""
}

function test_add_command_allowed_alias(){
    assertCommandSuccess add_command "my-alias_2"
    assertEquals "$(cat $BOOKMARKS_FILE)" "my-alias_2:$(readlink -f $PWD)"
}

function test_add_command_multiple_same_alias(){
    assertCommandSuccess add_command "myalias"
    assertCommandFailOnStatus 129 add_command "myalias"
    assertEquals "$(cat $BOOKMARKS_FILE)" "myalias:$(readlink -f $PWD)"
}

function test_remove_command_null_alias(){
    assertCommandFailOnStatus 11 remove_command
}

function test_remove_command_wrong_alias(){
    assertCommandFailOnStatus 128 remove_command "mya%lias"
}

function test_remove_command_alias_no_exists(){
    assertCommandFailOnStatus 129 remove_command "myalias"
}

function test_remove_command(){
    echo "myalias:/my/path/to/hell" >> $BOOKMARKS_FILE
    assertCommandSuccess remove_command "myalias"
    assertEquals "" "$(cat $BOOKMARKS_FILE)"
}

function test_remove_command_multiple_same_aliases(){
    echo "myalias:/my/path/to/hell" >> $BOOKMARKS_FILE
    echo "myalias2:/my/path/to/hell" >> $BOOKMARKS_FILE
    echo "myalias:/my/path/to/hell2" >> $BOOKMARKS_FILE
    assertCommandSuccess remove_command "myalias"
    assertEquals "myalias2:/my/path/to/hell" "$(cat $BOOKMARKS_FILE)"
}

function test_remove_command_no_bookmark(){
    BOOKMARKS_FILE='not-exists'
    assertCommandSuccess remove_command "myalias"
    assertEquals "" "$(cat $STDOUTF)"
}

function test_list_command(){
    echo "myalias:/my/path/to/hell" >> $BOOKMARKS_FILE
    assertCommandSuccess list_command
    assertEquals "myalias:/my/path/to/hell" "$(cat $STDOUTF)"
}

function test_list_command_no_bookmark(){
    BOOKMARKS_FILE='not-exists'
    assertCommandSuccess list_command
    assertEquals "" "$(cat $STDOUTF)"
}

source $PKG_LOCATION/tests/bunit/utils/shunit2
