set outfile [open d27e_cry_sasa.txt w]
mol load psf dhf-d27e.psf
animate read dcd dhf-d27e-s100-210ns.dcd waitfor all

set sel [atomselect top "protein and resid 52"]
set sel2 [atomselect top "protein and resid 55"]
set sel3 [atomselect top "protein and resid 59"]
set sel4 [atomselect top "protein and resid 63"]
set sel5 [atomselect top "protein and resid 64"]
set sel6 [atomselect top "protein and resid 69"]
set sel7 [atomselect top "protein and resid 71"]
set sel8 [atomselect top "protein and resid 72"]

set protein [atomselect top protein]
set nf [molinfo top get numframes]

for { set i 0 } { $i <= $nf } { incr i } {
	$protein frame $i
	$sel frame $i
	$sel2 frame $i
	$sel3 frame $i
	$sel4 frame $i 
	$sel5 frame $i 
	$sel6 frame $i 
	$sel7 frame $i
	$sel8 frame $i 
	
# with restrict, only solvent-accessible points near that selection $sel will be considered.
	set sasa [measure sasa 1.4 $protein -restrict $sel]
	set sasa2 [measure sasa 1.4 $protein -restrict $sel2]
	set sasa3 [measure sasa 1.4 $protein -restrict $sel3]
	set sasa4 [measure sasa 1.4 $protein -restrict $sel4]
	set sasa5 [measure sasa 1.4 $protein -restrict $sel5]
	set sasa6 [measure sasa 1.4 $protein -restrict $sel6]
	set sasa7 [measure sasa 1.4 $protein -restrict $sel7]
	set sasa8 [measure sasa 1.4 $protein -restrict $sel8]
	#puts "$i $sasa $sasa2 $sasa3 $sasa4 $sasa5 $sasa6 $sasa7"
	#set sasa_tot [expr $sasa+$sasa2+$sasa3]
	puts $outfile [format "%8d %8f %8f %8f %8f %8f %8f %8f %8f" $i $sasa $sasa2 $sasa3 $sasa4 $sasa5 $sasa6 $sasa7 $sasa8]
}
close $outfile

#unset variables 
$sel delete; unset sel
$sel2 delete; unset sel2
$sel3 delete; unset sel3
$sel4 delete; unset sel4
$sel5 delete; unset sel5
$sel6 delete; unset sel6
$sel7 delete; unset sel7
$sel8 delete; unset sel8

$protein delete; unset protein 




