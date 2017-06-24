package ai.mobiquity.sourcer.service;

import ai.mobiquity.sourcer.util.CsvUtils;
import cn.edu.hfut.dmic.contentextractor.ContentExtractor;
import cn.edu.hfut.dmic.contentextractor.News;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.Stream;

/**
 * Created by mustafadagher on 24/06/2017.
 */
@Service
public class NewsCrawler {

    private static int COUNT = 0;

    public void parseNewsBatchToCSV(String filename) {
        try {
            String urlBatch = new String(Files.readAllBytes(Paths.get(filename)));
            List<News> newsList = parseNewsByUrlBatch(urlBatch);
            CsvUtils.writeToCSV(filename, newsList);
        } catch (IOException e) {
            e.printStackTrace();
        }

    }

    public List<News> parseNewsByUrlBatch(String urlBatch) {
        String[] urls = urlBatch.split("\\n");

        List<News> newsList = Stream.of(urls)
                .map(url -> parseArticleByUrl(url))
                .filter(n -> n != null).collect(Collectors.toList());

        return newsList;
    }

    public News parseArticleByUrl(String url) {
        try {
            return ContentExtractor.getNewsByUrl(url);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

}
