# This script will do a torsion scan for torsion 1 of MAA


# Create directory to hold minimization files for each rotamer

rm -rf rotamers
rm -rf rotamers_together

mkdir rotamers
mkdir rotamers_together

cp MAA.parm7 MAA.rst7 rotamers

cd rotamers

# Generate min files and launch minimization for each rotamer

curr_tors=0.0
other_tors=0.0

num_rotations=36

for((i=1; i<=$((num_rotations)); i+=1))
do
rm -rf rotamer_${i}
mkdir rotamer_${i}
cd rotamer_${i}

# Min file

cp ../MAA.parm7 ../MAA.rst7 .
echo -e "Minimize to torsion restraints
&cntrl
  imin=1,
  maxcyc=1000,
  ncyc=500,
  cut=999.0,
  ntb=0,
  igb=0,
  nmropt=1,
/
&wt
 type='END' &end
 LISTOUT=POUT
 DISANG=rotamer_${i}.rst" > min.in

# Torsion restraint file

echo -e "#Torsion 1 fixed at ${curr_tors}
&rst
iat=1,5,6,9,
r1=$(printf "%.1f" $(echo "$curr_tors - 5.0" | bc)), r2=$(printf "%.1f" $(echo "$curr_tors - 0.1" | bc)), r3=$(printf "%.1f" $(echo "$curr_tors + 0.1" | bc)), r4=$(printf "%.1f" $(echo "$curr_tors + 5.0" | bc)),
rk2=200.0, rk3=200.0,
&end

#Torsion 2 fixed at ${other_tors}
&rst
iat=5,6,9,11,
r1=$(printf "%.1f" $(echo "$other_tors - 5.0" | bc)), r2=$(printf "%.1f" $(echo "$other_tors - 0.1" | bc)), r3=$(printf "%.1f" $(echo "$other_tors + 0.1" | bc)), r4=$(printf "%.1f" $(echo "$other_tors + 5.0" | bc)),
rk2=200.0, rk3=200.0,
&end" > rotamer_${i}.rst

# Slurm submission script

echo -e "#!/bin/bash
#SBATCH -J MAA_rotamer_${i}
#SBATCH --get-user-env
#SBATCH --nodes=1

source /etc/profile.d/modules.sh

srun hostname -s | sort -u >slurm.hosts

sander -O -i min.in -o min.out -p MAA.parm7 -c MAA.rst7 -r min.rst7 -ref MAA.rst7

ambpdb -p MAA.parm7 -c min.rst7 > ../../rotamers_together/MAA_rot${i}.pdb" > submit.sh


# Submit job

sbatch submit.sh

# Increment the current torsion for next rotamer 

curr_tors=$(echo "$curr_tors + 10.0" | bc)



cd ../

done
