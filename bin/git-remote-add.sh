#!/bin/bash

function errExit {
    echo "ERROR: $@" >&1
    exit 1
}

enable_stubs=false

function stub {
    if ! $enable_stubs; then
        return
    fi
    # Prefer fd 9 for stubs:
    if { true >&9; } &> /dev/null; then
        echo "stub:[$@]" >&9
    else
        echo "stub:[$@]" >&2
    fi
}

function do_interactive {
    # Get the list of current remotes as prototypes:
    git remote -v | cat -n
    read -p "Select existing remote as prototype (1)"

}

function dispatch_args {
    if [[ -z $1 ]]; then
        do_interactive
        return
    fi
    while [[ -z $1 ]]; do
        case $1 in
            *)
                errExit "Unknown arg: $1"
               ;;
        esac
        shift
    done
}

if [[ -z $sourceMe ]]; then
    dispatch_args "$@"
fi
