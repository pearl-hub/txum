# This module contains all functionalities needed for
# handling the txum core.
#
# Dependencies:
# - $PEARL_ROOT/lib/utils/utils.sh
#
# vim: ft=sh

TMUX_CMD=tmux
BOOKMARKS_FILE="$PEARL_HOME/bookmarks"

function go_command(){
    local alias="$1"
    check_not_null $alias

    local dir=""
    [[ -f $BOOKMARKS_FILE ]] && dir="$(grep "^${alias}:.*" $BOOKMARKS_FILE | cut -d: -f2)"
    [ "$dir" == "" ] && local dir="$PWD"

    builtin cd "$dir"
    # Manages the creation of internal session differently
    if [[ -z $TMUX ]]
    then
        $TMUX_CMD new-session -AD -s "${alias}"
    else
        if ! $TMUX_CMD has-session -t "${alias}"
        then
            $TMUX_CMD new-session -d -s "${alias}"
        fi
        $TMUX_CMD switch-client -t "${alias}"
    fi
    builtin cd "$OLDPWD"
    return 0
}
