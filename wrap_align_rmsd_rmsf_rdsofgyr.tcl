set filelist [glob *.psf]
set sortedfilelist [lsort -dictionary $filelist]

foreach file $sortedfilelist {

set filewhext [file rootname $file]
set outfile [open {$filelist}_rmsd.dat w]
set outfile2 [open {$filelist}_rmsf.dat w]
set outfile3 [open {$filelist}_gyration.dat w]

#LOAD dcd
mol new $file type psf 
mol addfile ${filewhext}.dcd last -1 waitfor all
set strmolid [molinfo top]

# Gather Frame Info
set nFrames [molinfo top get numframes]
puts [format "Reading %i frames." $nFrames]

#Wrap the trajectory
pbc wrap -center com -centersel "protein" -compound fragment -all

#ALIGN
for {set f 0 } {$f <= $nFrames } {incr f 1} {
                 molinfo top set frame $f
                 $sel frame $f
                 $all frame $f
		         set trans_mat [measure fit $sel $ref]
		         $all move $trans_mat
}

#RMSD
set reference [atomselect top "backbone"]
for {set f 0 } {$f < $nFrames} {incr f} {
		set selection [atomselect top "backbone" frame $f]
		set c [measure rmsd $reference $selection]
		puts $outfile [format "%8d %8f" $f $c]
}

close $outfile
#RMSF

set sel [atomselect top all]
set sel0 [$sel num]
set sel [atomselect top "resid 1 to $sel0 and name CA"]

set stepsize 5

set nFrames2 [expr $nFrames - 1]

puts $outfile2 "Residue \t RMSF"

for {set i 0} {$i < [$sel num]} {incr i} { 
     set rmsf [measure rmsf $sel first 1 last $nFrames2 step $stepsize] 
     puts $outfile2 "[expr {$i+1}] \t [lindex $rmsf $i]" 
}

close $outfile2
#Radius of Gyration

for {set f 0 } {$f < $nFrames} {incr f} {
		set selection [atomselect top protein frame $f]
		set a [measure rgry $selection]
		puts $outfile3 [format "%8d %8f" $f $a]
}

close $outfile3
mol delete all

}
