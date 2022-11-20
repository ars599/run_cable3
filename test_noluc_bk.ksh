#!/bin/bash
 
#PBS -m ae
#PBS -P p66
#PBS -q normal
#PBS -l walltime=05:00:00
#PBS -l mem=50GB
#PBS -l ncpus=16
#PBS -j oe
#PBS -l wd
#PBS -N cTest
#PBS -l storage=scratch/p66+scratch/access+gdata/p66+gdata/access
##PBS -M sul086@csiro.au   
 
module load dot
module add intel-compiler/2019.5.281
module add netcdf intel-mpi/2019.5.281

cd /scratch/p66/ars599/CABLE3

#cp cable-mpi-v8707 cable-mpi-vz
#cp cable-mpi-v8708 cable-mpi-vz
rm cable-mpi-vz
rm test_outnoluc.txt
cp cable-mpi-v8712 cable-mpi-vz

cp /scratch/p66/ars599/CABLE3/inputs/trendy10_inputs/restart_2000.nc restart_in.nc
cp /scratch/p66/ars599/CABLE3/inputs/trendy10_inputs/cnppool_2000.nc poolcnp_in.nc
cp /scratch/p66/ars599/CABLE3/inputs/trendy10_inputs/grid_access_2000.nc grid_access_in.nc
cp /scratch/p66/ars599/CABLE3/inputs/trendy10_inputs/cable_soilparm.nml .
cp /scratch/p66/ars599/CABLE3/inputs/trendy10_inputs/pft_params.nml .
cp /scratch/p66/ars599/CABLE3/inputs/trendy10_inputs/pftlookup_casacnp.csv .

yr=2001
while [ $yr -le 2001  ]
do
#  cp /scratch/p66/ars599/CABLE3/name_luc/s0_cn_cal/cable_${yr}_s0_cn_vcmax_noluc_cal.nml cable.nml
  rm restart_out.nc
  rm poolcnp_out.nc
  rm cable_out.nc
  rm STANDARD_*.nc
  rm cnpfluxOut.csv
  mpirun -np 16 ./cable-mpi-vz <cable.nml >>test_outnoluc.txt
  cp restart_out.nc restart_in.nc
  cp poolcnp_out.nc poolcnp_in.nc
  mv restart_out.nc trendy10_restart/s0_cn_cal/restart_out_noluc_${yr}.nc
  mv poolcnp_out.nc trendy10_output/s0_cn_cal/poolcnp_out_noluc_${yr}.nc
  mv cable_out.nc trendy10_output/s0_cn_cal/cable_out_noluc_${yr}.nc
  mv STANDARD_*.nc trendy10_output/s0_cn_cal/STANDARD_casa_out_noluc_${yr}.nc
  mv cnpfluxOut.csv trendy10_output/s0_cn_cal/cnpflux_out_noluc_${yr}.nc

  yr=`expr $yr + 1`
done
