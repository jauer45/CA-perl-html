#!/usr/bin/perl -w

# Good HTML colour HEX chart: http://html-color-codes.com/
#

use strict;
use Data::Dumper;


my $pic = '';
my $highlighted_pic = '';


#---------------- GRID ---------------------------
# $row_length = 10; $x = '30'; $y = '30';
sub set_grid()
{
	my $row_length = 30;
        my $x = '30';
        my $y = '30';

	# This is our issue -> border essetially needs to be another pattern element set 
        # my $filler = 'OOO';
        # my $filler1 = 'OO';
        # my $filler2 = 'O';

	#return ($row_length, $x, $y, $filler, $filler1, $filler2);
	return ($row_length, $x, $y);
}

sub set_filler($)
{
	my $filler = shift;

	my $filler1 = $filler x 3;
	my $filler2 = $filler x 2;
	my $filler3 = $filler;

	return ($filler1, $filler2, $filler3);	
}

#---------------- HTML ---------------------------

sub set_html_colour($)
{
	my $colour  = shift;

	my ($td_bgcolour, $td_bgcolour1, $td_bgcolour2, $td_bgcolour3, $td_bgcolour_other );

	if ($colour =~ /grey/ )	
	{
		$td_bgcolour = '#CCCCCC';
        	$td_bgcolour1 = '#333333';
        	$td_bgcolour2 = '#666666';
        	$td_bgcolour3 = '#999999';
        	$td_bgcolour_other = '#FFFFFF';	
	}

	if ($colour =~ /yellow/)
	{
		$td_bgcolour = '#CCCC00';
                $td_bgcolour1 = '#CCCC33';
                $td_bgcolour2 = '#CCCC66';
                $td_bgcolour3 = '#CCCC99';
                $td_bgcolour_other = '#FFFF99';
	}

	if($colour =~ /orange/)
	{
		$td_bgcolour = '#FFCC00';
                $td_bgcolour1 = '#FFCC33';
                $td_bgcolour2 = '#FFCC66';
                $td_bgcolour3 = '#FF9900';
                $td_bgcolour_other = '#FF6600';
	}

	if($colour =~ /blue/)
	{
		$td_bgcolour = '#99CCCC';
                $td_bgcolour1 = '#669999';
                $td_bgcolour2 = '#336666';
                $td_bgcolour3 = '#003333';
                $td_bgcolour_other = '#006666';
	}
	
	if($colour =~ /violet/)
	{
		$td_bgcolour = '#CC99CC';
                $td_bgcolour1 = '#996699';
                $td_bgcolour2 = '#993399';
                $td_bgcolour3 = '#663366';
                $td_bgcolour_other = '#660066';
	}

	return ($td_bgcolour, $td_bgcolour1, $td_bgcolour2, $td_bgcolour3, $td_bgcolour_other);
}

#--------------- MAIN ------------------------

sub set_list_ref($$$)
{

        my $frst_elem = shift;
        my $scnd_elem = shift;
        my $last_elem = shift;

        my $list_ref = [];

	push @{ $list_ref },  $frst_elem . $frst_elem . $frst_elem;
	push @{ $list_ref },  $frst_elem . $scnd_elem . $last_elem;
	push @{ $list_ref },  $frst_elem . $last_elem . $scnd_elem;
	push @{ $list_ref },  $frst_elem . $last_elem . $frst_elem;
	push @{ $list_ref },  $frst_elem . $scnd_elem . $scnd_elem;
	push @{ $list_ref },  $frst_elem . $last_elem . $last_elem;
	push @{ $list_ref },  $frst_elem . $frst_elem . $last_elem;
	push @{ $list_ref },  $frst_elem . $frst_elem . $scnd_elem;
	push @{ $list_ref },  $frst_elem . $scnd_elem . $frst_elem;

	push @{ $list_ref },  $scnd_elem . $scnd_elem . $scnd_elem;
	push @{ $list_ref },  $scnd_elem . $scnd_elem . $last_elem;
	push @{ $list_ref },  $scnd_elem . $last_elem . $frst_elem;
	push @{ $list_ref },  $scnd_elem . $last_elem . $scnd_elem;
	push @{ $list_ref },  $scnd_elem . $scnd_elem . $frst_elem;
	push @{ $list_ref },  $scnd_elem . $last_elem . $last_elem;
	push @{ $list_ref },  $scnd_elem . $frst_elem . $last_elem;
	push @{ $list_ref },  $scnd_elem . $frst_elem . $scnd_elem;
	push @{ $list_ref },  $scnd_elem . $frst_elem . $frst_elem;

	push @{ $list_ref },  $last_elem . $last_elem . $last_elem;
	push @{ $list_ref },  $last_elem . $scnd_elem . $last_elem;
	push @{ $list_ref },  $last_elem . $last_elem . $scnd_elem;
	push @{ $list_ref },  $last_elem . $scnd_elem . $frst_elem;
	push @{ $list_ref },  $last_elem . $scnd_elem . $scnd_elem;
	push @{ $list_ref },  $last_elem . $last_elem . $frst_elem;
	push @{ $list_ref },  $last_elem . $frst_elem . $last_elem;
	push @{ $list_ref },  $last_elem . $frst_elem . $scnd_elem;
	push @{ $list_ref },  $last_elem . $frst_elem . $frst_elem;

        return ($list_ref);
}

