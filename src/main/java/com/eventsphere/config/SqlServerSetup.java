package com.eventsphere.config;

import com.microsoft.sqlserver.jdbc.SQLServerDataSource;
import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import java.util.*;
import java.util.regex.Pattern;


public final class SqlServerSetup {
    private SqlServerSetup() {}

    private static String env(String name, String fallback) {
        String value = System.getenv(name);
        return value == null || value.isBlank() ? fallback : value;
    }

    private static SQLServerDataSource source(String database) {
        SQLServerDataSource ds = new SQLServerDataSource();
        ds.setServerName(env("DB_HOST", "localhost"));
        ds.setPortNumber(Integer.parseInt(env("DB_PORT", "1433")));
        ds.setDatabaseName(database);
        ds.setEncrypt("true");
        ds.setTrustServerCertificate(Boolean.parseBoolean(env("DB_TRUST_SERVER_CERTIFICATE", "true")));
        boolean windows = Boolean.parseBoolean(env("DB_INTEGRATED_SECURITY", "true"));
        ds.setIntegratedSecurity(windows);
        if (!windows) {
            ds.setUser(env("DB_USERNAME", ""));
            ds.setPassword(env("DB_PASSWORD", ""));
        }
        ds.setLoginTimeout(10);
        return ds;
    }

    private static String script(String file) throws Exception {
        try (var stream = SqlServerSetup.class.getResourceAsStream("/" + file)) {
            if (stream == null) throw new IllegalStateException("Missing SQL script: " + file);
            return new String(stream.readAllBytes(), StandardCharsets.UTF_8)
                    .replaceAll("(?im)^\\s*USE EventSphereDB;\\s*$", "");
        }
    }

    private static Set<String> requiredTables() throws Exception {
        Set<String> names = new LinkedHashSet<>();
        var matcher = Pattern.compile("(?i)CREATE TABLE (\\w+)").matcher(script("schema.sql"));
        while (matcher.find()) names.add(matcher.group(1));
        return names;
    }

    public static void verifySchema(Connection connection) throws Exception {
        try (var statement = connection.prepareStatement("SELECT OBJECT_ID(?, 'U')")) {
            for (String table : requiredTables()) {
                statement.setString(1, "dbo." + table);
                try (var result = statement.executeQuery()) {
                    result.next();
                    if (result.getObject(1) == null) throw new IllegalStateException("SQL Server table dbo." + table + " is missing. Run Setup-SQLServer.cmd.");
                }
            }
        }
        try (var statement = connection.createStatement();
             var result = statement.executeQuery("SELECT COL_LENGTH('dbo.events', 'is_archived')")) {
            result.next();
            if (result.getObject(1) == null)
                throw new IllegalStateException("SQL Server column dbo.events.is_archived is missing. Run Setup-SQLServer.cmd.");
        }
    }

    private static void executeScript(Connection connection, String file) throws Exception {
        for (String batch : script(file).split("(?im)^\\s*GO\\s*$")) {
            if (!batch.isBlank()) try (var statement = connection.createStatement()) {
                statement.execute(batch);
            }
        }
    }

    public static void main(String[] args) throws Exception {
        String database = env("DB_NAME", "EventSphereDB");
        if (!database.matches("[A-Za-z][A-Za-z0-9_]{0,127}")) throw new IllegalArgumentException("Use letters, numbers and underscores in DB_NAME.");
        // A working existing database needs no master-level provisioning permissions.
        Connection target;
        try {
            target = source(database).getConnection();
        } catch (java.sql.SQLException unavailable) {
            if (unavailable.getErrorCode() != 4060) throw unavailable;
            try (var master = source("master").getConnection();
                 var exists = master.prepareStatement("SELECT DB_ID(?)")) {
                exists.setString(1, database);
                try (var result = exists.executeQuery()) {
                    result.next();
                    if (result.getObject(1) != null) throw unavailable;
                }
                try (var create = master.createStatement()) { create.execute("CREATE DATABASE [" + database + "]"); }
            }
            target = source(database).getConnection();
        }
        try (Connection connection = target) {
            if (Arrays.asList(args).contains("--check-only")) {
                verifySchema(connection);
            } else {
                connection.setAutoCommit(false);
                try {
                    try (var lock = connection.createStatement()) {
                        lock.execute("DECLARE @r int; EXEC @r=sys.sp_getapplock @Resource='EventSphere.schema', @LockMode='Exclusive', @LockOwner='Session', @LockTimeout=15000; IF @r < 0 THROW 50001, 'Could not lock EventSphere schema setup', 1;");
                    }
                    boolean empty;
                    try (var count = connection.createStatement(); var result = count.executeQuery("SELECT COUNT(*) FROM sys.tables WHERE is_ms_shipped=0")) {
                        result.next(); empty = result.getInt(1) == 0;
                    }
                    if (empty) {
                        executeScript(connection, "schema.sql");
                        if (Boolean.parseBoolean(env("DB_SEED_DEMO", "true"))) executeScript(connection, "data.sql");
                        System.out.println("Initialized SQL Server schema in " + database + ".");
                    }
                    executeScript(connection, "migrations.sql");
                    verifySchema(connection);
                    connection.commit();
                } catch (Exception failure) {
                    connection.rollback();
                    throw failure;
                }
            }
            System.out.println("SQL Server verified: " + connection.getMetaData().getDatabaseProductName() + " / " + connection.getCatalog());
        }
    }
}
