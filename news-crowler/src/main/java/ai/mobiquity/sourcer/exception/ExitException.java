package ai.mobiquity.sourcer.exception;

/**
 * Created by mustafadagher on 24/06/2017.
 */
import org.springframework.boot.ExitCodeGenerator;

public class ExitException extends RuntimeException implements ExitCodeGenerator {

    @Override
    public int getExitCode() {
        return 10;
    }

}
