#!/bin/bash
#SBATCH --job-name=DoradoCUDA_80_sepBarC_Pass
#SBATCH --ntasks=1
#SBATCH --mem=160G
#SBATCH --time=1-00:00:00
#SBATCH --qos=gpu_normal
#SBATCH --partition=gpu_p
#SBATCH --output=/lustre/groups/itg/teams/kim-hellmuth/projects/yfv/bigCohortNovoG/err_out/dorado/gitHub/%x_%A_%J_%a.out
#SBATCH --error=/lustre/groups/itg/teams/kim-hellmuth/projects/yfv/bigCohortNovoG/err_out/dorado/gitHub/%x_%A_%J_%a.err
#SBATCH --mail-type=FAIL,REQUEUE,ARRAY_TASKS
#SBATCH --mail-user=nicolas.lichilin@helmholtz-munich.de
#SBATCH --array=1-432
#SBATCH --cpus-per-task=20
#SBATCH --gpus-per-task=2

##SBATCH --mem=240G
##SBATCH --qos=gpu_long
##SBATCH --cpus-per-task=28
##SBATCH --gpus-per-task=2

##SBATCH --constraint=a100_40gb
#SBATCH --constraint=a100_80gb
##SBATCH --constraint=v100_32gb

#Conda base
#samtools 1.18
#Using htslib 1.18


export DIRBASE="/lustre/groups/itg/teams/kim-hellmuth/projects/yfv/bigCohortNovoG/data/01stBatch"
cd $DIRBASE

#export POD5_DIR=`find $DIRBASE -type d -name "*fast5_2_pod5" | sort -V | head -n $SLURM_ARRAY_TASK_ID |tail -n 1 `
#export POD5_DIR=`cat ${DIRBASE}/POD5_Dirs_List_F004_1_2.txt | head -n $SLURM_ARRAY_TASK_ID |tail -n 1`
export POD5_DIR=`cat ${DIRBASE}/POD5_Dirs_List_ALL_Pass2.txt | head -n $SLURM_ARRAY_TASK_ID |tail -n 1`

#export DIR="/lustre/groups/itg/teams/kim-hellmuth/projects/yfv/bigCohortNovoG/data/01stBatch"
export PREFIX=`echo $POD5_DIR | cut -f 15 -d "/" `
export SAMPLEID=`echo $POD5_DIR | cut -f 14 -d "/" `
mkdir -p ${DIRBASE}/Dorado/${SAMPLEID}

cd ${DIRBASE}/Dorado/${SAMPLEID}

#dna_r10.4.1_e8.2_400bps_sup or dna_r10.4.1_e8.2_400bps_5khz_sup.cfg
~/Applications/dorado/GitHv5.0/dorado-0.7.2-linux-x64/bin/dorado basecaller sup \
$POD5_DIR \
--verbose --recursive --no-trim -x cuda:all | samtools fastq -@  $SLURM_CPUS_PER_TASK -T '*' - | pigz -p $SLURM_CPUS_PER_TASK > ${PREFIX}_pass.fastq.gz








