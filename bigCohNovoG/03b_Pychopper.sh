#!/bin/bash
#SBATCH --job-name=Pychopper
#SBATCH --ntasks=1
#SBATCH --mem=20G
#SBATCH --time=05:00:00
#SBATCH --qos=cpu_short
#SBATCH --partition=cpu_p
#SBATCH --output=/lustre/groups/itg/teams/kim-hellmuth/projects/yfv/bigCohortNovoG/err_out/%x_%A_%J_%a.out
#SBATCH --error=/lustre/groups/itg/teams/kim-hellmuth/projects/yfv/bigCohortNovoG/err_out/%x_%A_%J_%a.err
#SBATCH --mail-type=FAIL,REQUEUE,ARRAY_TASKS
#SBATCH --mail-user=nicolas.lichilin@helmholtz-munich.de
#SBATCH --array=1-144
#SBATCH --cpus-per-task=8

eval "$(conda shell.bash hook)"
conda init
conda activate trimming
# pychopper                     2.7.10    pyhdfd78af_0  bioconda

export DIR="/lustre/groups/itg/teams/kim-hellmuth/projects/yfv/bigCohortNovoG/data/01stBatch/Dorado"
cd $DIR

export SAMPLE_DIR=`cat ${DIR}/Sample_Dir_List.txt | head -n $SLURM_ARRAY_TASK_ID |tail -n 1`
export SAMPLEID=`basename $SAMPLE_DIR`

export SAMPLE=`echo ${SAMPLE_DIR}.fastq.gz`
#export SAMPLEID=`basename $SAMPLE .fastq.gz`

export DIROUT="/lustre/groups/itg/teams/kim-hellmuth/projects/yfv/bigCohortNovoG/data/01stBatch/pychopper"

mkdir -p -m 744 ${DIROUT}/${SAMPLEID}
cd  ${DIROUT}/${SAMPLEID}

pychopper -r ${SAMPLEID}_report.pdf \
-k LSK114 \
-S ${SAMPLEID}_stats.tsv \
-u ${SAMPLEID}_unclassified.fq \
-w ${SAMPLEID}_rescued.fq \
$SAMPLE ${SAMPLEID}_trim.fastq \
-t $SLURM_CPUS_PER_TASK \
-m edlib

pigz -f -p $SLURM_CPUS_PER_TASK ${SAMPLEID}_unclassified.fq ${SAMPLEID}_rescued.fq ${SAMPLEID}_trim.fastq


