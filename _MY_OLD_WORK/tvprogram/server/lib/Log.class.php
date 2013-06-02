<?php
/**
 * Модуль работы с фалом лога
 * @author mamont
 *
 */
class Log {

    public static function error ($text) {
        self::write('[ERROR] '.$text);
    }

    public static function warn ($text) {
        self::write('[WARN] '.$text);
    }

    public static function text ($text) {
        self::write('[INFO] '.$text);
    }

    private static function write ($string) {
        if (!isset($_SERVER['REMOTE_ADDR'])) {
            echo $string, "\n\r";
        }
        else {
            error_log($string);
        }
    }

}