#!/bin/bash
#SBATCH --job-name=Untar_F003_4
#SBATCH --ntasks=1
#SBATCH --mem=5G
#SBATCH --time=05:00:00
#SBATCH --qos=cpu_short
#SBATCH --partition=cpu_p
#SBATCH --output=/lustre/groups/itg/teams/kim-hellmuth/projects/yfv/bigCohortNovoG/err_out/%x_%A_%J_%a.out
#SBATCH --error=/lustre/groups/itg/teams/kim-hellmuth/projects/yfv/bigCohortNovoG/err_out/%x_%A_%J_%a.err
#SBATCH --mail-type=FAIL,REQUEUE,ARRAY_TASKS
#SBATCH --mail-user=nicolas.lichilin@helmholtz-munich.de
#SBATCH --array=1-36
#SBATCH --cpus-per-task=1

export DIR="/lustre/groups/itg/teams/kim-hellmuth/projects/yfv/bigCohortNovoG/data/01stBatch"
#export DISK="F001" # There are 72 TAR Files inside the folders
#export DISK="F003_1" # There are 60 Files inside the folder change
#export DISK="F003_2" # There are 60 Files inside the folder change
#export DISK="F003_3" # There are 60 Files inside the folder change
export DISK="F003_4" # There are 36 Files inside the folder change
cd ${DIR}/${DISK}

# Specify the input file
#export FILE=`cat ${DIR}/FilesUntar_List_F004_1_2.txt | head -n $SLURM_ARRAY_TASK_ID |tail -n 1 `
export FILE=`find $PWD -name "*.tar" |sort -V | head -n $SLURM_ARRAY_TASK_ID |tail -n 1 `
export DIRFILE=`dirname $FILE`
cd $DIRFILE

tar -xvf $FILE