sub set_ruleset($$)
{
	my $rand_list = shift;
	my $list_ref = shift;
	my $ruleset = {};

	for(my $i = 0; $i < scalar @{ $list_ref }; $i++ )
	{
		# print  @{ $list_ref }->[$i] . "\n";
		# $ruleset->{ @{ $list_ref }->[$i] } = @{ $rand_list }->[ int(rand( scalar @{ $rand_list } )) ];
		$ruleset->{ $list_ref->[$i] } = $rand_list->[ int(rand( scalar @{ $rand_list } )) ];	
	}

	return ($ruleset);
}


#-------------------------------- DRAW GRID ------------------------------------------------
#
sub start_draw($$)
{
        my $row_length = shift;
        my $list_ref = shift;

        print "ROW LENGTH \: $row_length \n";

        my $row = '';

	for(my $i = 0; $i <= $row_length; $i++ )
	{
		my $init_row_list = int( rand( scalar @{ $list_ref } ) );
		$row .= $list_ref->[$init_row_list];
		print "START DRAW \(1st ROW: \[$i\] $row\) \n";

	}

	return $row;

}


sub set_border($$$$$$$)
{
	my $key0 = shift;
	my $key1 = shift;
	my $key2 = shift;
	
	my $filler = shift;
	my $filler1 = shift;
	my $filler2 = shift;
	my $filler3 = shift;

	my $val;
	if(! $key0 )
	{
		$val = $filler;
		#print "FILLER (Should I consider you the end at char $i ($y) \n"; 
	}
	elsif( $key0 && !($key1) && !($key2) )
	{
		$val = $filler1;
		#print "FILLER1 \n";
	}
	elsif( $key0 && $key1 && !($key2) )
	{
		$val = $filler2;
		#print "FILLER2 \n";
	}
	else
	{
		$val = $filler3;
		#print "ALL IS FINE \n";
	}

	return $val;
	
}

