#!/usr/bin/perl
use warnings;
use strict;
use List::Util qw(sum);
use GD::Graph::bars;
use Text::TabularDisplay;

# Author: Frank Jenkins
# Monte Carlo Method
# Consider a single atom with a potential energy E(x)=k(c)x^2, where x = the atoms coordinate and k(c) = 0.1 (a constant)
# This Monte Carlo program computes the average energy at temperatures between 0.1 and 1.0

# Variable assignments

my @energy = ();
my @avg_e = ();
my @e_new = ();
my @e_old = ();
my @counter = ();
my $temp = 0.1;
my $i = 0;
my $p = 1;
my @x = ();
my @a = ();
my @b = ();

my @y = (0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0);


while ($i < 10) {
	# the outer while loop restricts the number of average energy readings that will be included in our final table to ten	
	my $dx = rand(10);
	# generate initial random structure
	$x[$i] = 2*$dx*(rand(1) - 0.5);	
	# compute energy
	$energy[$i] = 0.1*$x[$i]**2;	
	# compute the energy of a new conformation
	$e_new[$i] = $energy[$i];
	
	$e_old[$i] = $energy[$i-1];
	
	$avg_e[$i] = 0;
	
	$avg_e[$i] = ($energy[$i] + $avg_e[$i])/($i+1);
	
	$a[$i] = .9*($temp/2);
	$b[$i] = 1.1*($temp/2);
	
	
	
	if ($i lt 1 and $e_new[$i] le $e_old[$i] and $avg_e[$i] ge $a[$i] and $avg_e[$i] le $b[$i]) {
		# This loop is used to generate our first average energy computation
		$e_old[$i] = 0.1*$x[$i]**2;
		$energy[$i] = $e_new[$i];
		$temp = $temp + 0.1;
		$counter[$i] = $p;
		$i++;
		
	}
	
	elsif ($e_new[$i] le $e_old[$i] and $avg_e[$i] ge $a[$i] and $avg_e[$i] le $b[$i]) {
		# If the loop fails to meet the above enumerated conditions, restore initial energy value 
		$energy[$i] = $e_new[$i];
		$temp = $temp + 0.1;
		$counter[$i] = $p;
		$i++;
		
	}
	
	elsif ($i lt 1 and rand(1) lt exp(-($e_new[$i] - $e_old[$i]))/$temp and $avg_e[$i] ge $a[$i] and $avg_e[$i] le $b[$i]) {
		# else, update energy values and while loop counter 
		$e_old[$i] = 0.1*$x[$i]**2;
		$energy[$i] = $e_new[$i];
		$temp = $temp + 0.1;
		$counter[$i] = $p;
		$i++;
		
	}
		
	elsif (rand(1) lt exp(-($e_new[$i] - $e_old[$i]))/$temp and $avg_e[$i] ge $a[$i] and $avg_e[$i] le $b[$i]) {
		# moving beyond the first avg. energy computation, accept the updated energy value if the aforementioned conditions are met
		$energy[$i] = $e_new[$i];
		$temp = $temp + 0.1;
		$counter[$i] = $p;
		$i++;
		
	}
	
		
	else {
		# else, restore energy to old energy and increment the iteration per avg. energy computation by one
		$energy[$i] = $e_old[$i];
		$p++;	
	
	}
	
		# increment the iteration counter by one and update energy 
		$p++;
		$x[$i] = $x[$i-1] + 2*$dx*(rand(1) - 0.5);	
		#$avg_e[$i] = $avg_e[$i]/($i+1);



}

# create plot that prints to png file  
my @data = (\@avg_e, \@y);
my $graph = GD::Graph::bars->new(500, 500);

$graph->set( x_label=>'Average Energy', y_label=>'Temperature', 
title=>'Monte Carlo Simulation') or warn $graph->error;

my $image = $graph->plot(\@data) or die $graph->error;

my $file = 'mcmc2.png';
open(my $img, '>', $file) or die "Cannot open mcmc2.png\n";
binmode $img;

print $img $image->png;
close $img;

# create table that prints to command line screen, showing avg. energy, number of iterations, and temperature 

my $table = Text::TabularDisplay->new;
$table->add($avg_e[0], $y[0], $counter[0]);
$table->add($avg_e[1], $y[1], $counter[1]-$counter[0]);
$table->add($avg_e[2], $y[2], $counter[2]-$counter[1]);
$table->add($avg_e[3], $y[3], $counter[3]-$counter[2]);
$table->add($avg_e[4], $y[4], $counter[4]-$counter[3]);
$table->add($avg_e[5], $y[5], $counter[5]-$counter[4]);
$table->add($avg_e[6], $y[6], $counter[6]-$counter[5]);
$table->add($avg_e[7], $y[7], $counter[7]-$counter[6]);
$table->add($avg_e[8], $y[8], $counter[8]-$counter[7]);
$table->add($avg_e[9], $y[9], $counter[9]-$counter[8]);
$table->columns(qw<Average_Energy Temperature Number_Iterations>);
print $table->render;



#print join("\n", @avg_e), "\n\n";
#print join("\t", @counter), "\n";








	
	