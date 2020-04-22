#!/bin/bash
#setup enviroment


#PSB -N MPI_ESC_641
#PBS -l walltime=02:00:00
#PBS -q mei
#PBS -l nodes=2:r641:ppn=32

#AUX XmCW9LJQ

# Tests to run
tests=(bt lu sp)
# Problem sizes to run tests on
classes=(A S W)
#timestamp
time=$( cat /proc/sys/kernel/hostname)
result_folder="${time}_results"

# Get user and number of threads available
user=$(whoami)

# Delete old results
cd /home/$user/ESC/MPI
mkdir -p ${result_folder}
rm -rf ${result_folder}/*

# Delete old run config
rm ../NPB3.3.1-MZ/NPB3.3-MZ-MPI/config/suite.def
# Create config files for new run
for c in "${classes[@]}"
do
    for t in "${tests[@]}"
    do 
            echo "${t}-mz ${c} 2" >> ../NPB3.3.1-MZ/NPB3.3-MZ-MPI/config/suite.def
            echo "${t}-mz ${c} 4" >> ../NPB3.3.1-MZ/NPB3.3-MZ-MPI/config/suite.def
    done
done


# run for mri and gnu compiler
# Load required modules 
module purge
module load gcc/4.9.0
module load gnu/openmpi_mx/1.8.4 

# Copy make.def to build path
cp make.def ../NPB3.3.1-MZ/NPB3.3-MZ-MPI/config/make.def

# Build benchmarks with config files
cd ../NPB3.3.1-MZ/NPB3.3-MZ-MPI
make suite

# Run benchmarks and save results
cd ../../MPI
for c in "${classes[@]}"
do
    for t in "${tests[@]}"
    do 
            export OMP_NUM_THREADS=32
            mpirun -np 2 --bind-to hwthread --map-by ppr:1:node:pe=32 -x OMP_NUM_THREADS -mca mtl mx -mca pml cm  ../NPB3.3.1-MZ/NPB3.3-MZ-MPI/bin/${t}-mz.${c}.2 > ${result_folder}/${t}_${c}_gnu_mri_node
            export OMP_NUM_THREADS=16
            mpirun -np 4 --bind-to hwthread --map-by ppr:2:node:pe=16 -x OMP_NUM_THREADS -mca mtl mx -mca pml cm  ../NPB3.3.1-MZ/NPB3.3-MZ-MPI/bin/${t}-mz.${c}.4 > ${result_folder}/${t}_${c}_gnu_mri_socket
    done
done

#Re-run for intel-compiler mri
# Load required modules 
module purge
module load intel/2019
module load intel/openmpi_mx/1.8.4

# Copy make.def(intel) to build path
cp make.def ../NPB3.3.1-MZ/NPB3.3-MZ-MPI/config/make.def

# Build benchmarks with config files
cd ../NPB3.3.1-MZ/NPB3.3-MZ-MPI
make suite

# Run benchmarks and save results
cd ../../MPI
for c in "${classes[@]}"
do
    for t in "${tests[@]}"
    do 
            export OMP_NUM_THREADS=32
            mpirun -np 2 --bind-to hwthread --map-by ppr:1:node:pe=32 -x OMP_NUM_THREADS -mca mtl mx -mca pml cm  ../NPB3.3.1-MZ/NPB3.3-MZ-MPI/bin/${t}-mz.${c}.2 > ${result_folder}/${t}_${c}_intel_mri_node
            export OMP_NUM_THREADS=16
            mpirun -np 4 --bind-to hwthread --map-by ppr:2:node:pe=16 -x OMP_NUM_THREADS -mca mtl mx -mca pml cm  ../NPB3.3.1-MZ/NPB3.3-MZ-MPI/bin/${t}-mz.${c}.4 > ${result_folder}/${t}_${c}_intel_mri_socket
    done
done

#Re-run for gnu-compiler gbe
# Load required modules 
module purge
module load gcc/4.9.0
module load gnu/openmpi_eth/1.8.4

# Copy make.def(intel) to build path
cp make.def ../NPB3.3.1-MZ/NPB3.3-MZ-MPI/config/make.def

# Build benchmarks with config files
cd ../NPB3.3.1-MZ/NPB3.3-MZ-MPI
make suite

# Run benchmarks and save results
cd ../../MPI
for c in "${classes[@]}"
do
    for t in "${tests[@]}"
    do      
            export OMP_NUM_THREADS=32
            mpirun -np 2 --bind-to hwthread --map-by ppr:1:node:pe=32 -x OMP_NUM_THREADS -mca btl self,sm,tcp ../NPB3.3.1-MZ/NPB3.3-MZ-MPI/bin/${t}-mz.${c}.2 > ${result_folder}/${t}_${c}_gnu_eth_node
            export OMP_NUM_THREADS=16
            mpirun -np 4 --bind-to hwthread --map-by ppr:2:node:pe=16 -x OMP_NUM_THREADS -mca btl self,sm,tcp ../NPB3.3.1-MZ/NPB3.3-MZ-MPI/bin/${t}-mz.${c}.4 > ${result_folder}/${t}_${c}_gnu_eth_socket
    done
done
