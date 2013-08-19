getWikipediaMetaData
====================

#### Clean a wikipedia dump, index with lucene, search for a query and return its wiki title and category

###### Data
Requires a wikipedia dump, for example, uncompressed file from enwiki-20130503-pages-articles-multistream.xml.bz2 (http://dumps.wikimedia.org/enwiki/20130503/), it uncomprss to about 30G.
For illustration purpose, this project contains a small sample of a wikipedia dump that contains only a very small portion of a wikipedia dump. It is in `data\\wiki_dump_sample.xml`. This wikipedia dump contains only 7 pages. You can build a sample of an wikipedia dump using the perl script: `perlsrc\\firstNLines.pl` for testing purposes as well.

###### Pre-processing of the wikipedia dump
Pre-process the data to change its wikipedia dump format into text format using `perlsrc\\getTitleAndText.pl` so that lucene can read it. I only kept the *title* and *category* information in the meta data, and also the main content of a page. I filtered the pages that are lists or a disambiguation page. You can modify this file so that the dump is pre-processed according to your rules. The sample output of this script is in `data\\wiki_dump_sample.xml_TitleAndCategories.xml`.
To run this script, you have to have perl, and the perl module [Parse::MediaWikiDump](http://en.wikipedia.org/wiki/Wikipedia:Computer_help_desk/ParseMediaWikiDump) installed.

The [getWikipediaMetaDataWithRedirection](https://github.com/XiaoxiaoLi/getWikipediaMetaData/tree/getWikipediaCategoryWithRedirection) branch takes into account the redirection pages. See that branch for more details.

###### Build Lucene index
`BuildWikiIndex.java` builds the lucene index for the pre-processed dump. The argument `luceneRoute` specifies where to store the generated Lucene index. The argument `inputCleanWikiFile` is the route of the input pre-processed wikipedia dump. It indexes three fields in the wikipedia dump, *title*, *category*, and *text*. You need to run this before querying the index. Each time you run it will wipe out the old index that you had and generate new ones, so remember to back up the indexes if you need them.

###### Query the Lucene index
`queryIndex.java` queries the generated lucene index. The argument `query` is the term that you want to search in the lucene index. It will print the title and category information of all the hits(pages) for this query. You can specify which field to search for the term in
`  	QueryParser parser = new QueryParser(Version.LUCENE_36, "title",
				new StandardAnalyzer(Version.LUCENE_36));`
Here the *title* argument indicates that lucene will search for your query in the *title* field of the pages. You can also set the field to be *category* or *text*.     
  
