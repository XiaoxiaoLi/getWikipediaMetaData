package buildIndex;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;

import org.apache.lucene.analysis.standard.StandardAnalyzer;
import org.apache.lucene.document.Document;
import org.apache.lucene.document.Field;
import org.apache.lucene.index.IndexWriter;
import org.apache.lucene.index.IndexWriterConfig;
import org.apache.lucene.queryParser.ParseException;
import org.apache.lucene.store.FSDirectory;
import org.apache.lucene.util.Version;

/*
 * build lucene index for the processed wikipedia pages
 * each time you run this, the luceneIndex folder will be wiped clean, and a new index will be created.
 * remember to backup the indexes if you need them in the future
 * 
 * Part of the code are from http://www.lucenetutorial.com/lucene-in-5-minutes.html
 * 
 * @Author: Xiaoxiao Li, cindyxiaoxiaoli@gmail.com
 */
public class BuildWikiIndex {

	public static void main(String[] args) throws IOException, ParseException {
		// String luceneRoute = args[0];
		String luceneRoute = "luceneIndex";
		// String inputCleanWikiFile =args[1];
		// mind the file route with different operating systems
		String inputCleanWikiFile = "data/enwiki-20130503-pages-articles-multistream.xml_TitleAndCategories.xml";

		buildIndex(luceneRoute, inputCleanWikiFile);
		// buildIndex("luceneIndex",args[0]);//build index based on input
		// wikipedia file args[0], output the lucene index to the folder
		// 'luceneIndex'
	}

	// Deletes all files and subdirectories under dir.
	// Returns true if all deletions were successful.
	// If a deletion fails, the method stops attempting to delete and returns
	// false.
	public static boolean deleteDir(File dir) {
		if (dir.isDirectory()) {
			String[] children = dir.list();
			for (int i = 0; i < children.length; i++) {
				boolean success = deleteDir(new File(dir, children[i]));
				if (!success) {
					return false;
				}
			}
		}

		// The directory is now empty so delete it
		return dir.delete();
	}

	public static void buildIndex(String indexName, String inputFile)
			throws IOException {
		String indexDir = indexName;
		File file = null;
		file = new File(indexDir);
		int counter = 0;
		if (file.exists()) {
			deleteDir(file);
		}

		FSDirectory dir = FSDirectory.open(new File(indexDir));

		StandardAnalyzer analyzer = new StandardAnalyzer(Version.LUCENE_36);

		IndexWriterConfig config = new IndexWriterConfig(Version.LUCENE_36,
				analyzer);

		IndexWriter indexWriter = new IndexWriter(dir, config);

		try {
			BufferedReader in = new BufferedReader(new FileReader(inputFile));
			String str;
			String[] items = null;
			while ((str = in.readLine()) != null) {
				// process each line
				// print how we do in the console
				// if (counter % 1==0){
				// System.out.println ("done with " + counter +" docs");
				// }
				Document doc = new Document();
				// System.out.println(str);
				items = str.split("-XIAO-");
				if (items.length == 2) {
					doc.add(new Field("title", items[0], Field.Store.YES,
							Field.Index.ANALYZED));

					doc.add(new Field("category", items[1], Field.Store.YES,
							Field.Index.ANALYZED));
				}
				indexWriter.addDocument(doc);
				counter += 1;
			}
			in.close();
		} catch (IOException e) {
		}
		indexWriter.close();
	}
}
