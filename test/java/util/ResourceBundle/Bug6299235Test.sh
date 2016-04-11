#!/bin/sh
# Copyright (c) 2007, 2013, Oracle and/or its affiliates. All rights reserved.
# DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS FILE HEADER.
#
# This code is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License version 2 only, as
# published by the Free Software Foundation.
#
# This code is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
# FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
# version 2 for more details (a copy is included in the LICENSE file that
# accompanied this code).
#
# You should have received a copy of the GNU General Public License version
# 2 along with this work; if not, write to the Free Software Foundation,
# Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA.
#
# Please contact Oracle, 500 Oracle Parkway, Redwood Shores, CA 94065 USA
# or visit www.oracle.com if you need additional information or have any
# questions.
#
#!/bin/sh
#
# @test
# @bug 6299235
# @summary test Bug 6299235 to make sure the third-party provided sun resources could be picked up.
# @build Bug6299235Test
# @run shell Bug6299235Test.sh

# set platform-dependent variables
OS=`uname -s`
case "$OS" in
  SunOS | Linux | Darwin | AIX )
    PATHSEP=":"
    FILESEP="/"
    ;;
  Windows* | CYGWIN* )
    PATHSEP=";"
    FILESEP="\\"
    ;;
  * )
    echo "${OS} is unrecognized system!"
    exit 1;
    ;;
esac

if [ -z "${TESTSRC}" ]; then
  echo "TESTSRC undefined: defaulting to ."
  TESTSRC=.
fi

if [ -z "${TESTJAVA}" ]; then
  echo "TESTJAVA undefined: can't continue."
  exit 1
fi

echo "TESTJAVA=${TESTJAVA}"
echo "TESTSRC=${TESTSRC}"
echo "TESTCLASSES=${TESTCLASSES}"

PATCHDIR=${TESTCLASSES}/patches
rm -rf $PATCHDIR
mkdir -p $PATCHDIR/java.desktop

cd ${PATCHDIR}/java.desktop
${TESTJAVA}/bin/jar xf ${TESTSRC}/awtres.jar

echo 
${TESTJAVA}/bin/java ${TESTVMOPTS} -Xpatch:java.desktop=${PATCHDIR}/java.desktop \
     -cp ${TESTCLASSES} Bug6299235Test

if [ $? -ne 0 ]
    then
      echo "Test fails: exception thrown!"
      exit 1
fi

exit 0
