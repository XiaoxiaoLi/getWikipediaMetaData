#! usr/bin/perl -w
#input: a wikipedia dump, or a small portion of a wikipedia dump, has to have the wikipedia dump xml format
#output: a file, each line is a wikipedia page, title, category info seperated by '-XIAO-', each category is seperated by a space (no text)

#also deal with page with 'redirect', set their categories to be the categories they redirect to

#to run: specify the input file route

#use the module Parse::MediaWikiDump
#Prerequisite, has to have installed this module http://en.wikipedia.org/wiki/Wikipedia:Computer_help_desk/ParseMediaWikiDump

use Parse::MediaWikiDump;
use strict;
use Encoding;

my $time1=time();

my $input = $ARGV[0];#input file route
my $out_file=$input."_TitleAndCategories.xml";
open(OUT,">".$out_file)or die "unable to write to $out_file\n";
binmode OUT, ':encoding(utf8)';

my $out_file2=$input."_Redirections.xml";
open(OUT2,">".$out_file2)or die "unable to write to $out_file2\n";
binmode OUT2, ':encoding(utf8)';

my $pages = Parse::MediaWikiDump::Pages->new($input);
my $page;

my $counter = 0;#for running messages
my %title_categories_hash=();#key is title, value is categories
my %redirect_hash=();#key is title, value is redirected title, use this to get the categories of the pages that have redirect
my $noCategoryInfoStr = "NO_CATEGORY_INFO";

while(defined($page = $pages->next)) {
    #main namespace only
    next unless $page->namespace eq '';
    my $title = $page->title;
    if (!($title=~/\(disambiguation\)/g and $title=~/List of ||Table of /g)){#only want pages that are not 'list' or 'disambiguation'
    	#print title
    	#print OUT $title."-XIAO-";
    	$counter++;
    	if ($counter%500==0){#print running info
    		print "done $counter docs\n";
    	}
    	#deal with pages with redirection
    	if($page->redirect){
    		my $redirTitle = case_fixer($page->redirect);
            if(!exists $redirect_hash{$title}){#save to hash
                $redirect_hash{$title} = $redirTitle;
            }
    		print OUT2 $title."-XIAO-"."$redirTitle\n";
    	}else{
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
                $categoryInfo.=$noCategoryInfoStr;#print $noCategoryInfoStr
            }
            #$categoryInfo.="-XIAO-";#deliminator of the title, category info, and text of a page
            #print OUT $categoryInfo;#print category info    
            if(!exists $title_categories_hash{$title}){#save to hash
                $title_categories_hash{$title}=$categoryInfo;
            }
        }    	
    }   
}

#deal with redirect
foreach my $title(keys %redirect_hash){
    my $redirectTitle = $redirect_hash{$title};
    if(exists $title_categories_hash{$redirectTitle} and !exists $title_categories_hash{$title}){
        $title_categories_hash{$title} = $title_categories_hash{$redirectTitle};
    }else{
        $title_categories_hash{$title} = $noCategoryInfoStr;
    }
}

#print everything
foreach my $title(keys %title_categories_hash){
    print OUT $title."-XIAO-";#print ori title for each one   
    my $categoryInfo = $title_categories_hash{$title};
    print OUT $categoryInfo."\n";
}



my $time2=time();
my $duration=$time2-$time1;
print "this script took $duration seconds!\n";
close OUT;
close OUT2;

#removes any case sensativity from the very first letter of the title
#but not from the optional namespace name
sub case_fixer {
	my $title = shift;

	#check for namespace
	if ($title =~ /^(.+?):(.+)/) {
		$title = $1 . ':' . ucfirst($2);
	} else {
		$title = ucfirst($title);
	}

	return $title;
}