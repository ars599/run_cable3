
# main CABLE files:
https://trac.nci.org.au/svn/cable/tags/CABLE-3.0_beta/

# but dont use directly from CABLE trac
but use the one from yxw599, such as
https://trac.nci.org.au/svn/cable/branches/Users/yxw599/cable-3.0_9037/


# back up from gadi
rsync -var --exclude trend* --exclude gswp ars599@gadi.nci.org.au:/scratch/p66/ars599/CABLE3/* .


cd /g/data/p66/ars599/ACCESS-CABLE/
svn co https://trac.nci.org.au/svn/cable/branches/Users/yxw599/cable-3.0_9037 cable-3.0_9037


lns -f /g/data/p66/ars599/ACCESS-CABLE/cable-3.0_9037/offline/cable-mpi cable-mpi-v9037

rsync -var $gd66/ACCESS-CABLE/trendy10_* .
rsync -var $gd66/ACCESS-CABLE/gswp .

**1. edit test_noluc.ksh
```
module load dot
module add intel-compiler/2019.5.281
module add netcdf intel-mpi/2019.5.281

cd /scratch/p66/ars599/CABLE3

#cp cable-mpi-v8707 cable-mpi-vz
rm cable-mpi-vz
#cp cable-mpi-v8720 cable-mpi-vz
#cp cable-mpi-v9037 cable-mpi-vz # not working
#cp cable-mpi-v87202 cable-mpi-vz
cp cable-mpi-v8707 cable-mpi-vz
rm test_outnoluc.txt
#cp cable-mpi-v8712 cable-mpi-vz

cp /scratch/p66/ars599/CABLE3/trendy10_inputs/restart_2000.nc restart_in.nc
cp /scratch/p66/ars599/CABLE3/trendy10_inputs/cnppool_2000.nc poolcnp_in.nc
cp /scratch/p66/ars599/CABLE3/trendy10_inputs/grid_access_in.nc grid_access_in.nc
cp /scratch/p66/ars599/CABLE3/trendy10_inputs/cable_soilparm.nml .
cp /scratch/p66/ars599/CABLE3/trendy10_inputs/pft_params.nml .
cp /scratch/p66/ars599/CABLE3/trendy10_inputs/pftlookup_casacnp.csv .

yr=2001
while [ $yr -le 2001 ]

```

**2. edit mk_s0_cn_vcmax_noluc_cal2000.bash
```
startyr=2001
endyr=2010
yr=$startyr
yr1=`expr $yr + 1`
metyr=1901
yr2=$metyr
while [ $yr -le $endyr ]
do
CO2=`awk '$1=='$yr' {printf "%5.1f",$2}' global_co2_ann_1700_2020.txt`
cat>/scratch/p66/ars599/CABLE3/name_luc/s0_cn_cal/cable_${yr}_s0_cn_vcmax_noluc_cal.nml<<EOF
&cable
   filename%met = ''
   filename%out = 'cable_out.nc'
   filename%log = 'cable_log.txt'
   filename%restart_in = 'restart_in.nc'
   filename%restart_out = 'restart_out.nc'
   filename%type = 'grid_access_in.nc'
   filename%gridnew = 'grid_access_out.nc'
   filename%fxpft0 = '/scratch/p66/ars599/CABLE3/trendy10_inputs/luclh2_access_2000.nc'
   filename%fxpft = '/scratch/p66/ars599/CABLE3/trendy10_inputs/luclh2_access_2001.nc'
   filename%fxluh2cable = '/scratch/p66/ars599/CABLE3/trendy10_inputs/xluh2cable_access.nc'
   filename%veg = '/scratch/p66/ars599/CABLE3/trendy10_inputs/def_veg_params_zr_clitt_albedo_fix_luc.txt'

~~~
   verbose = .FALSE.
   leaps = .FALSE. ! calculate timing with leap years?
   logn = 88      ! log file number - declared in input module
   fixedCO2 =368.42 ! if not found in met file, in ppmv
   !spincasainput = ''    !FALSE   ! input required to spin casacnp offline
   spincasa = .FALSE.     ! spin casa before running the model if TRUE, and should be set to FALSE if spincasainput
   l_laiFeedbk = .FALSE.  ! using prognostic LAI
   l_vcmaxFeedbk = .FALSE.  ! using prognostic Vcmax
   casafile%cnpipool = '/scratch/p66/ars599/CABLE3/poolcnp_in.nc'  !
   casafile%cnpepool = '/scratch/p66/ars599/CABLE3/poolcnp_out.nc'
   casafile%cnpbiome = 'pftlookup_casacnp.csv'
   casafile%cnpmetout = 'casamet.nc'                ! output daily met forcing for spinning casacnp
   casafile%cnpmetin = ''          ! list of daily met files for spinning casacnp
   casafile%phen = '/scratch/p66/ars599/CABLE3/inputs/modis_phenology_csiro.txt'        ! modis phenology


~~~
   gswpfile%mask = '/scratch/p66/ars599/CABLE3/inputs/landsea-access-esm.nc'

~~~
   l_casacnp=.FALSE.
   l_landuse=.FALSE.
   icycle=2
   gswpfile%Rainf  ='/scratch/p66/ars599/CABLE3/gswp/system3/crujra_access_Rainf_${yr2}.nc'
   gswpfile%snowf  ='/scratch/p66/ars599/CABLE3/gswp/system3/cruncep_access_Snowf_${yr2}.nc'
   gswpfile%LWdown ='/scratch/p66/ars599/CABLE3/gswp/system3/crujra_access_LWdown_${yr2}.nc'
   gswpfile%SWdown ='/scratch/p66/ars599/CABLE3/gswp/system3/crujra_access_SWdown_${yr2}.nc'
   gswpfile%PSurf  ='/scratch/p66/ars599/CABLE3/gswp/system3/crujra_access_PSurf_${yr2}.nc'
   gswpfile%Qair   ='/scratch/p66/ars599/CABLE3/gswp/system3/crujra_access_Qair_${yr2}.nc'
   gswpfile%Tair   ='/scratch/p66/ars599/CABLE3/gswp/system3/crujra_access_Tair_${yr2}.nc'
   gswpfile%wind   ='/scratch/p66/ars599/CABLE3/gswp/system3/crujra_access_Wind_${yr2}.nc'


```







cd name_luc/
 
