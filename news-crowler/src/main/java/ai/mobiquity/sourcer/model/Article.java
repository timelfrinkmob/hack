package ai.mobiquity.sourcer.model;


import lombok.Data;

/**
 * Created by mustafadagher on 23/06/2017.
 */
@Data
public class Article {
    private String title;
    private String content;
    private String publishDate;
    private String author;
    private String[] tags;
}
