#!/bin/bash -eux

#Requires:
#hg-fast-export.sh from https://github.com/frej/fast-export on your $PATH
#Hg
#Enabled hg convert extension see https://mercurial.selenic.com/wiki/ConvertExtension
#Git

#Horribly insecure shit because RhodeCode sucks.
echo "machine sourcecontrol.corp.ttc login jenkins.user password j3nk!ns" > /root/.netrc
#Horribly insecure shit because I am lazy.
echo "machine github.com login $1 password $2" > /root/.netrc

root_dir=/root
tropics_origin=https://github.com/travcorp/tropics.git
tropics_graft_sha=d29c9ad01f5869b3edf5e4b432cfb0fc17e50c9f
tropics_clone_dir="${root_dir}/tropics"
itropics_origin=https://sourcecontrol.corp.ttc/iTropics/iTROPICS-TRUNK
itropics_convert_sha=7772bb88265f
#itropics_release_sha=
#itropics_master_sha=
itropics_clone_dir="${root_dir}/itropics-hg"
itropics_sub_dir="${root_dir}/itropics-sub"
itropics_git_dir="${root_dir}/itropics-git"
monorepo_dir="${root_dir}/tropics-itropics"

#Clone itropics hg repo from origin
rm -rf ${itropics_clone_dir}
hg clone ${itropics_origin} ${itropics_clone_dir}

#Removing subrepos AAARRRGGGHHH!
> ${itropics_clone_dir}/.hgsub
rm -rf ${itropics_clone_dir}/config/parameters/DevOps_Dev_Environment
rm -rf ${itropics_clone_dir}/config/parameters/DevOps_QA_Environment

#Truncate repo history with hg convert
rm -rf ${itropics_sub_dir}
hg --config convert.hg.startrev=${itropics_convert_sha} convert ${itropics_clone_dir} ${itropics_sub_dir}

#create new itropics git repo folder and initialize
rm -rf ${itropics_git_dir}
mkdir ${itropics_git_dir} && cd ${itropics_git_dir} && git init

#Convert itropics hg repo to git
hg-fast-export.sh -r ${itropics_sub_dir} --force && cd -

#Clone tropics repo from origin
rm -rf ${tropics_clone_dir}
git clone ${tropics_origin} ${tropics_clone_dir}

#echo repo size
echo -e "${tropics_clone_dir} size is $(du -khs ${tropics_clone_dir})"

#Delete all branches except master and develop and trash remote.
cd ${tropics_clone_dir} && git branch -D $(git branch | grep -Ev 'develop|master') && git remote rm origin

#Add graft SHA for git-filter-branch to truncate history
echo ${tropics_graft_sha} > .git/info/grafts

#Run filter-branch on all branches using graft
git filter-branch -- --all

#Remove filter-branch backups
git update-ref -d refs/original/refs/heads/master && git update-ref -d refs/original/refs/heads/develop && git update-ref -d refs/original/refs/heads/release

#Clean up old files
git reflog expire --expire=now --all && git gc --prune=now --aggressive

#echo repo size again
echo -e "${tropics_clone_dir} size is $(du -khs ${tropics_clone_dir})"









#Poor attempt at security.
rm -f /root/.netrc
