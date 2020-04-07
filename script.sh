# Load required modules 
module purge
module load gcc/4.9.0
module load gnu/openmpi_mx/1.8.4 

# Tests to run
tests=(bt lu sp)
# Problem sizes to run tests on
classes=(A S W)

# Get user and number of threads available
user=$(whoami)
nthreads=1 # $(cat /proc/cpuinfo | grep proc | wc -l)

# Delete old results
cd /home/$user/ESC/MPI
mkdir -p results
rm -rf results/*

# Delete old run config
rm ../NPB3.3.1-MZ/NPB3.3-MZ-MPI/config/suite.def
# Create config files for new run
for t in "${tests[@]}"
do
    for c in "${classes[@]}"
    do 
        echo "${t}-mz ${c} ${nthreads}" >> ../NPB3.3.1-MZ/NPB3.3-MZ-MPI/config/suite.def
    done
done

# Copy make.def to build path
cp make.def ../NPB3.3.1-MZ/NPB3.3-MZ-MPI/config/make.def

# Build benchmarks with config files
cd ../NPB3.3.1-MZ/NPB3.3-MZ-MPI
make suite

# Run benchmarks and save results
cd ../../MPI
for t in "${tests[@]}"
do
    for c in "${classes[@]}"
    do 
        ./../NPB3.3.1-MZ/NPB3.3-MZ-MPI/bin/${t}-mz.${c}.1 > results/${t}_${c}
    done
done


