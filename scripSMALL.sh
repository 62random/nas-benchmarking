module purge
module load gcc/4.9.0
module load gnu/openmpi_mx/1.8.4 

user=$(whoami)

cd /home/$user/ESC/
cd MPI
mkdir -p results
rm -rf results/*
cp suite2.def ../NPB3.3.1-MZ/NPB3.3-MZ-MPI/config/suite.def
cp make.def ../NPB3.3.1-MZ/NPB3.3-MZ-MPI/config/make.def
cd ../NPB3.3.1-MZ/NPB3.3-MZ-MPI
make suite
cd ../../MPI

./../NPB3.3.1-MZ/NPB3.3-MZ-MPI/bin/bt-mz.S.1 > results/bt_S
./../NPB3.3.1-MZ/NPB3.3-MZ-MPI/bin/lu-mz.S.1 > results/lu_S
./../NPB3.3.1-MZ/NPB3.3-MZ-MPI/bin/sp-mz.S.1 > results/sp_S


