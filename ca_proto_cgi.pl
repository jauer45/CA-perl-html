#!c:\Strawberry\perl\bin\perl -w
# #!/usr/bin/perl -w

use strict;
use Data::Dumper;
use CGI;
use CGI::Carp 'fatalsToBrowser';
$CGI::POST_MAX=1024 * 100;  # max 100K posts
$CGI::DISABLE_UPLOADS = 1;  # no uploads


# POTENTIAL IDEAS Here: http://golly.sourceforge.net/

# Make $row x $col grid represented by 'x' and 'o's 
# In this case we set the first ROW then for() through the row cols where
# the next row data is determined by the last row data (we draw the rules)
# A text file is then generated and this is our pic. Later we use the rand()
# to generate the initial row. I know that the initial solution uses the
# infinie loop contruct for(;;) { ... last; ... }

# Grid best at a multiple of 3 x multiple of 3 (60)
# (Interesting affect when : ('||<' => '>')
#
my $rule_list_byte = [  '<', '>', '|' ];


my $q = new CGI;
my $pic = '';
my $highlighted_pic = '';

sub init($)
{
	my $q = shift || undef;

	my( $td_bgcolour, $td_bgcolour1, $td_bgcolour2, $td_bgcolour3, $td_bgcolour_other);
	my( $row_length, $x, $y, $filler, $filler1, $filler2 );
	my ($outfile, $htmlfile);

	my ($td_highlight1, $td_highlight2, $td_highlight3, $td_highlight4);

	my $list_ref = [];
	my $rule_list = [];
	my $highlight_rule_set = {};

	if( $q->param('begin_ca') eq 'y') 
	{
		$td_bgcolour = $q->param('bg_colour');
		$td_bgcolour1 = $q->param('td_bgcolour1');
		$td_bgcolour2 = $q->param('td_bgcolour2');
		$td_bgcolour3 = $q->param('td_bgcolour3');
		$td_bgcolour_other = $q->param('td_bgcolour_other'); 

		$row_length = $q->param('row_length'); 
		$x = $q->param('x_axis');
		$y = $q->param('y_axis'); 

		$filler = $q->param('filler');
		$filler1 = $q->param('filler1');
		$filler2 = $q->param('filler2');

		$outfile = $q->param('raw_file');
		$htmlfile = $q->param('www_file');

		my @list_ref = $q->param('list_ref');
		$list_ref = \@list_ref;

		my @rule_list = $q->param('rule_list');
		$rule_list = @rule_list;
		
	}
	elsif( $q->param('begin_ca') eq 'n' )
	{
		main_www($q);
	}
	else
	{
		$td_bgcolour = '#BFBFBF';
		$td_bgcolour1 = '#000000';
		$td_bgcolour2 = '#7A7A7A';
		$td_bgcolour3 = '#4F4F4F';
		$td_bgcolour_other = '#FFFFFF';

		$row_length = 10;
		$x = '30';
		$y = '30';

		$filler = 'OOO';
		$filler1 = 'OO';
		$filler2 = 'O';

		# Just edit this section to add and remove certain pattern sets
		$list_ref = [
			'<<<','|<<','<|<','<<|','|||','|<|','<||','||<',
			'|>|','>>>','||>','>||','>>|','>|>','<>>', '<><',
			'><|','|><','<>|','|<>','<|>','>|<','><>','<<>'
		];
		$rule_list =
		{
			'<<<' => '|', '|<<' => '|','<|<' => '|','<<|' => '|','|||' => '|','|<|' => '|','<||' => '|','||<' => '|',
			'|>|' => '>','>>>' => '>','||>' => '>','>||' => '>','>>|' => '>','>|>' => '>','<>>' => '>','<><' => '>',
			'><|' => '>','|><' => '>','<>|' => '<','|<>' => '<','<|>' => '<','>|<' => '<', '><>' => '>','<<>' => '>'
		};

		$highlight_rule_set =
		{
			'|><|'  => '<td bgcolor="' . $td_highlight1 . '" width="5" height="5">&nbsp;</td>',
			'<<>>'  => '<td bgcolor="' . $td_highlight2 . '" width="5" height="5">&nbsp;</td>',
			'<|>|'  => '<td bgcolor="' . $td_highlight3 . '" width="5" height="5">&nbsp;</td>',
			'<||>'  => '<td bgcolor="' . $td_highlight4 . '" width="5" height="5">&nbsp;</td>',
		};

		$outfile = './ca_outfile';
		$htmlfile = './ca.htm';
	}
	

	# ORIG COLOUR SCHEME
	#my $bg_colour = '#4F4F4F';
	#my $td_bgcolour1 = '#000000';
	#my $td_bgcolour2 = '#BFBFBF';
	#my $td_bgcolour3 = '#7A7A7A';
	#my $td_bgcolour_other = '#FFFFFF';

	return($td_bgcolour, $td_bgcolour1, $td_bgcolour2, $td_bgcolour3, $td_bgcolour_other, 
		$row_length, $x, $y, $filler, $filler1, $filler2,
		$list_ref, $rule_list, $outfile, $htmlfile);
}



