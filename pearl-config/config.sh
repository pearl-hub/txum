export TXUM_VARDIR="$PEARL_PKGVARDIR"


if [[ $PATH != *"${TXUM_VARDIR}/bin"* ]]
then
    export PATH="$PATH:$TXUM_VARDIR/bin"
fi
