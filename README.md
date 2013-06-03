getWikipediaMetaData
====================

#### Clean a wikipedia dump, index with lucene, search for a query and return its wiki title and category

###### Data
Requires a wikipedia dump, for example, uncompressed file from enwiki-20130503-pages-articles-multistream.xml.bz2 (http://dumps.wikimedia.org/enwiki/20130503/), it uncomprss to about 30G.
For illustration purpose, this project contains a small sample of a wikipedia dump that contains only a very small portion of a wikipedia dump. It is in `data\\wiki_dump_sample.xml`. This wikipedia dump contains only 7 pages. You can build a sample of an wikipedia dump using the perl script: `perlsrc\\firstNLines.pl` for testing purposes as well.

###### Pre-processing of the wikipedia dump
Pre-process the data to change its wikipedia dump format into text format using `perlsrc\\getTitleAndText.pl` I only kept the *title* and *category* information in the meta data, and also the main content of a page. I filtered the pages that are lists or a disambiguation page. You can modify this file so that the dump is pre-processed according to your rules. The sample output of this script is in `data\\wiki_dump_sample.xml_TitleAndCategories.xml`.
To run this script, you have to have perl, and the perl module [Parse::MediaWikiDump](http://en.wikipedia.org/wiki/Wikipedia:Computer_help_desk/ParseMediaWikiDump) installed.

###### Build lucene index
