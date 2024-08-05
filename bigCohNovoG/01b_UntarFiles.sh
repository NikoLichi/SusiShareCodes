#!/bin/bash
#SBATCH --job-name=Untar
#SBATCH --ntasks=1
#SBATCH --mem=5G
#SBATCH --time=05:00:00
#SBATCH --qos=cpu_short
#SBATCH --partition=cpu_p
#SBATCH --output=/lustre/groups/itg/teams/kim-hellmuth/projects/yfv/bigCohortNovoG/err_out/%x_%A_%J_%a.out
#SBATCH --error=/lustre/groups/itg/teams/kim-hellmuth/projects/yfv/bigCohortNovoG/err_out/%x_%A_%J_%a.err
#SBATCH --mail-type=FAIL,REQUEUE,ARRAY_TASKS
#SBATCH --mail-user=nicolas.lichilin@helmholtz-munich.de
#SBATCH --array=1-144
#SBATCH --cpus-per-task=1

export DIR="/lustre/groups/itg/teams/kim-hellmuth/projects/yfv/bigCohortNovoG/data/01stBatch"
cd $DIR

# Specify the input file
export FILE=`cat ${DIR}/FilesUntar_List_F004_1_2.txt | head -n $SLURM_ARRAY_TASK_ID |tail -n 1 `
export DIRFILE=`dirname $FILE`
cd $DIRFILE

tar -xvf $FILE

