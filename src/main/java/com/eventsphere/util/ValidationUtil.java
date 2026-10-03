package com.eventsphere.util;

import java.util.regex.Pattern;

public class ValidationUtil {

    private static final Pattern PHONE_PATTERN = Pattern.compile("^0\\d{9}$");
    private static final Pattern EMAIL_PATTERN = Pattern.compile("^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$");
    private static final Pattern NAME_PATTERN = Pattern.compile("^[A-Za-z \\.'-]{2,100}$");
    private static final Pattern USERNAME_PATTERN = Pattern.compile("^[A-Za-z0-9._-]{3,50}$");

    public static boolean isValidPhone(String phone) {
        if (phone == null || phone.isEmpty()) return true; 
        return PHONE_PATTERN.matcher(phone).matches();
    }

    public static boolean isValidEmail(String email) {
        if (email == null || email.isEmpty()) return false;
        return EMAIL_PATTERN.matcher(email).matches();
    }

    public static boolean isValidPersonName(String name) {
        if (name == null || name.isEmpty()) return false;
        return NAME_PATTERN.matcher(name).matches();
    }

    public static boolean isValidUsername(String username) {
        if (username == null || username.isEmpty()) return false;
        return USERNAME_PATTERN.matcher(username).matches();
    }

    public static boolean isBlank(String str) {
        return str == null || str.trim().isEmpty();
    }

    public static String trimToNull(String str) {
        if (str == null) return null;
        String trimmed = str.trim();
        return trimmed.isEmpty() ? null : trimmed;
    }

    public static String checkOptionalPhone(String phone) {
        if (isBlank(phone)) return null;
        if (!isValidPhone(phone.trim())) {
            return "Phone number must be exactly 10 digits and start with 0.";
        }
        return null;
    }

    public static String checkOptionalEmail(String email) {
        if (isBlank(email)) return null;
        if (!isValidEmail(email.trim())) {
            return "Please enter a valid email address.";
        }
        return null;
    }
}
