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
}