# This would be done 20 times (3 x 20 = 60)
# There are 8 combinations so we set random to be 0-8 (now set to $list_ref length
#
# INTERESTING BEHAVIOUR : have a 1/3 symmetry by not including *3
#
sub start_draw($$)
{
	my $row_length = shift;
	my $list_ref = shift;
	print "ROW LENGTH : $row_length \n";

	my $row = '';
	#for(my $i = 0; $i == ($row_length * 3); $i++ )
	for(my $i = 0; $i < ($row_length * 4); $i++ )
	{
		my $init_row_list = int(rand( scalar @{ $list_ref } ));
		$row .= $list_ref->[$init_row_list];
		print "START DRAW (1st ROW: [$i] $row) \n";
	}

	#$pic .= $row;

	return $row;
}

# This would be done 60 times
sub draw_row($$$$$$$$$$$$)
{
        my $row_length = shift;
	my $x = shift;
	my $y = shift;
	my $filler = shift;
	my $filler1 = shift;
	my $filler2 = shift;
        my $list_ref = shift;
	my $rule_list = shift;
	my $outfile = shift;
	my $htmlfile = shift;

	my $last_row = shift;
	my $line_counter = shift;

	my @line = ();

	# for(my $i = 0; $i == ($x * 3); $i++ )
	for(my $i = 0; $i < ($x * 4); $i++ )
	{
		my $key = substr($last_row, $i, 3);

		my ($key0, $key1, $key2) = split //, $key;
		#print "KEY VAL: $key0, $key1, $key2 \n";

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
			$val = $rule_list->{$key};
			#print "ALL IS FINE \n";
		}

		push @line, $val;
	}

	my $new_row = '';
	print "NEW ROW (LINECOUNT: " . scalar @line . ") \n";

	#for(my $j = 0; $j == scalar @line; $j++)
	for(my $j = 0; $j < scalar @line; $j++)
	{
		#print "NEW ROW (LINE: " . $line[$j] . "\n";
		my ($val0, $val1) = split //, $line[$j];
		
		#$new_row .= $line[$j];
		if(! $val0 ) { $val0 = '<'; }
		#print "NEW ROW (LINE: " . $val0 . "\n";

		$new_row .= $val0;
	}
	
	#print "-- NEW ROW $new_row -- \n";
	$pic .= $new_row . "\n";

	$line_counter = $line_counter + 1;

	if( $line_counter <= $y ) 
	{ 
               	draw_row($row_length, $x, $y, $filler, $filler1, $filler2,
                	$list_ref, $rule_list, $outfile, $htmlfile,
			$new_row, $line_counter); 
	}
	else 
	{ 
		return; 
	}
}

sub image_enhance()
{
}

