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
   filename%soil = '/scratch/p66/ars599/CABLE3/trendy10_inputs/def_soil_params.txt'
   vegparmnew = .TRUE.  ! using new format when true
   soilparmnew = .TRUE.  ! using new format when true
   spinup = .FALSE.
   delsoilM = 0.001   ! allowed variation in soil moisture for spin up
   delsoilT = 0.01    ! allowed variation in soil temperature for spin up
   output%restart = .TRUE.  ! should a restart file be created?
   output%met = .TRUE.  ! input met data
   output%flux = .TRUE.  ! convective, runoff, NEE
   output%soil = .TRUE.  ! soil states
   output%snow = .TRUE.  ! snow states
   output%radiation = .TRUE.  ! net rad, albedo
   output%carbon = .TRUE.  ! NEE, GPP, NPP, stores
   output%veg = .TRUE.  ! vegetation states
   output%params = .TRUE.  ! input parameters used to produce run
   output%patch     = .TRUE.  ! write per patch
   output%balances = .TRUE.  ! energy and water balances
   check%ranges = .FALSE.  ! variable ranges, input and output
   check%energy_bal = .TRUE.  ! energy balance
   check%mass_bal = .TRUE.  ! water/mass balance
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
   casafile%cnpflux = 'cnpfluxOut.csv'
   ncciy = ${yr2}   ! 0 for not using gswp
   redistrb = .FALSE.  ! Turn on/off the hydraulic redistribution
   wiltParam = 0.5
   satuParam = 0.8
   cable_user%FWSOIL_SWITCH = 'standard'
                                                 ! 1. standard 
                                                 ! 2. non-linear extrapolation 
                                                 ! 3. Lai and Ktaul 2000 
   cable_user%DIAG_SOIL_RESP = 'ON ' 
   cable_user%LEAF_RESPIRATION = 'ON ' 
   cable_user%RUN_DIAG_LEVEL = 'BASIC'        ! choices are: 
                                                 ! 1. BASIC
                                                 ! 1. NONE
   cable_user%CONSISTENCY_CHECK = .TRUE.      ! TRUE outputs combined fluxes at each timestep for comparisson to A control run 
   cable_user%CASA_DUMP_READ = .FALSE.      ! TRUE reads CASA forcing from netcdf format
   cable_user%CASA_DUMP_WRITE = .FALSE.      ! TRUE outputs CASA forcing in netcdf format
   cable_user%SSNOW_POTEV = 'HDM'      ! Humidity Deficit Method
   gswpfile%mask = '/scratch/p66/ars599/CABLE3/inputs/landsea-access-esm.nc'
   output%averaging = 'monthly'
   cable_user%GS_SWITCH = 'medlyn'
   cable_user%GW_MODEL = .FALSE.
   cable_user%or_evap = .FALSE.
   cable_user%GSWP3 = .TRUE.
   cable_user%MetType = 'gswp'
   CABLE_USER%YearStart = 0
   CABLE_USER%YearEnd = 0
   cable_user%CASA_fromZero = .FALSE.
   CABLE_USER%soil_thermal_fix =.TRUE.
   CABLE_USER%PHENOLOGY_SWITCH='MODIS'
   CABLE_USER%CALL_POP=.FALSE.
   CABLE_USER%vcmax ='standard'
   cable_user%CALL_climate=.FALSE.
   cable_user%l_limit_labile=.TRUE.
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
&end
EOF
yr=`expr $yr + 1`
yr1=`expr $yr + 1`
yr2=`expr $yr2 + 1`
echo $yr
done