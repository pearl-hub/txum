unset PEARL_ROOT PEARL_HOME

function pearlSetUp(){
    pearlRootSetUp
    pearlHomeSetUp
}

function pearlTearDown(){
    pearlRootTearDown
    pearlHomeTearDown
}

function pearlHomeSetUp(){
    HOME=$(TMPDIR=/tmp mktemp -d -t pearl-user-home.XXXXXXX)
    mkdir -p $HOME
    export PEARL_HOME=${HOME}/.config/pearl
    mkdir -p $PEARL_HOME
    mkdir -p $PEARL_HOME/bin
    mkdir -p $PEARL_HOME/etc
    touch $PEARL_HOME/etc/pearl.conf
    mkdir -p $PEARL_HOME/repos
    mkdir -p $PEARL_HOME/packages
    mkdir -p $PEARL_HOME/tmp
}

function pearlHomeTearDown(){
    rm -rf $PEARL_HOME
    rm -rf $HOME
    unset PEARL_HOME
}

# The Pearl setup is useful when the package requires
# library dependencies such as $PEARL_ROOT/lib/utils/utils.sh
function pearlRootSetUp() {
    export PEARL_ROOT=$(TMPDIR=/tmp mktemp -d -t pearl-test-root.XXXXXXX)
}

function pearlRootTearDown(){
    rm -rf $PEARL_ROOT
    unset PEARL_ROOT
}

OLD_CWD=${PWD}
function cwdSetUp(){
    ORIGIN_CWD=$(TMPDIR=/tmp mktemp -d -t junest-cwd.XXXXXXXXXX)
    cd $ORIGIN_CWD
}

function cwdTearDown(){
    cd $OLD_CWD
    rm -rf $ORIGIN_CWD
}

function setUpUnitTests(){
    OUTPUT_DIR="${SHUNIT_TMPDIR}/output"
    mkdir "${OUTPUT_DIR}"
    STDOUTF="${OUTPUT_DIR}/stdout"
    STDERRF="${OUTPUT_DIR}/stderr"
}

function assertCommandSuccess(){
    $(set -e
      "$@" > $STDOUTF 2> $STDERRF
    )
    assertTrue "The command $1 did not return 0 exit status" $?
}

function assertCommandFail(){
    $(set -e
      "$@" > $STDOUTF 2> $STDERRF
    )
    assertFalse "The command $1 returned 0 exit status" $?
}

# $1: expected exit status
# $2-: The command under test
function assertCommandFailOnStatus(){
    local status=$1
    shift
    $(set -e
      "$@" > $STDOUTF 2> $STDERRF
    )
    assertEquals $status $?
}
