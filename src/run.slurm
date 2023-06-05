#!/bin/bash

# Slurm job options (name, compute nodes, job time)
#SBATCH --job-name=hw_256
#SBATCH --time=00:20:00
#SBATCH --exclusive
#SBATCH --nodes=1
#SBATCH --tasks-per-node=2
#SBATCH --cpus-per-task=1

#SBATCH --account=tc045
#SBATCH --reservation=tc045_956402
#SBATCH --partition=standard
#SBATCH --qos=reservation

# Load required modules
source /work/tc045/tc045/shared/.bashrc
module load gcc/8.2.0 mpt/2.25
conda activate /work/tc045/tc045/shared/bpp_5_0_0_ss_0_4_2
module load bout-dep/2023-06-01

# Set the number of threads to 1
#   This prevents any threaded system libraries from automatically
#   using threading.
export OMP_NUM_THREADS=1

# Start the orchestrator and a new experiment which launches RedisAI for communication
DB_PORT=6899
python /work/tc045/tc045/shared/model/start_db.py $DB_PORT
#echo "Started Redis"

# Change to the submission directory
cd $SLURM_SUBMIT_DIR

# Launch the parallel job
#   srun picks up the distribution from the sbatch options
export SSDB=127.0.0.1:$DB_PORT
srun -n 1 ./build/hasegawa-wakatani
