# This module contains all functionalities needed for
# handling the txum core.
#
# Dependencies:
# - [buava] $PKG_ROOT/buava/lib/utils.sh
#
# vim: ft=sh

CAT_CMD=cat
TMUX_CMD=tmux
GREP_CMD=grep
BOOKMARKS_FILE="$PEARL_HOME/bookmarks"


#######################################
# Open/Go to the tmux session stored in bookmark.
#
# Globals:
#   BOOKMARKS_FILE (RO)  : The bookmarks file.
#   TMUX_CMD (RO)        : The tmux command.
#   GREP_CMD (RO)        : The grep command.
#   ORIGIN_PATH (RO)     : Original PATH.
# Arguments:
#   alias ($1)           : The alias session.
# Returns:
#   None
# Output:
#   None
#######################################
function go_command(){
    local alias="$1"
    check_not_null $alias

    local dir=""
    [[ -f $BOOKMARKS_FILE ]] && dir="$($GREP_CMD "^${alias}:.*" $BOOKMARKS_FILE | cut -d: -f2)"
    [ "$dir" == "" ] && local dir="$PWD"

    builtin cd "$dir"
    # Manages the creation of internal session differently
    # To avoid polluting the PATH, revert to the original PATH
    PATH=$ORIGIN_PATH
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


#######################################
# Add a bookmark.
#
# Globals:
#   BOOKMARKS_FILE (RO)  : The bookmarks file.
# Arguments:
#   alias ($1)           : The alias session.
#                          Allowed chars: lowercase alphanumeric, "-" and "_".
#   path ($2?)           : The bookmark path (defaults to current path).
#                          Can be either an absolute or relative path.
# Returns:
#   128                  : If either alias or path are wrong.
#   129                  : Alias already exists.
# Output:
#   None
#######################################
function add_command(){
    local alias="$1"
    _check_alias $alias
    _check_alias_exists $alias && \
        die_on_status 129 "The alias ${alias} already exists."

    local path=$(readlink -f "${2:-${PWD}}")
    [[ -d "$path" ]] || die_on_status 128 "$path is not a directory."

    echo "$alias:$path" >> "$BOOKMARKS_FILE"
}


#######################################
# Remove a bookmark.
#
# Globals:
#   BOOKMARKS_FILE (RO)  : The bookmarks file.
# Arguments:
#   alias ($1)           : The alias session.
#                          Allowed chars: lowercase alphanumeric, "-" and "_".
# Returns:
#   128                  : If either alias is wrong.
#   129                  : Alias does not exist.
# Output:
#   None
#######################################
function remove_command(){
    local alias="$1"
    _check_alias $alias

    [[ ! -f $BOOKMARKS_FILE ]] && return

    _check_alias_exists $alias || \
        die_on_status 129 "The alias ${alias} does not exist."

    local new_bookmark=$($GREP_CMD -x -v "^${alias}:.*" $BOOKMARKS_FILE)
    echo -e "$new_bookmark" > $BOOKMARKS_FILE
}


function _check_alias(){
    local alias="$1"
    check_not_null $alias
    [[ $alias =~ ^[a-z0-9_-]*$ ]] || die_on_status 128 "The alias $alias is wrong. Allowed chars: lowercase alphanumeric, '-' and '_'."
}


function _check_alias_exists(){
    [[ ! -f $BOOKMARKS_FILE ]] && return 1

    local alias="$1"
    $GREP_CMD -q "^${alias}:.*" $BOOKMARKS_FILE
}


#######################################
# List all aliases.
#
# Globals:
#   BOOKMARKS_FILE (RO)  : The bookmarks file.
# Arguments:
#   None
# Returns:
#   None
# Output:
#   The list of aliases with the corresponding paths.
#######################################
function list_command(){
    [[ ! -f $BOOKMARKS_FILE ]] && return

    $CAT_CMD $BOOKMARKS_FILE
}
