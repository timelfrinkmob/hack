package ai.mobiquity.sourcer.util;

import cn.edu.hfut.dmic.contentextractor.News;

import java.io.*;
import java.util.List;

/**
 * Created by mustafadagher on 24/06/2017.
 */
public class CsvUtils {

    private static final String CSV_SEPARATOR = "|";

    public static void writeToCSV(String filename, List<News> newsList) {
        try {
            FileWriter fr = new FileWriter(filename + ".csv");

            StringBuilder builder = new StringBuilder();
            builder.append("Title").append(CSV_SEPARATOR).append("Content").append(CSV_SEPARATOR).append("URL").append(CSV_SEPARATOR).append("Date").append(System.lineSeparator());

            for (News news : newsList) {
                String title = news.getTitle() != null ? news.getTitle().replace("\"", "") : "";
                builder.append("\"" + title + "\"");
                builder.append(CSV_SEPARATOR);

                String content = news.getContent() != null ? news.getContent().replace("\"", "") : "";
                builder.append("\"" + content + "\"");
                builder.append(CSV_SEPARATOR);

                builder.append("\"" + news.getUrl() + "\"");
                builder.append(CSV_SEPARATOR);

                builder.append("\"" + news.getTime() + "\"");
                builder.append(System.lineSeparator());
            }

            fr.write(builder.toString());
            fr.flush();
            fr.close();
        } catch (UnsupportedEncodingException e) {
        } catch (FileNotFoundException e) {
        } catch (IOException e) {
        }
    }
}
