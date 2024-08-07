use sample_database;

-- DELETE用
DELIMITER //
CREATE TRIGGER invoke_lambda_after_delete
    AFTER DELETE
    ON users
    FOR EACH ROW
BEGIN
    -- Lambdaに渡すペイロードを作成
    DECLARE payload VARCHAR(1024);
    SET payload = JSON_OBJECT('operation', 'ping', 'old_user_id', OLD.id);

    SELECT lambda_sync(
        'arn:aws:lambda:ap-northeast-1:977566148511:function:mysql-trigger', payload
        ) INTO @result;
END; //
DELIMITER ;


-- UPDATE用
DELIMITER //
CREATE TRIGGER invoke_lambda_after_update
    AFTER UPDATE
    ON users
    FOR EACH ROW
BEGIN
    -- idに更新があった場合のみトリガーを実行する
    IF NEW.id <> OLD.id THEN
        -- Lambdaに渡すペイロードを作成
        DECLARE payload VARCHAR(1024);
        SET payload = JSON_OBJECT('operation', 'ping', 'old_user_id', OLD.id);

        SELECT lambda_sync(
            'arn:aws:lambda:ap-northeast-1:977566148511:function:mysql-trigger', payload
        ) INTO @result;
    END IF;
END; //
DELIMITER ;
