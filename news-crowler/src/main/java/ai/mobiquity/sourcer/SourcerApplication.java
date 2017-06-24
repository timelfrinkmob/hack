package ai.mobiquity.sourcer;

import ai.mobiquity.sourcer.exception.ExitException;
import ai.mobiquity.sourcer.service.NewsCrawler;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.jdbc.DataSourceAutoConfiguration;
import org.springframework.boot.autoconfigure.orm.jpa.HibernateJpaAutoConfiguration;

@SpringBootApplication(exclude = {DataSourceAutoConfiguration.class, HibernateJpaAutoConfiguration.class})
public class SourcerApplication implements CommandLineRunner{

	@Autowired
	private NewsCrawler newsCrawler;

	public static void main(String[] args) {
		SpringApplication.run(SourcerApplication.class, args);
	}

	@Override
	public void run(String... args) throws Exception {
		if (args.length > 0 && args[0].equals("exitcode")) {
			throw new ExitException();
		}

		String filename = args[0];
		newsCrawler.parseNewsBatchToCSV(filename);
	}
}
