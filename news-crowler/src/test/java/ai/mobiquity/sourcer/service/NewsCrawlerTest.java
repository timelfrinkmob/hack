package ai.mobiquity.sourcer.service;

import ai.mobiquity.sourcer.util.CsvUtils;
import cn.edu.hfut.dmic.contentextractor.News;
import org.hamcrest.CoreMatchers;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Ignore;
import org.junit.Test;

import java.util.Arrays;

import static org.junit.Assert.*;

/**
 * Created by mustafadagher on 24/06/2017.
 */
public class NewsCrawlerTest {
    private NewsCrawler newsCrawler = null;

    @Before
    public void setUp() {
        newsCrawler = new NewsCrawler();
    }

    @Test
    public void test_parseArticleByUrl_success() throws Exception {
        // Given
        String url = "http://www.bbc.com/news/uk-england-london-40389148";

        // When
        News news = newsCrawler.parseArticleByUrl(url);

        // Then
        assertNotNull(news);
        assertEquals("Camden flats: Hundreds of homes evacuated over fire risk fears", news.getTitle());
        assertThat(news.getContent(), CoreMatchers.containsString("More than 700 flats in tower blocks on an estate"));
        assertEquals(url, news.getUrl());
    }

    @Test
    public void test_parseArticleByUrl_success2() throws Exception {
        // Given
        String url = "http://thehill.com/blogs/ballot-box/presidential-races/302849-black-lives-matter-leader-deray-mckesson-endorses-clinton";

        // When
        News news = newsCrawler.parseArticleByUrl(url);

        // Then
        assertNotNull(news);
        assertEquals("Black Lives Matter leader DeRay McKesson endorses Clinton", news.getTitle());
        assertThat(news.getContent(), CoreMatchers.containsString("Top Black Lives Matter activist DeRay McKesson on Wednesday endorsed Hillary"));
        assertEquals(url, news.getUrl());
        assertEquals("2016-10-26", news.getTime());
    }

    @Ignore
    @Test
    public void test() {
        // Given
        String filename = "newtest";

        // When
        newsCrawler.parseNewsBatchToCSV(filename);

    }

    @Test
    public void test_parseNewsBatchToCSV_success() {
        String urlBatch = "http://thehill.com/blogs/ballot-box/presidential-races/302849-black-lives-matter-leader-deray-mckesson-endorses-clinton\n" +
                "http://www.cbsnews.com/news/black-lives-matter-leader-deray-mckesson-endorses-hillary-clinton/\n" +
                "http://www.latimes.com/nation/politics/trailguide/la-na-trailguide-updates-black-lives-matter-activist-endorses-1477486400-htmlstory.html\n" +
                "http://www.politico.com/story/2016/10/deray-mckesson-endorses-clinton-230324\n" +
                "https://www.wsws.org/en/articles/2016/11/02/mcke-n02.html\n" +
                "https://www.usatoday.com/story/news/politics/onpolitics/2016/10/26/black-lives-matter-activist-deray-mckesson-endorses-clinton/92763812/\n" +
                "https://www.infowars.com/black-lives-matter-leader-deray-mckesson-endorses-clinton/\n" +
                "http://www.nbcnews.com/storyline/2016-election-day/black-lives-matter-activist-deray-mckesson-voting-hillary-n673251\n" +
                "http://www.freerepublic.com/focus/f-gop/3485278/posts\n" +
                "http://www.blacklivesmatterexposed.com/tag/deray-mckesson/";

        newsCrawler.parseNewsBatchToCSV(urlBatch);
    }



}