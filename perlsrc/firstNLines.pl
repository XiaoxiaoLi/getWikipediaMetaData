#! usr/bin/perl -w

#get the first n lines in a file, for wikipedia dump, smaller dump for testing
#writes to the same place, output file name has more suffix indicating the number of lines

#to run: specify the input file route, and the number of lines

$input_file=$ARGV[0];#input file route
$n=$ARGV[1];#first n lines
$out_file=$input_file."_First".$n."Lines.xml";

open(IN,$input_file)or die "unable to open $input_file\n";
open(OUT,">".$out_file)or die "unable to write to $out_file\n";

$count=0;
while (<IN>){
  chomp;
  if ($count<$n){
    print OUT "$_\n";
    $count++;
  }
  else{
  	last;
  }
}

print OUT "</mediawiki>\n";#add mediawiki at the end of the file, for xml format

close IN;
close OUT;