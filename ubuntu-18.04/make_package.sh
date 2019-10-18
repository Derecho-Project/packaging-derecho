#!/bin/bash

set -eu

#check if we're in the right working directory



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
	debuild
	cp ../*.deb $original_dir_full
	exit 0
    else
	exit 1
    fi
    
)

exit $?
