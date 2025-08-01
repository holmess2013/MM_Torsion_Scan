# MM_Torsion_Scan

This bash script will automate a torsion scan in AMBER using the sander minimization algorithm with NMR-style torsion restraints. To use this program, the user must have already generated the parm7 and rst7 files for their molecule, and have it in their working directory. These are the only inputs needed. Additionally, the user should modify the script with the appropriate atom numbers so that the correct torsion is restrained to the correct value in each iteration. In this example, I am scanning one torsion in methoxyacetic acid while keeping the other restrained, to ensure that the torsion controlling the carboxylate rotation is constrained. This script can be used in developing torsion parameters for MD simulations. I have included example input files for methoxyacetic acid so the user may test this script. 

Also, this script assumes that each minimization is launched and managed via a SLURM job manager on a compute cluster. 
