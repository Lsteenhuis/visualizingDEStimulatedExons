
#
## scriptName
#

#
# Build dependency string.
#
MC_jobDependenciesExist=false
MC_jobDependencies='--dependency=afterok'
        if [[ -n "$InsertHere" ]]; then
                MC_jobDependenciesExist=true
                MC_jobDependencies+=":$InsertHere"
        fi
if ! ${MC_jobDependenciesExist}; then
        MC_jobDependencies=''
fi


#
# Process job: either skip if job if previously finished successfully or submit job to batch scheduler.
#
processJob "scriptName" "${MC_sbatchOptions}" "${MC_jobDependencies}"
scriptName="${MC_jobID}"

