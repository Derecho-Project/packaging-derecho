#!/bin/bash

tmpdir_full=""
function cleanup {
    if [[ -d $tmpdir_full ]]; then 
	echo "Removing $tmpdir_full"
	#rm  -r /tmp/foo
    fi
}

trap cleanup EXIT

function ensure_dir_correct {
    if [[ -d debian && -d work && `ls | wc -w` -eq 2 ]]; then
	echo "Working directory `pwd` detected as compliant"
	local current_dir_name=`pwd | rev | cut -d/  -f1 | rev`
	if echo $current_dir_name | grep -q packaging-; then
	    local project_name=`echo $current_dir_name | sed s/"packaging-"//g`
	    if [[ `echo work/$project_name*/ | wc -w` -eq 1 ]]; then
		original_dir_full=`pwd`
		current_dir_name=`pwd | rev | cut -d/  -f1 | rev`
		project_name=`echo $current_dir_name | sed s/"packaging-"//g`
		package_dir_relative=`echo work/$project_name*/ | sed s/work// | tr -d /`
		debian_dir_full=`pwd`/debian
		workdir_full=`pwd`/work
		return 0
	    else
		echo "Error: more than one directory in this package's work directory.  Candidates are: `echo $project_name*/`"
	    fi
	else
	    echo 'Error: directory does not follow "package-FOO" name format'
	fi
    else
	echo "Error: ill-formatted working directory.  Cannot find debian and work directories, or extra items present.  Remove the .deb file, probably."
    fi
    return 1
}

function enter_tmpdir {
    tmpdir_full=`mktemp -p /gentoo/tmp/ -d`
    cd $tmpdir_full
    echo $tmpdir_full
}
