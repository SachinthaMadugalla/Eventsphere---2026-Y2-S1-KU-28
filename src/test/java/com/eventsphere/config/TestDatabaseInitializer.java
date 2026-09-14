package com.eventsphere.config;

import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import javax.sql.DataSource;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.context.annotation.Profile;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.core.io.ClassPathResource;
import org.springframework.jdbc.datasource.init.ScriptUtils;
import org.springframework.stereotype.Component;

/** Initializes an empty local database once, reusing the SQL Server source scripts. */
@Component
@Profile("test")
public class TestDatabaseInitializer implements InitializingBean {
    private final DataSource dataSource;

    public TestDatabaseInitializer(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    @Override
    public void afterPropertiesSet() throws Exception {
        try (Connection connection = dataSource.getConnection()) {
            try (var tables = connection.getMetaData().getTables(null, null, "roles", new String[]{"TABLE"})) {
                if (tables.next()) {
                    try (var statement = connection.createStatement();
                         var result = statement.executeQuery("SELECT COUNT(*) FROM local_setup")) {
                        if (result.next() && result.getInt(1) == 1) return;
                    }
                    throw new IllegalStateException("Local database setup is incomplete. Back up .local before recreating it.");
                }
            }
            for (String file : new String[]{"schema.sql", "data.sql"}) {
                String sql = new ClassPathResource(file).getContentAsString(StandardCharsets.UTF_8)
                        .replaceAll("(?im)^\\s*(USE EventSphereDB;|GO|PRINT .*;)\\s*$", "");
                ScriptUtils.executeSqlScript(connection,
                        new ByteArrayResource(sql.getBytes(StandardCharsets.UTF_8)));
            }
            try (var statement = connection.createStatement()) {
                statement.execute("CREATE TABLE local_setup (version INT PRIMARY KEY)");
                statement.execute("INSERT INTO local_setup VALUES (1)");
            }
        }
    }
}
