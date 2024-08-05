#!/bin/bash
#SBATCH --job-name=DoradoServ_80_sepBarC
#SBATCH --ntasks=1
#SBATCH --mem=160G
#SBATCH --time=1-00:00:00
#SBATCH --qos=gpu_normal
#SBATCH --partition=gpu_p
#SBATCH --output=/lustre/groups/itg/teams/kim-hellmuth/projects/yfv/bigCohortNovoG/err_out/dorado/%x_%A_%J_%a.out
#SBATCH --error=/lustre/groups/itg/teams/kim-hellmuth/projects/yfv/bigCohortNovoG/err_out/dorado/%x_%A_%J_%a.err
#SBATCH --mail-type=FAIL,REQUEUE,ARRAY_TASKS
#SBATCH --mail-user=nicolas.lichilin@helmholtz-munich.de
##SBATCH --array=1-288
##SBATCH --array=34,30,28,22,20,18,6,10,14,16 # Stuck in time
##SBATCH --array=50,49,46,42,44,38,40 # Stuck in time
#SBATCH --array=55,56   # Stuck in time
#SBATCH --cpus-per-task=6
#SBATCH --gpus-per-task=1

##SBATCH --constraint=a100_40gb
#SBATCH --constraint=a100_80gb
##SBATCH --constraint=v100_32gb

export DIRBASE="/lustre/groups/itg/teams/kim-hellmuth/projects/yfv/bigCohortNovoG/data/01stBatch"
cd $DIRBASE

#export POD5_DIR=`find $DIRBASE -type d -name "*fast5_2_pod5" | sort -V | head -n $SLURM_ARRAY_TASK_ID |tail -n 1 `
export POD5_DIR=`cat ${DIRBASE}/POD5_Dirs_List_F004_1_2.txt | head -n $SLURM_ARRAY_TASK_ID |tail -n 1`

#export DIR="/lustre/groups/itg/teams/kim-hellmuth/projects/yfv/bigCohortNovoG/data/01stBatch"
export PREFIX=`echo $POD5_DIR | cut -f 14 -d "/" `
mkdir -p ${DIRBASE}/Dorado/${PREFIX}

# get a socket between 8000-9000
PORT=$(/usr/bin/shuf -i 8000-9000 -n 1)
echo -e "Port used:"
echo $PORT

# --barcode_kits SQK-LSK114
/home/itg/nicolas.lichilin/Applications/dorado/v7.3.9/ont-dorado-server/bin/dorado_basecall_server  --port $PORT --use_tcp --device cuda:all \
-c dna_r10.4.1_e8.2_400bps_5khz_sup.cfg \
--log_path /lustre/groups/itg/teams/kim-hellmuth/projects/yfv/bigCohortNovoG/err_out/dorado/ \
&

sleep 60

/home/itg/nicolas.lichilin/Applications/dorado/v7.3.9/ont-dorado-server/bin/ont_basecall_client -i $POD5_DIR \
-s ${DIRBASE}/Dorado/${PREFIX} \
-c dna_r10.4.1_e8.2_400bps_5khz_sup.cfg \
--port localhost:${PORT} --use_tcp \
--compress_fastq






