#!/bin/bash
#SBATCH --job-name=md5FileSize_F003_3
#SBATCH --ntasks=1
#SBATCH --mem=5G
#SBATCH --time=00:30:00
#SBATCH --qos=cpu_priority
#SBATCH --partition=cpu_p
#SBATCH --output=/lustre/groups/itg/teams/kim-hellmuth/projects/yfv/bigCohortNovoG/err_out/%x_%A_%J_%a.out
#SBATCH --error=/lustre/groups/itg/teams/kim-hellmuth/projects/yfv/bigCohortNovoG/err_out/%x_%A_%J_%a.err
#SBATCH --mail-type=FAIL,REQUEUE,ARRAY_TASKS
#SBATCH --mail-user=nicolas.lichilin@helmholtz-munich.de
#SBATCH --array=1-62
#SBATCH --cpus-per-task=1

export DIR="/lustre/groups/itg/teams/kim-hellmuth/projects/yfv/bigCohortNovoG/data/01stBatch"
#export DISK="F001" # There are 76 Files inside the folder change
#export DISK="F003_1" # There are 62 Files inside the folder change
#export DISK="F003_2" # There are 62 Files inside the folder change
export DISK="F003_3" # There are 62 Files inside the folder change
#export DISK="F003_4" # There are 40 Files inside the folder change
cd ${DIR}/${DISK}




touch fileSizeToCheck.txt
touch md5sumtoCheck.txt


#export FILE=`cat ${DIR}/FilesTomd5sumCheck_List_F004_1_2.txt | head -n $SLURM_ARRAY_TASK_ID |tail -n 1 `
export FILE=`find $PWD -mindepth 2 -maxdepth 3 -type f |sort -V | head -n $SLURM_ARRAY_TASK_ID |tail -n 1 `

#Check File size
ls -l $FILE | awk '{print $5,$9}' >> fileSizeToCheck.txt

# check md5sum
md5sum $FILE >> md5sumtoCheck.txt

