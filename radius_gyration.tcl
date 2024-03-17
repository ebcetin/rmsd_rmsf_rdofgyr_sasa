puts "how many trajectories: "
gets stdin nt

for {set j 0} {$j < $nt} {incr j} {

puts "Enter mutation name (lowercase): "
gets stdin a

mol load psf dhf-$a.psf
animate read dcd dhf-$a-s100-210ns.dcd waitfor all

	set nf [molinfo $j get numframes]
	set outfile [open rgyr_$a w]
	set outfile2 [open sasa_$a w]

		#wrapping
		
		pbc wrap -centersel "protein" -center com -compound fragment -all
		
		#aligning of protein
		for {set l 1} {$l < $nf} {incr l} {
	
			set sel1 [atomselect $j all frame $l]
			set sel2 [atomselect $j all frame $l+1]
			set transformation_matrix [measure fit $sel1 $sel2]
			set move_sel [atomselect $j "all"]
			$move_sel move $transformation_matrix
	
		}
		
		
		set a [atomselect $j "resname DHF and name C6"]
		set b [atomselect $j "resname NDPH and name NC4"]
		
		set n [$a get index]
		set m [$b get index]

		for {set i 0} {$i < $nf} {incr i} {

			set sel [atomselect $j "protein and resid 1 to 48" frame $i]
			set a [measure rgyr $sel]
			set b [measure sasa 5 $sel]

			puts $outfile [format "%8d %8f" $i $a]
			puts $outfile2 [format "%8d %8f" $i $b]

		}

	close $outfile
	close $outfile2

}