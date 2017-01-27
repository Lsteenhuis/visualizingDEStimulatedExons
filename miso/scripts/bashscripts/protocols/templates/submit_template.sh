
#
## scriptName
#

#
# Build dependency string.
#
MC_jobDependenciesExist=false
MC_jobDependencies='--dependency=afterok'
if ! ${MC_jobDependenciesExist}; then
        MC_jobDependencies=''
fi
#



#
# Process job: either skip if job if previously finished successfully or submit job to batch scheduler.
#
processJob "scriptName" "${MC_sbatchOptions}" "${MC_jobDependencies}"
scriptName="${MC_jobID}"

