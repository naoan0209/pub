import java.time.LocalDateTime;
import java.util.Random;

/**
 * さまざまなメッセージをランダムにログ出力するシンプルなプログラム。
 * <p>
 * このプログラムは定期的に（10秒ごとに）プリセットされたメッセージのリストから
 * ランダムに選んだメッセージをログ出力します。出力されるメッセージには現在の
 * タイムスタンプが付加され、標準出力に表示されます。
 */
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

    /**
     * プログラムのエントリポイント。
     * <p>
     * このメソッドは、プリセットされたメッセージリストからランダムにメッセージを選択し、
     * 現在のタイムスタンプとともに標準出力にログとして表示します。この処理は無限ループ内で
     * 行われ、各ログ出力の間には10秒の遅延があります。
     *
     * @param args コマンドライン引数（使用されません）
     * @throws InterruptedException スレッドの割り込み例外
     */
    public static void main(String[] args) throws InterruptedException {
        Random random = new Random();

        while (true) {
            String message = messages[random.nextInt(messages.length)];
            LocalDateTime timestamp = LocalDateTime.now();

            System.out.println(timestamp + " - ログメッセージ: " + message);
            Thread.sleep(10000); // 10秒待機
        }
    }
}
