package org.example.support;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

public final class TestConfig {

    private static final Properties PROPERTIES = new Properties();

    static {
        try (InputStream input = TestConfig.class.getClassLoader()
                .getResourceAsStream("config/application.properties")) {
            if (input == null) {
                throw new IllegalStateException("config/application.properties not found");
            }
            PROPERTIES.load(input);
        } catch (IOException e) {
            throw new IllegalStateException("Failed to load test configuration", e);
        }
    }

    private TestConfig() {
    }

    public static String getBaseUrl() {
        return PROPERTIES.getProperty("base.url");
    }
}
