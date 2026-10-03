package com.eventsphere.util;

import java.util.regex.Pattern;

/**
 * Shared server-side validation rules.
 * Keep these in sync with the client-side rules in static/js/eventsphere.js
 * and the pattern/maxlength attributes on the JSP forms.
 */
public final class ValidationUtil {

    /** Sri Lankan phone number: exactly 10 digits, starting with 0 (e.g. 0771234567). */
    private static final Pattern PHONE = Pattern.compile("^0\\d{9}$");

    /** Practical email format: local@domain.tld (TLD at least 2 letters). */
    private static final Pattern EMAIL = Pattern.compile("^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$");

    /** Person names: letters, spaces, dots, apostrophes and hyphens only. */
    private static final Pattern PERSON_NAME = Pattern.compile("^\\p{L}[\\p{L} .'-]*$");

    /** Usernames: letters, digits, dot, underscore and hyphen. */
    private static final Pattern USERNAME = Pattern.compile("^[A-Za-z0-9._-]+$");

    public static final int NAME_MIN = 2;
    public static final int NAME_MAX = 100;
    public static final int USERNAME_MIN = 3;
    public static final int USERNAME_MAX = 50;
    public static final int EMAIL_MAX = 150;
    public static final int ADDRESS_MAX = 255;
    public static final int PASSWORD_MIN = 6;
    /** BCrypt only uses the first 72 bytes of a password. */
    public static final int PASSWORD_MAX = 72;

    private ValidationUtil() { }

    public static boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }

    /** Trims the value and returns null when it is blank. */
    public static String trimToNull(String value) {
        return isBlank(value) ? null : value.trim();
    }

    public static boolean isValidPhone(String phone) {
        return phone != null && PHONE.matcher(phone.trim()).matches();
    }

    public static boolean isValidEmail(String email) {
        if (email == null) return false;
        String e = email.trim();
        return e.length() <= EMAIL_MAX && EMAIL.matcher(e).matches() && !e.contains("..");
    }

    public static boolean isValidPersonName(String name) {
        if (name == null) return false;
        String n = name.trim();
        return n.length() >= NAME_MIN && n.length() <= NAME_MAX && PERSON_NAME.matcher(n).matches();
    }

    public static boolean isValidUsername(String username) {
        if (username == null) return false;
        String u = username.trim();
        return u.length() >= USERNAME_MIN && u.length() <= USERNAME_MAX && USERNAME.matcher(u).matches();
    }

    /**
     * Validates an optional phone number.
     * @return null if blank or valid, otherwise an error message
     */
    public static String checkOptionalPhone(String phone) {
        if (isBlank(phone)) return null;
        return isValidPhone(phone) ? null : "Phone number must contain exactly 10 digits and start with 0 (e.g. 0771234567).";
    }

    /**
     * Validates an optional email address.
     * @return null if blank or valid, otherwise an error message
     */
    public static String checkOptionalEmail(String email) {
        if (isBlank(email)) return null;
        return isValidEmail(email) ? null : "Please enter a valid email address (e.g. name@example.com).";
    }

    /**
     * Validates a password against the length rules.
     * @return null if valid, otherwise an error message
     */
    public static String checkPassword(String password, String label) {
        if (password == null || password.length() < PASSWORD_MIN) {
            return label + " must be at least " + PASSWORD_MIN + " characters.";
        }
        if (password.length() > PASSWORD_MAX) {
            return label + " must not exceed " + PASSWORD_MAX + " characters.";
        }
        return null;
    }
}
