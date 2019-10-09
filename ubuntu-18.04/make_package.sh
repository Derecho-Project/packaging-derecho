#!/bin/bash

set -eu

#check if we're in the right working directory



(
    set -eu
    tmpdir=""
    
    function cleanup {
	if [[ -d $tmpdir ]]; then 
	    echo "Removing $tmpdir"
	    #rm  -r /tmp/foo
	fi
    }
    
    trap cleanup EXIT

    if [[ $# -gt 0 ]]; then cd $1; fi 

    if [[ -d debian && -d work && `ls | wc -w` -eq 2 ]]; then
	echo "Working directory `pwd` detected as compliant"
	original_dir=`pwd`
	current_dir_name=`pwd | rev | cut -d/  -f1 | rev`
	if echo $current_dir_name | grep -q packaging-; then
	    project_name=`echo $current_dir_name | sed s/"packaging-"//g`
	    debian_dir=`pwd`/debian
	    tmpdir=`mktemp -d`
	    cp -rfp work/* $tmpdir
	 cd $tmpdir
	 if [[ `echo $project_name*/ | wc -w` -eq 1 ]]; then 
	     package_dir=`echo $project_name*/ | tr -d /`
	     tar -czf "$package_dir".tar.gz $package_dir
	     cd $package_dir
	     debmake
	     yes | cp -r $debian_dir/* debian/
	     debuild
	     cp ../*.deb $original_dir
	     exit 0
	 else
	     echo "Error: more than one directory in this package's work directory.  Candidates are: `echo $project_name*/`"
	 fi
	else
	    echo 'Error: directory does not follow "package-FOO" name format'
	fi
    else
	echo "Error: ill-formatted working directory.  Cannot find debian and work directories, or extra items present.  Remove the .deb file, probably."
    fi

    exit 1
)

exit $?
