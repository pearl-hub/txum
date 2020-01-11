set -x TXUM_VARDIR $PEARL_PKGVARDIR

if not contains $TXUM_VARDIR/bin $PATH
    set -x PATH $PATH $TXUM_VARDIR/bin
end

# vim: ft=sh
