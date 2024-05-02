import java.util.Random;

public class RandomLogger {
    public static void main(String[] args) {
        Random rand = new Random();
        while (true) {
            if (rand.nextInt(3) == 0) {
                // 1/3の確率で特定のログパターンを出力
                System.out.println(generateStructuredMessage() + " txn " + randomString());
            } else {
                // 2/3の確率でランダムなメッセージを出力
                System.out.println(randomString());
            }

            try {
                Thread.sleep(10000);  // 10秒待つ
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
    }

    // 文字列と半角スペースを3回繰り返した文字列を生成
    private static String generateStructuredMessage() {
        return randomString() + " " + randomString() + " " + randomString();
    }

    // ランダムな文字列を生成
    private static String randomString() {
        Random random = new Random();
        char[] word = new char[random.nextInt(8)+3];  // 長さ3~10の文字列を生成
        for(int i = 0; i < word.length; i++) {
            word[i] = (char)('a' + random.nextInt(26));  // aからzのランダムな文字
        }
        return new String(word);
    }
}
