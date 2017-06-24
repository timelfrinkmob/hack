package ai.mobiquity.sourcer.util;

import cn.edu.hfut.dmic.contentextractor.News;

import java.io.*;
import java.util.List;

/**
 * Created by mustafadagher on 24/06/2017.
 */
public class CsvUtils {

    private static int COUNT = 0;

    private static final String CSV_SEPARATOR = "|";

    public static void writeToCSV(String filename, List<News> newsList) {
        try {
            COUNT++;
            BufferedWriter bw = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(filename + ".csv"), "UTF-8"));

            StringBuffer header = new StringBuffer();
            header.append("Title");
            header.append(CSV_SEPARATOR);
            header.append("Content");
            header.append(CSV_SEPARATOR);
            header.append("URL");
            header.append(CSV_SEPARATOR);
            header.append("Date");
            bw.write(header.toString());
            bw.newLine();

            for (News news : newsList) {
                StringBuffer oneLine = new StringBuffer();
                oneLine.append("\"" + news.getTitle() + "\"");
                oneLine.append(CSV_SEPARATOR);
                oneLine.append("\"" + news.getContent() + "\"");
                oneLine.append(CSV_SEPARATOR);
                oneLine.append("\"" + news.getUrl() + "\"");
                oneLine.append(CSV_SEPARATOR);
                oneLine.append("\"" + news.getTime() + "\"");
                bw.write(oneLine.toString());
                bw.newLine();
            }

            bw.flush();
            bw.close();
        } catch (UnsupportedEncodingException e) {
        } catch (FileNotFoundException e) {
        } catch (IOException e) {
        }
    }
}
