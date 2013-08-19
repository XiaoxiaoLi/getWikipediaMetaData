getWikipediaMetaDataWithRedirection
====================

Should be fairly similar to the Master branch. Differences are:

* Main difference with the Master branch is at the preprocessing of the wiki dump part. This branch includes the wikipedia <i>redirection</i> pages. We set the categories of the redirection pages to be the categories they redirect to.

* This branch only cares about categories, not titles.

* File names have changed:

 * The perlsrc/getTitleAndText.pl in the master branch is perlsrc/wikiDumpToTitleAndCategories.pl in this branch.
 * The input, output file names are different

* The buildIndex.java and searchIndex.java are slightly different because of the input/output file are different.

Data failed to add to github: data/enwiki-latest-pages-articles1.xml-p000000010p000010000 downloaded from wikipedia
