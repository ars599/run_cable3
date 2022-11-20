#!/bin/bash
 
#PBS -m ae
#PBS -P p66
#PBS -q normal
#PBS -l walltime=05:00:00
#PBS -l mem=50GB
#PBS -l ncpus=16
#PBS -j oe
#PBS -l wd
#PBS -l storage=scratch/p66+scratch/access+gdata/p66+gdata/access
#PBS -M yingping.wang@csiro.au   
 
module load dot
module add intel-compiler/2019.5.281
module add netcdf intel-mpi/2019.5.281

cd /scratch/p66/yxw599/runcable-access-esm

#cp cable-mpi-v8707 cable-mpi-vz
#cp cable-mpi-v8708 cable-mpi-vz
rm cable-mpi-vz
rm test_out_noluc_vcmax_x025.txt 
cp cable-mpi-v8712 cable-mpi-vz

cp /g/data/p66/yxw599/trendy10_input/luc/lucout_access/esm/restart_2000.nc restart_in.nc
cp /g/data/p66/yxw599/trendy10_input/luc/lucout_access/esm/cnppool_2000.nc poolcnp_in.nc
cp /g/data/p66/yxw599/trendy10_input/luc/lucout_access/esm/grid_access_2000.nc grid_access_in.nc
cp /scratch/p66/yxw599/runcable-access-esm/inputs/cable_soilparm_luc.nml cable_soilparm.nml
cp /scratch/p66/yxw599/runcable-access-esm/inputs/pft_params_luc.nml pft_params.nml
cp /scratch/p66/yxw599/runcable-access-esm/name_luc/s0_cn_cal/pftlookup_casacnp_vcmax_x25pc.csv pftlookup_casacnp.csv


loop =0
while [$loop -le 5 and xmin >0.01]
do

yr=2001
while [ $yr -le 2010  ]
do
  cp /scratch/p66/yxw599/runcable-access-esm/name_luc/s0_cn_cal/cable_${yr}_s0_cn_vcmax_noluc_cal.nml cable.nml
  mpirun -np 16 ./cable-mpi-vz <cable.nml >>test_out_noluc_vcmax_x025.txt
  cp restart_out.nc restart_in.nc
  cp poolcnp_out.nc poolcnp_in.nc
  mv restart_out.nc trendy10_restart/s0_cn_cal/restart_out_noluc_vcmax_x25pc_${yr}.nc
  mv poolcnp_out.nc trendy10_output/s0_cn_cal/poolcnp_out_noluc_vcmax_x25pc_${yr}.nc
  mv cable_out.nc trendy10_output/s0_cn_cal/cable_out_noluc_vcmax_x25pc_${yr}.nc
  mv STANDARD_*.nc trendy10_output/s0_cn_cal/STANDARD_casa_out_noluc_vcmax_x25pc_${yr}.nc
  mv cnpfluxOut.csv trendy10_output/s0_cn_cal/cnpflux_out_noluc_vcmax_x25pc_${yr}.nc

  yr=`expr $yr + 1`
done
  python3 cable_post.py >out1.txt
  xmin=`grep xmin out1.txt`

  loop=`expr $loop + 1`
done

grep "NPP" test_out_noluc_vcmax_x025.txt >trendy10_output/s0_cn_cal/NPP_noluc_vcmax_x25.txt
qsub test_vcmax050.ksh
