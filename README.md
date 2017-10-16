Author: Joseph Auer
Brief : 1-D CA like generator Perl script
About :


	Perl script that generates simple 1-D cellular automota patterns in ASCI and HTML. Can be used on command line or as a service/cron command, (like crontab).

	It's  been awhile back now but it has been tested with success on the following OS: Fedora 8.7 (and greater), Windows (XP, Win7) where Apache has been greater than 1.2 and perl version has been above 5.6. as well as Window's Straberry Perl, (initial release version and current 2.7 version), and ActiveState Perl (forget which versions but quite old).



Usage : $ ./ca_proto-v04.pl '<' '[' '>' 14 'grey' 'black' '-' '-' '-'
	  1) '<' and '>' represent ON and OFF state and '[' and 
	  represents a variant to make things look more visually 
	  interesting.
	  2) 14 represents the pattern type (from pattern types 0 - 23).
	  3) Colour assignment for ON and OFF state.
	  4) Filler area pattern assignment for unset pattern children.
	     Represented by 3 vars of type.


Output Files : 
	ASCII version : ./ca_outfile
	HTML version  : ./ca_outfile.html 