sub draw_row($$$$$$$$$$$)
{
        my $row_length = shift;
        my $x = shift;
        my $y = shift;
        my $filler = shift;
        my $filler1 = shift;
        my $filler2 = shift;
        my $list_ref = shift;
        my $rule_list = shift;

        my $last_row = shift;
        my $line_counter = shift;

        my $element_filler = shift;

        my @line = ();

        for(my $i = 0; $i < ($x * 3); $i++ )
	{
		my $key = substr($last_row, $i, 3);
		print "\[$i\] KEY " . $key . "\n";
                my ($key0, $key1, $key2) = split //, $key;

		# set border
		#
		my $filler3 = $rule_list->{$key};
		print "FILLER 3 " . $filler3 . "\n";
		my $val = set_border($key0, $key1, $key2, $filler, $filler1, $filler2, $filler3);

		#print "VAL: " . $val . "\n";
		push @line, $val;
	}

	my $new_row = '';
        print "NEW ROW (LINECOUNT: " . scalar @line . "\) \n";

	
	for(my $j = 0; $j < scalar @line; $j++)
	{
		print scalar @line .  " \: NEW ROW (LINE \[$j\] : " . $line[$j] . "\n";
		my ($val0, $val1) = split (//, $line[$j]);

		if(! $val0 ) { $val0 = $element_filler; } # E.g. '<'
			#print "NEW ROW (LINE: " . $val0 . "\n";

		$new_row .= $val0;
	}

	$pic .= $new_row . "\n";

	# FROM HERE --- NEEDS MORE WORK ? INVESTIGATION
	#
        $line_counter = $line_counter + 1;

        if( $line_counter < $y )
        {
                draw_row($row_length, $x, $y, $filler, $filler1, $filler2,
                        $list_ref, $rule_list, $new_row, $line_counter, $element_filler);
        }
        else
        {
                return;
        }

}


#------------------- DRAW HTML GRID --------------------------------------------------------
#
sub set_outfile_standard_line($$$$$@)
{
        my $bg_colour = shift;
        my $td_bgcolour1 = shift;
        my $td_bgcolour2 = shift;
        my $td_bgcolour3 = shift;
        my $td_bgcolour_other = shift;
        my @chars = @_;

        my $data = '';


        for(my $j = 0; $j < scalar @chars; $j++ )
	{
                if ( $chars[$j] eq '<')
                {
                        $data .= "\t" . '<td bgcolor="' . $td_bgcolour1 . '" width="5" height="5">&nbsp;</td>' . "\n";
                }
                elsif( $chars[$j] eq '|' )
                {
                        $data .= "\t" . '<td bgcolor="' . $td_bgcolour2 . '" width="5" height="5">&nbsp;</td>' . "\n";
                }
                elsif( $chars[$j] eq '>' )
                {
                        $data .= "\t" . '<td bgcolor="' . $td_bgcolour3 . '" width="5" height="5">&nbsp;</td>' . "\n";
                }
                else
                {
                        $data .= "\t" . '<td bgcolor="' . $td_bgcolour_other . '" width="5" height="5">&nbsp;</td>' . "\n";
                }
        }

        return ($data);

}


#-------------------------------- OUTFILE --------------------------------------------------


# process out the CA file and CA HTML file

sub outfile($)
{
	my $outfile = shift;

	open( OUTFILE, "> $outfile " ) or warn "$! $outfile \n";
		print OUTFILE $pic;
	close( OUTFILE );

	return;
}

sub outfile_html($$$$$$$)
{
	my $outfile = shift;
	my $htmlfile = shift;

	my $td_bgcolour = shift;
	my $td_bgcolour1 = shift;
	my $td_bgcolour2 = shift;
	my $td_bgcolour3 = shift;
	my $td_bgcolour_other = shift;

	open( OUTFILE, "< $outfile" ) or warn "$! $outfile \n";
                my @list = <OUTFILE>;
        close( OUTFILE );


        open( HTMLFILE, "> $htmlfile") or warn "$! $htmlfile \n";
        flock(HTMLFILE, 2);

	print HTMLFILE '<body bgcolor="' . 
		$td_bgcolour . '"><table cellspacing=0 cellpadding=0 border=2 bordercolor="' . 
		$td_bgcolour1 . '" >' . "\n";


        for(my $i = 0; $i < scalar @list; $i++)
        {
                my @chars = split( //, $list[$i]);

                print HTMLFILE '<tr cellspacing=0 cellpadding=0>' . "\n";

                my $data = set_outfile_standard_line($td_bgcolour,$td_bgcolour1,$td_bgcolour2,$td_bgcolour3,$td_bgcolour_other,@chars);

		print HTMLFILE $data;

                print HTMLFILE '</tr>' . "\n";
        }
        print HTMLFILE '</table></body>';
        close( HTMLFILE );
}


## ------------------------------ BEGIN -----------------------------------------------------


if( $ARGV[0] && $ARGV[1] && $ARGV[2] && $ARGV[3] && $ARGV[4])
{
	my ($td_bgcolour, $td_bgcolour1, $td_bgcolour2, $td_bgcolour3, $td_bgcolour_other);

	my $rand_list 		= [$ARGV[0], $ARGV[1], $ARGV[2]];
	my $list_ref 		= set_list_ref($ARGV[0], $ARGV[1], $ARGV[2]);
	my $list_ref_highlight 	= $list_ref->[ $ARGV[3] ];
	my $ruleset_ref 	= set_ruleset($rand_list, $list_ref);


	# select according to colour grey, yellow and orange supported for now
	
	if( $ARGV[4] =~ m/grey|yellow|orange|blue|violet/ )
	{
		print "OK: ARGV4 is " . $ARGV[4] . "\n";
		($td_bgcolour, $td_bgcolour1, $td_bgcolour2, $td_bgcolour3, $td_bgcolour_other) = set_html_colour($ARGV[4]);
	}
	else
	{
		print "NG: ARGV4 is " . $ARGV[4] . "\n";
	}


	print "LIST REF: " . @{ scalar $list_ref } . "\n"; # Should be 24 (8*3) 
	print "HIGHLIGHT PATTERN: " . $list_ref_highlight . "\n";
	print Dumper($ruleset_ref) . "\n";
	#print Dumper($list_ref) . "\n";


	my $outfile = './ca_outfile';
        my $htmlfile = $outfile . '.htm';


	# Initialise Set GRID
	#
	my $rand_elem = int( rand( scalar @{ $rand_list } ) ) . "\n";
	my $filler_arg = $rand_list->[$rand_elem];

	my ($filler, $filler1, $filler2) = set_filler($filler_arg);
	print "FILLERS: $filler \, $filler1 \, $filler2 \n";
	my ($row_length, $x, $y) = set_grid();
	
	# Generate the Start GRID
	#
	my $start_row = start_draw($row_length, $list_ref);
	print $start_row . "\n";	


	# Generate the rest of the grid from the ruleset we have defined : $list_ref
	#
	draw_row( $row_length, $x, $y, $filler, $filler1, $filler2, $list_ref, $ruleset_ref, 
                $start_row, 0, int(rand( scalar @{ $rand_list } )) );

	outfile($outfile);
	outfile_html($outfile, $htmlfile, $td_bgcolour, $td_bgcolour1, $td_bgcolour2, $td_bgcolour3, $td_bgcolour_other);
}
else
{
	print 'Usage: $ perl test_ca2.pl \'|\' \']\' \'[\' 
		8 (select : 0-23) \'grey\' (grey, yellow, orange, blue, violet) 
		[OPTIONAL] : \'yellow\' (grey yellow orange, blue, violet) ' . "\n";
}




