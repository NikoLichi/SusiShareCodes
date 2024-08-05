#!/bin/bash
#SBATCH --job-name=md5FileSize
#SBATCH --ntasks=1
#SBATCH --mem=5G
#SBATCH --time=00:30:00
#SBATCH --qos=cpu_priority
#SBATCH --partition=cpu_p
#SBATCH --output=/lustre/groups/itg/teams/kim-hellmuth/projects/yfv/bigCohortNovoG/err_out/%x_%A_%J_%a.out
#SBATCH --error=/lustre/groups/itg/teams/kim-hellmuth/projects/yfv/bigCohortNovoG/err_out/%x_%A_%J_%a.err
#SBATCH --mail-type=FAIL,REQUEUE,ARRAY_TASKS
#SBATCH --mail-user=nicolas.lichilin@helmholtz-munich.de
#SBATCH --array=1-149
#SBATCH --cpus-per-task=1

export DIR="/lustre/groups/itg/teams/kim-hellmuth/projects/yfv/bigCohortNovoG/data/01stBatch"
cd $DIR


#touch fileSizeToCheck.txt
#touch md5sumtoCheck.txt


export FILE=`cat ${DIR}/FilesTomd5sumCheck_List_F004_1_2.txt | head -n $SLURM_ARRAY_TASK_ID |tail -n 1 `

#Check File size
ls -l $FILE | awk '{print $5,$9}' >> fileSizeToCheck.txt

# check md5sum
md5sum $FILE >> md5sumtoCheck.txt

