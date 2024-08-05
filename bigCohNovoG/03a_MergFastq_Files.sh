#!/bin/bash
#SBATCH --job-name=Merge_Dorado_fq
#SBATCH --ntasks=1
#SBATCH --mem=1G
#SBATCH --time=05:00:00
#SBATCH --qos=cpu_short
#SBATCH --partition=cpu_p
#SBATCH --output=/lustre/groups/itg/teams/kim-hellmuth/projects/yfv/bigCohortNovoG/err_out/%x_%A_%J_%a.out
#SBATCH --error=/lustre/groups/itg/teams/kim-hellmuth/projects/yfv/bigCohortNovoG/err_out/%x_%A_%J_%a.err
#SBATCH --mail-type=FAIL,REQUEUE,ARRAY_TASKS
#SBATCH --mail-user=nicolas.lichilin@helmholtz-munich.de
#SBATCH --array=1-144
#SBATCH --cpus-per-task=1

export DIR="/lustre/groups/itg/teams/kim-hellmuth/projects/yfv/bigCohortNovoG/data/01stBatch/Dorado"
cd $DIR

export SAMPLE_DIR=`cat ${DIR}/Sample_Dir_List.txt | head -n $SLURM_ARRAY_TASK_ID |tail -n 1`
export SAMPLEID=`basename $SAMPLE_DIR`

cd $SAMPLE_DIR
cat *.fastq.gz > ../${SAMPLEID}.fastq.gz