# Looks at a given grouping rule_set to reset_image (colouring)
# This is a way to enhance and view some disting patterning in the image
# 
sub www_image_enhance($$$$$$$$$$$$$$)
{
	my $filler = shift; 
	my $filler1 = shift;
	my $filler2 = shift;
	my $list_ref = shift;
	my $rule_list = shift;

	my $i = shift;
	my $x = shift;
	my $y = shift;
	my $last_row = shift;
	my $row_length = shift;
	my $line_counter = shift;

	my $img_file = shift;
	my $outfile = shift;
	my $htmlfile = shift;

	# Ruleset (we fill the middle two chars with the highlight (and keep the outer 2 colours the same!!))
	# This is the file that will created to "overwrite" the existing "rendered" HTML "imaged" pic.
	#my $tmp_img_file = $img_file . '_new.tmp';
	#my $highlight_key = substr($last_row, $i, 4);
	# if( $rule_set->{$highlist_key} ) { ... }

	open( IMGFILE, "< $img_file " ) or warn "$! $img_file \n";
	my @y = <IMGFILE>;
	while( my $line = <IMGFILE> )
	{
		my @x = split(//, $line ); # scalar @line

		my $key = substr($last_row, $i, 4);
	
		my $new_row = '';	
		for(my $j = 0; $j < scalar @x; $j++)
        	{
			my ($val0, $val1) = split //, $x[$j];

			if(! $val0 ) { $val0 = '<'; }
			#print "NEW ROW (LINE: " . $val0 . "\n";
			$new_row .= $val0;
		}
           
		#print "-- NEW ROW $new_row -- \n";
		$highlighted_pic .= $new_row . "\n";

		$line_counter = $line_counter + 1;

		if( $line_counter <= $y )
		{
			draw_row($row_length, $x, $y, $filler, $filler1, $filler2, 
				$list_ref, $rule_list, $outfile, $htmlfile, 
				$new_row, $line_counter);
		}
		else
		{
			return;
		}
                
        }
	close( IMGFILE );

	# We now have @x and @y

}

sub highlighted_outfile($$$$)
{
	my $html_highlight_file = shift;
	my $bg_colour = shift;
	my $td_bgcolour1 = shift;
	my $highlighted_pic = shift;

	open( HTMLFILE, "> $html_highlight_file") or warn "$! $html_highlight_file \n";
		print HTMLFILE '<body bgcolor="' . $bg_colour . '"><table cellspacing=0 cellpadding=0 border=2 bordercolor="' . $td_bgcolour1 . '" >' . "\n";
		print HTMLFILE $highlighted_pic . "\n";
		print HTMLFILE '</table></body>';
	close( HTMLFILE );
}

sub outfile($$$$$$$)
{
	my $bg_colour = shift; 
	my $td_bgcolour1 = shift;
	my $td_bgcolour2 = shift;
	my $td_bgcolour3 = shift;
	my $td_bgcolour_other = shift;	
	
	my $outfile = shift;
	my $htmlfile = shift;

	open( OUTFILE, "> $outfile " ) or warn "$! $outfile \n";
		print OUTFILE $pic;
	close( OUTFILE );


	open( OUTFILE, "< $outfile" ) or warn "$! $outfile \n";
		my @list = <OUTFILE>;
	close( OUTFILE );


	open( HTMLFILE, "> $htmlfile") or warn "$! $htmlfile \n";
	flock(HTMLFILE, 2);

	print HTMLFILE '<body bgcolor="' . $bg_colour . '"><table cellspacing=0 cellpadding=0 border=2 bordercolor="' . $td_bgcolour1 . '" >' . "\n";

	for(my $i = 0; $i < scalar @list; $i++)
	{
		my @chars = split( //, $list[$i]);

		print HTMLFILE '<tr cellspacing=0 cellpadding=0>' . "\n";

		my $data = set_outfile_standard_line($bg_colour,$td_bgcolour1,$td_bgcolour2,$td_bgcolour3,$td_bgcolour_other,@chars);
		#my $nu_data = set_outfile_highlight_line($data, @chars);

		print HTMLFILE $data;

		print HTMLFILE '</tr>' . "\n";
	}
	print HTMLFILE '</table></body>';
	close( HTMLFILE );
}

# sets the HTML 
sub set_outfile_standard_line($$$$@)
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

# sets the HTML if grouping pattern matches ruleset key
sub set_outfile_highlight_line($$$$$@)
{
	my $bg_colour = shift;
        my $td_bgcolour1 = shift;
        my $td_bgcolour2 = shift;
        my $td_bgcolour3 = shift;
        my $td_bgcolour_other = shift;
        my @chars = shift;

        for(my $j = 0; $j < scalar @chars; $j++ )
        {
		#my $highlight_key = substr($last_row, $i, 4);
		# if( $rule_set->{$highlist_key} ) { ... }

                if ( $chars[$j] eq '<')
                {
                        print HTMLFILE "\t" . '<td bgcolor="' . $td_bgcolour1 . '" width="5" height="5">&nbsp;</td>' . "\n";
                }
                elsif( $chars[$j] eq '|' )
                {
                        print HTMLFILE "\t" . '<td bgcolor="' . $td_bgcolour2 . '" width="5" height="5">&nbsp;</td>' . "\n";
                }
                elsif( $chars[$j] eq '>' )
                {
                        print HTMLFILE "\t" . '<td bgcolor="' . $td_bgcolour3 . '" width="5" height="5">&nbsp;</td>' . "\n";
                }
                else
                {
                        print HTMLFILE "\t" . '<td bgcolor="' . $td_bgcolour_other . '" width="5" height="5">&nbsp;</td>' . "\n";
                }
        }
}

sub main_www($)
{
	$q = shift;

	print $q->header( -text       => 'text/html' );
			# -cookie     => $cookie,
			# -charset    => 'Shift_JIS' );

	
	print $q->start_html;
	print $q->start_form("POST", "./ca_proto.pl");

	print $q->textfield(-name	=>'td_bgcolour',
			-default	=>'starting value',
			-size		=> 25,
			-maxlength	=>10);
	print $q->br;
	print $q->textfield(-name   =>'td_bgcolour1',
                                -default=>'starting value',
                                -size   =>25,
                                -maxlength=>10);
	print $q->br;
	print $q->textfield(-name   =>'td_bgcolour2',
                                -default=>'starting value',
                                -size   =>25,
                                -maxlength=>10);
	print $q->br;
	print $q->textfield(-name   =>'td_bgcolour3',
                                -default=>'starting value',
                                -size   =>25,
                                -maxlength=>10);
	print $q->br;
	print $q->textfield(-name   =>'td_bgcolour_other',
                                -default=>'starting value',
                                -size   =>25,
                                -maxlength=>10);
	print $q->br;
	print $q->br;
	print $q->textfield(-name   => 'row_no',
                                -default => 'starting value',
                                -size   => 25,
                                -maxlength => 10);
	print $q->br;
	print $q->textfield(-name   => 'x_axis',
                                -default => 'starting value',
                                -size   =>25,
                                -maxlength => 10);
	print $q->br;
	print $q->textfield(-name   =>'y_axis',
                                -default =>'starting value',
                                -size   => 25,
                                -maxlength => 10);
	print $q->br;
	print $q->br;
	print $q->textfield(-name   =>'filler',
                                -default=>'starting value',
                                -size   => 25,
                                -maxlength =>10);
	print $q->br;
	print $q->textfield(-name   =>'filler1',
                                -default =>'starting value',
                                -size   => 25,
                                -maxlength =>10);
	print $q->br;
	print $q->textfield(-name   =>'filler2',
                                -default =>'starting value',
                                -size   => 25,
				-maxlength =>10);
	print $q->br;
	print $q->br;
	print $q->checkbox_group(-name=>'list_ref',
                                -values	=> [
						'<<<','|<<','<|<','<<|','|||','|<|','<||','||<',
						'|>|','>>>','||>','>||','>>|','>|>'
					],
	                        -linebreak=>'true');
	                        #-labels=>\%labels);
	print $q->br;
	print $q->br;
	print $q->checkbox_group(-name=>'rule_set',
                                -values => [
			'<<<' => '|', '|<<' => '>', '<|<' => '<', '<<|' => '|', '|||' => '>', '|<|' => '>', '<||' => '|', '||<' => '>',
			'|>|' => '<','>>>' => '|','||>' => '>','>||' => '<','>>|' => '|','>|>' => '<'
					],
				-default => [
			'<<<' => '|', '|<<' => '>', '<|<' => '<', '<<|' => '|', '|||' => '>', '|<|' => '>', '<||' => '|', '||<' => '>',
			'|>|' => '<','>>>' => '|','||>' => '>','>||' => '<','>>|' => '|','>|>' => '<'
					],
				-linebreak=>'true');
				#-labels=>\%labels);

	print $q->hidden( -name =>'begin_ca', -default => 'y');

	print $q->submit( -name	=> 'Submit' );

	print $q->end_form();
	print $q->stop_html;	
}


my ($td_colour, $td_colour1, $td_colour2, $td_colour3, $td_bgcolour_other,
	$row_length, $x, $y, $filler, $filler1, $filler2,
	$list_ref, $rule_list, $outfile, $htmlfile) = init($q);

my $start_row = start_draw($row_length, $list_ref);

#print "START: $start_row \n";
#draw_row($start_row, 0);

draw_row($row_length, $x, $y, $filler, $filler1, $filler2,
	$list_ref, $rule_list, $outfile, $htmlfile, $start_row, 0);


outfile($td_colour, $td_colour1, $td_colour2, $td_colour3, $td_bgcolour_other, $outfile, $htmlfile);

