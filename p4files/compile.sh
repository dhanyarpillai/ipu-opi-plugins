#! /bin/bash

# Use the value of the environment variable P4INCLUDE, if the user has
# assigned it a value.  Otherwise, use the value of DEFAULT_P4INCLUDE
# from this script.

#DEFAULT_P4INCLUDE=$HOME/networking.ipu.software.p4-compiler.p4c-master/build/idpf-lib
#DEFAULT_P4INCLUDE=/usr/share/p4c/idpf-lib/
DEFAULT_P4INCLUDE=/root/p4c/p4c-307068/share/p4c/idpf-lib/
MY_P4INCLUDE=${P4INCLUDE:-$DEFAULT_P4INCLUDE}

if [ $# -ne 1 ]
then
    1>&2 echo "usage: `basename $0` <p4progname.p4>"
    exit 1
fi

P4PROGNAME="$1"
BASENAME=`basename $P4PROGNAME .p4`
/root/p4c/p4c-307068/bin/p4c-pna-xxp --version
set -x
/root/p4c/p4c-307068/bin/p4c-pna-xxp  \
-I${MY_P4INCLUDE} \
    $P4PROGNAME \
    -o $BASENAME.s \
    --top4 LiveVariableAnalysis \
    --p4runtime-files $BASENAME.p4info.txt \
    --context $BASENAME.context.json \
    --bfrt $BASENAME.bfrt.json 
/root/cpt-3.8.0.8/cpt --npic --device idpf --format csr --pbd -o rh_mvp.pkg cpt_ver.s rh_mvp.s
