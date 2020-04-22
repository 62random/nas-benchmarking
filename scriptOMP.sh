# Load required modules 
module purge
module load gcc/4.9.0
#module load gnu/openmpi_mx/1.8.4 

# Tests to run
# (bt lu sp)
tests=(is ep mg bt lu)

# Problem sizes to run tests on
# (W A B C)
classes=(W A B C)

# Threads to use
nthreads=(1 2 4 8 16 32 40 48) 

# Get user and number of threads available
user=$(whoami)

# Delete old results
cd /home/$user/ESC/gnu

# Delete old run config
rm ../NPB3.3.1/NPB3.3-OMP/config/suite.def
# Create config files for new run

for t in "${tests[@]}"
do
    for c in "${classes[@]}"
    do 
        echo "${t} ${c}" >> ../NPB3.3.1/NPB3.3-OMP/config/suite.def
    done
done

# Copy make.def to build path
cp make.def ../NPB3.3.1/NPB3.3-OMP/config/make.def

# Build benchmarks with config files
cd ../NPB3.3.1/NPB3.3-OMP
make suite 

cd ../../gnu

for nt in "${nthreads[@]}"
do
    for t in "${tests[@]}"
    do
        for c in "${classes[@]}"
        do 
            export OMP_NUM_THREADS=${nt}
            ./../NPB3.3.1/NPB3.3-OMP/bin/${t}.${c}.x > results/${t}_${c}_${nt}threads
        done
    done
done

