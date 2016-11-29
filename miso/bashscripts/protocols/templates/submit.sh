#!/bin/bash

#
# Bash sanity.
#
set -e
set -u

#
# Global variables declared in MOLGENIS Compute script templates
# always start with a MC_ prefix.
#
declare MC_jobID='' # To keep track of IDs of submitted jobs.
declare MC_submittedJobIDs='molgenis.submitted.log'
declare MC_jobDependenciesExist=false
declare MC_jobDependencies=''
#
# Get commandline arguments.
# Any arguments specified are assumed to be sbatch options 
# and passed on to sbatch unparsed "as is"...
# You can for example specify a Quality of Service (QoS) level using
#     bash submit.sh --qos=SomeLevel
# if you don't want to use the default QoS.
#
MC_sbatchOptions="${@}"

#declare bamFileOne=$1
#declare bamOneBaseFile=${bamFileOne##*/}
#declare bamOneBasename=${bamOneBaseFile%.sorted.merged.dedup.bam}

#
##
### Functions.
##
#

function cancelJobs () {
	local jobList=${1}
	local jobName
	local jobID
	echo 'INFO: Found list of previously submitted jobs in:'
	echo "          ${jobList}"
	echo '      Will try to cancel those jobs before re-submitting new ones...'
	while IFS=':' read -r jobName jobID; do
		echo -n "INFO: Cancelling job ${jobName} (${jobID})... "
		set +e
		scancel -Q "${jobID}"
		local status=${?}
		set -e
		if [ ${status} = 0 ]; then
			echo 'done'
		else
			echo 'FAILED'
			exit 1
		fi
	done < "${jobList}"
	rm "${jobList}"
}

function processJob () {
	local jobName="${1}"
	local jobScript="${jobName}.sh"
	local sbatchOptions="${2:-}" # Optional.
	local dependencies="${3:-}"  # Optional.
	local bamFile="${4:-}"	#optional
	local bamTwo="${5:-}"	#optional
	local n=1
	local max=5
	local delay=15
	local output=''
	#
	# Skip this job if it already finished successfully.
	#
	if [ -f ${jobName}.sh.finished ]; then
		echo "INFO: Skipped ${jobScript}"
		echo "0: Skipped --- TASK ${jobScript} --- ON $(date +"%Y-%m-%d %T")" >> molgenis.skipped.log
		MC_jobID=''
		return
	fi
	
	#
	# Submit job to batch scheduler.
	#
	set +e
	while (true); do
		local sbatchCommand="sbatch ${dependencies} ${jobScript} ${bamFile} ${bamTwo}"
		echo "INFO: Trying to submit batch job:"
		echo "          ${sbatchCommand}"
		output=$(${sbatchCommand} 2>&1)
		if [[ ${?} -eq 0 ]]; then
			echo "      ${output}"
			MC_jobID=${output##"Submitted batch job "}
			echo "${jobName}:${MC_jobID}" >> ${MC_submittedJobIDs}
			break
		else
			if [[ $n -lt ${max} ]]; then
				echo "ERROR: Attempt ${n}/${max} failed for command:"
				echo "           ${sbatchCommand}"
				echo "      ${output}"
				echo "WARN: Sleeping for ${delay} seconds before trying again."
				sleep "${delay}"
				n=$((n+1))
				delay=$((${delay} * ${n}))
			else
				set -e
				echo "FATAL: Job submission failed reproducibly and I'm giving up after ${n} attempts!"
				exit 1
			fi
		fi
	done
}

#
##
### Main.
##
#

#
# First find our where this submit.sh script and the job *.sh scripts were created
# Then change to that directory to make sure relative paths 
# further down in this script can be resolved correctly.
#
MC_scriptsDir=$( cd -P "$( dirname "$0" )" && pwd )
echo -n "INFO: Changing working directory to ${MC_scriptsDir}... "
cd "${MC_scriptsDir}"
echo 'done.'

#
# Cleanup and cancel previously submitted jobs and 
# initialize empty ${MC_submittedJobIDs} with desired perms
# before re-submitting jobs for the same project.
#
if [ -f "${MC_submittedJobIDs}" ]; then
	#cancelJobs "${MC_submittedJobIDs}"
	echo "oops"
fi
chmod g+w ${MC_submittedJobIDs}>>${MC_submittedJobIDs}

touch molgenis.submit.started


