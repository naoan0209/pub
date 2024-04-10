import java.time.LocalDateTime;
import java.util.Random;

public class SaySomething {
    private static final String[] messages = {
            "こんにちは、世界！",
            "今日は素晴らしい日です！",
            "Javaでのロギングは楽しい。",
            "Dockerはデプロイメントを簡単にします。",
            "好奇心を持ち続け、学び続けましょう。",
            "[E-001] [エラーが発生しました]",
            "[E-999] [重大なエラーが発生しました]"
    };

    public static void main(String[] args) throws InterruptedException {

        // 環境変数出力用
        System.out.println(System.getenv("DUMMY_ENV"));
        System.out.println(System.getenv("TEST_ENV"));
        System.out.println(System.getenv("HOME"));

        Random random = new Random();

        while (true) {
            String message = messages[random.nextInt(messages.length)];
            LocalDateTime timestamp = LocalDateTime.now();

            System.out.println(timestamp + " - ログメッセージ: " + message);
            Thread.sleep(10000); // 10秒待機
        }
    }
}
