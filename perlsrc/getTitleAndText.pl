#! usr/bin/perl -w
#input: a wikipedia dump, or a small portion of a wikipedia dump, has to have the wikipedia dump xml format
#output: a file, each line is a wikipedia page, title, category info, and main text, seperated by '-XIAO-', each category is seperated by a space

#to run: specify the input file route

#use the module Parse::MediaWikiDump
#Prerequisite, has to have installed this module http://en.wikipedia.org/wiki/Wikipedia:Computer_help_desk/ParseMediaWikiDump
use Parse::MediaWikiDump;
use strict;
use Encoding;

my $time1=time();

my $input = $ARGV[0];
my $out_file=$input."_TitleAndCategories.xml";
open(OUT,">".$out_file)or die "unable to write to $out_file\n";
binmode OUT, ':encoding(utf8)';

my $pages = Parse::MediaWikiDump::Pages->new($input);
my $page;

my $counter = 0;
while(defined($page = $pages->next)) {
    #main namespace only
    next unless $page->namespace eq '';
    my $title = $page->title;
    if (!($title=~/\(disambiguation\)/g and $title=~/List of ||Table of /g) and !defined($page->redirect)){#only want pages that are not 'list' or 'disambiguation'
    	#print title
    	print OUT $title."-XIAO-";
    	$counter++;
    	if ($counter%100==0){#print running info
    		print "done $counter docs\n";
    	}
    	#deal with category information
    	my $categoryInfo="";
    	my $hasLegalCategoryInfo = 0;
    	if (defined $page->categories){#if this page has categories info
    		my $cs = $page->categories;    		
    		foreach my $c (@$cs){
    			$c=~s/ /_/g;
    			$c=~s/|.*//;#delete everything right to |, they are * or links, not categories
    			if ($c!~/[0-9]/){#don't want the ones that contain numbers
    				$categoryInfo.=$c." ";#delimiter of categories when printing
    				$hasLegalCategoryInfo = 1;
    			}			
    		}
    		if ($hasLegalCategoryInfo == 1){
    			chop($categoryInfo);#chop | from the end  	
    		}   			
    	}
    	if ($hasLegalCategoryInfo==0){#the ones with no category info
    		$categoryInfo.="NO_CATEGORY_INFO";#print NO_CATEGORY_INFO
    	}
    	$categoryInfo.="-XIAO-";#deliminator of the title, category info, and text of a page
    	print OUT $categoryInfo;#print category info
    	#deal with the main content of this page
    	my $text = $page->text;
    	my $bodytext = $$text;#pointer to string
    	$bodytext=~s/[\r\n]/ /g;
    	print OUT $bodytext."\n";
		
    }   
}

my $time2=time();
my $duration=$time2-$time1;
print "this script took $duration seconds!\n";
close OUT;