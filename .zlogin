# .zlogin используется в оболочках для входа в систему.
# Он должен содержать команды, которые
# должны выполняться только в оболочках входа в систему.

# Проверка входящих ftp-файлов.
# if [[ $(uname -n) = vaio ]]
# then
	INCOMING=/var/ftp/files
	if [[ -d ${INCOMING} ]]
	then
		pushd ${INCOMING}
		newfiles=()
		[[ -a .timestamp ]] || sudo touch .timestamp
		setopt nullglob
		for file in ^.timestamp
			[[ $file -nt .timestamp ]] && newfiles=( $newfiles $file )
			if [[ -n $newfiles ]]
			then
				echo "New files in ${INCOMING}:"
				print -l "  "$newfiles
				echo ""
			fi
			sudo touch .timestamp
			popd
	fi
# fi
