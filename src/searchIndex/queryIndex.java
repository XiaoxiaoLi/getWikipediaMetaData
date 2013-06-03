package searchIndex;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;

import org.apache.lucene.analysis.standard.StandardAnalyzer;
import org.apache.lucene.document.Document;
import org.apache.lucene.index.IndexReader;
import org.apache.lucene.queryParser.ParseException;
import org.apache.lucene.queryParser.QueryParser;
import org.apache.lucene.search.IndexSearcher;
import org.apache.lucene.search.Query;
import org.apache.lucene.search.ScoreDoc;
import org.apache.lucene.search.TopDocs;
import org.apache.lucene.store.FSDirectory;
import org.apache.lucene.util.Version;

/*
 * Search a query in a lucene index, get the title and category information of all the hits
 * 
 * part of the code are from http://www.lucenetutorial.com/lucene-in-5-minutes.html
 * @Author: Xiaoxiao Li, cindyxiaoxiaoli@gmail.com
 */

public class queryIndex {
	// main
	public static void main(String[] args) throws IOException, ParseException {
		// String query = args[0];
		String query = "Achilles";// the query to search

		// String indexRoute = args[1];
		String indexRoute = "luceneIndex";// lucene index folder

		// String outputRoute = args[2];// output file,print the title and
		// category info of the query to this file
		String outputRoute = "data\\titleAndCategoryResult.txt";
		FileWriter fstream = new FileWriter(outputRoute, false);
		BufferedWriter out = new BufferedWriter(fstream);

		// search the index
		ArrayList<String> results = searchIndex(query, indexRoute);

		// print the title and category info of all the hits for this query into
		// a file
		for (String r : results) {
			String[] titleAndcategories = r.split("\t");
			String title = titleAndcategories[0];
			String categories = titleAndcategories[1];
			out.write("title: " + title + "\n");
			out.write("categories: " + categories + "\n\n");
			System.out.println("title: " + title);
			System.out.println("categories: " + categories);
		}
		out.close();
	}

	// method to search in the index
	public static ArrayList<String> searchIndex(String queryString,
			String indexRoute) throws IOException, ParseException {
		IndexSearcher searcher = new IndexSearcher(IndexReader.open(FSDirectory
				.open(new File(indexRoute))));

		// the "title" arg specifies the default field to use
		// when no field is explicitly specified in the query.
		// if you want to search within the main content of the page, set the
		// arg to "text"

		QueryParser parser = new QueryParser(Version.LUCENE_36, "title",
				new StandardAnalyzer(Version.LUCENE_36));
		// QueryParser parser = new QueryParser(Version.LUCENE_36, "text",
		// new StandardAnalyzer(Version.LUCENE_36));
		System.out.println("\nsearching for: " + queryString);
		Query query = parser.parse(queryString);
		TopDocs results = searcher.search(query, 10);

		ArrayList<String> titleAndcategories = new ArrayList<String>();

		System.out.println("total hits: " + results.totalHits + "\n");

		ScoreDoc[] hits = results.scoreDocs;
		for (ScoreDoc hit : hits) {
			Document doc = searcher.doc(hit.doc);
			String title = doc.get("title");
			String categories = doc.get("category");
			String resultForThisHit = title + "\t" + categories;
			titleAndcategories.add(resultForThisHit);// use \t as delimiter
														// between
														// title and categories
			// System.out.println("title: " + title);
			// System.out.println("categories: " + categories + "\n");
		}
		searcher.close();
		return titleAndcategories;
	}
}