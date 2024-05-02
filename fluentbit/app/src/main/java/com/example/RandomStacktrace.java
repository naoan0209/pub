package com.example;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

public class RandomStacktrace {
    private static final SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss,SSS");

    public static void main(String[] args) {
        while (true) {
            try {
                Thread.sleep(10000); // 10秒ごとに実行

                int randomChoice = (int) (Math.random() * 5); // 0から4までの整数をランダムに生成
                switch (randomChoice) {
                    case 0:
                        simulateError();
                        break;
                    case 1:
                        simulateNullPointer();
                        break;
                    case 2:
                        simulateIllegalArgument();
                        break;
                    case 3:
                        simulateIO();
                        break;
                    case 4:
                        System.out.println(getTimestamp() + " Regular log message");
                        break; // `break` を忘れずに
                }
            } catch (Exception e) {
                printCustomStackTrace(e); // 原因がある場合はそれを出力
            }
        }
    }

    private static void simulateError() throws Exception {
        try {
            throwError();
        } catch (Exception e) {
            throw new RuntimeException("Wrapped Exception", e);
        }
    }

    private static void simulateNullPointer() throws Exception {
        try {
            throwNullPointer();
        } catch (Exception e) {
            throw new RuntimeException("Wrapped NullPointerException", e);
        }
    }

    private static void simulateIllegalArgument() throws Exception {
        try {
            throwIllegalArgument();
        } catch (Exception e) {
            throw new RuntimeException("Wrapped IllegalArgumentException", e);
        }
    }

    private static void simulateIO() throws Exception {
        try {
            throwIO();
        } catch (Exception e) {
            throw new RuntimeException("Wrapped IOException", e);
        }
    }

    private static void throwError() throws Exception {
        throw new Exception("Sample Stack Trace");
    }

    private static void throwNullPointer() throws NullPointerException {
        throw new NullPointerException("Null Pointer Exception");
    }

    private static void throwIllegalArgument() throws IllegalArgumentException {
        throw new IllegalArgumentException("Illegal Argument Exception");
    }

    private static void throwIO() throws IOException {
        throw new IOException("IO Exception");
    }

    private static String getTimestamp() {
        return dateFormat.format(new Date());
    }

    private static void printCustomStackTrace(Throwable throwable) {
        System.out.println(getTimestamp() + " " + throwable.toString());
        for (StackTraceElement element : throwable.getStackTrace()) {
            System.out.println("\tat " + element);
        }
        if (throwable.getCause() != null) {
            printCustomStackTrace(throwable.getCause()); // 再帰的に原因を出力
        }
    }
}
