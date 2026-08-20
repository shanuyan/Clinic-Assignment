package com.clinic.util;

import java.util.logging.Logger;
import java.util.logging.Level;
import java.util.logging.FileHandler;
import java.util.logging.SimpleFormatter;

public class LoggerUtil {
    private static final Logger logger = Logger.getLogger("ClinicLogger");
    
    static {
        try {
            FileHandler fh = new FileHandler("clinic_system.log", true);
            logger.addHandler(fh);
            SimpleFormatter formatter = new SimpleFormatter();
            fh.setFormatter(formatter);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static void logInfo(String msg) {
        logger.log(Level.INFO, msg);
    }

    public static void logError(String msg, Exception e) {
        logger.log(Level.SEVERE, msg, e);
    }
}
