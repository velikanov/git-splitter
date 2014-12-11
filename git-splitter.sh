if [ -e $4 ]; then
	echo 'Git Splitter tool - split your repository in subrepositories easily'
	echo 'Usage:'
	echo './git-splitter.sh <repository_directory> <directory_with_splits> <git_repositories_wildcard> <subrepositories_suffix>'
	echo 'example: ./git-splitter.sh ~/www/Orkestro src/Orkestro git@github.com:Orkestro Bundle'

	exit
fi

repository_directory=$1
directory_with_splits=$2
git_repositories_wildcard=$3
subrepositories_suffix=$4

cd $repository_directory

for full_subrepository_dir in ${repository_directory}/${directory_with_splits}/*${subrepositories_suffix}
do
	subrepository_name=`basename ${full_subrepository_dir} ${subrepositories_suffix}`
	subrepository_remote_name=`echo "${subrepository_name}-${subrepositories_suffix}" | awk '{print tolower($0)}'`
	subrepository_name=${subrepository_name}${subrepositories_suffix}

	echo "Processing ${subrepository_name}"
	echo ""

	directory_for_split=${directory_with_splits}/${subrepository_name}

	git filter-branch -f --prune-empty --subdirectory-filter ${directory_for_split} master
	git remote add -f ${subrepository_remote_name} ${git_repositories_wildcard}/${subrepository_name}
	git push ${subrepository_remote_name} master
	git reset --hard refs/original/refs/heads/master
done