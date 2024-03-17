set outfile [open water_count_wt.dat w]


for {set i 0} {$i < 1051} {incr i} {
	set sel [atomselect top "water within 5	of protein and resid 69 and name CG" frame $i]
	set a [$sel num]
	puts $outfile $a
	
}

close $outfile