package com.eventsphere.config;

import javax.sql.DataSource;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.context.annotation.Profile;
import org.springframework.stereotype.Component;

/** Refuse to serve the application without a working, initialized SQL Server database. */
@Component
@Profile("!test")
public class SqlServerConnectionCheck implements InitializingBean {
    private final DataSource dataSource;
    public SqlServerConnectionCheck(DataSource dataSource) { this.dataSource = dataSource; }

    @Override
    public void afterPropertiesSet() throws Exception {
        try (var connection = dataSource.getConnection()) {
            if (!"Microsoft SQL Server".equals(connection.getMetaData().getDatabaseProductName())) {
                throw new IllegalStateException("EventSphere requires Microsoft SQL Server.");
            }
            SqlServerSetup.verifySchema(connection);
            org.slf4j.LoggerFactory.getLogger(getClass()).info("SQL Server connection verified: database={}", connection.getCatalog());
        }
    }
}
