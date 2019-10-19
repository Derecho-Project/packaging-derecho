#!/bin/bash

set -eu

#check if we're in the right working directory

#skip_debuild=$1

(
    set -eu
  
    source make_package_common.sh

    if [[ $# -gt 0 ]]; then cd $1; fi 

    ensure_dir_correct
    if [[ $? -eq 0 ]]; then
	enter_tmpdir
	cp -rfp $workdir_full/* $tmpdir_full
	if [[ -e $tweaks_full ]]; then
	    (
		cd $tmpdir_full/$package_dir_relative;
		$tweaks_full $package_dir_relative $tmpdir_full
	    )
	fi
	tar -czf "$package_dir_relative".tar.gz $package_dir_relative
	cd $package_dir_relative
	debmake
	yes | cp -r $debian_dir_full/* debian/
	if [[ $# -ge 2 ]]; then
	    echo "Skipping debuild...."
	else
	    echo "About to run debuild!"
	    debuild
	    cp ../*.deb $original_dir_full
	fi
	exit 0
    else
	exit 1
    fi
    
)

exit $?
