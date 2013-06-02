<?php
class File
{

    public static function saveFile($filePath, $data)
    {
        // Создаем локфайл для работы с данными
        $lockFP = self::lockFile($filePath);

        // Проверяем что локировка установлена корректно
        if (false === $lockFP) {
            new Error('cannot create a lock on '.$filePath);
        }

        // Устанвливаем маску прав чо бы получить права 664
        umask(0113);

        $tmpFileName = tempnam(dirname($filePath), 'tmp');
        $tmpFile = fopen($tmpFileName, "wb");

        if (!fwrite($tmpFile, $data)) {
            Log::warn('cannot write to file ', $tmpFileName);
        }

        fclose($tmpFile);

        if (file_exists($filePath) && !is_writable($filePath)) {
            Log::warn('File is write protect ', $filePath);
            unlink($tmpFileName);
            return false;
        }

        if (rename($tmpFileName, $filePath) === false) {
            unlink($tmpFileName);
            Log::warn('error moving datafile '.$filePath);
        }

        chmod($filePath,0664);

        self::unlockFile($lockFP, $filePath);

        return true;
    }

    public static function readFile($filePath)
    {
        // Создаем локфайл для работы с данными
        $lockFP = self::lockFile($filePath);

        // Проверяем что локировка установлена корректно
        if (false === $lockFP) {
            new Error('cannot create a lock on '.$filePath);
        }

        if (!file_exists($filePath) || !is_readable($filePath)) {
            Log::warn('File is not exists or read protected '. $filePath);
            return false;
        }

        $data = file_get_contents($filePath);

        self::unlockFile($lockFP, $filePath);

        return $data;
    }

    public static function createDir($dirPath) {
		if (!is_dir($dirPath)) {
			$mask = umask(0022);
			mkdir($dirPath);
			chmod($dirPath, 0755);
			umask($mask);
		}
    }

    private static function lockFile($filePath)
    {
        umask(0113);
        $lockFileName = LOCKS_PATH . '/' . crc32($filePath) . '.lock';
        $fp = fopen($lockFileName, 'a+');
        if (false === $fp) {
            new Error('lock error');
        }
        while (!flock($fp, LOCK_EX | LOCK_NB)) {
            usleep(round(rand(2, 10) * 100));
        }
        chmod($lockFileName,0664);
        return $fp;
    }

    private static function unlockFile($fp, $filePath)
    {
        $lockFileName = LOCKS_PATH . '/' . crc32($filePath) . '.lock';
        if (!is_resource($fp)) {
            new Error('error unlock user');
        }

        flock($fp, LOCK_UN);
        fclose($fp);

        if (file_exists($lockFileName) && is_writable($lockFileName)) {
            unlink($lockFileName);
        }
        else {
            Log::warn('Cannot remove lock file '.$lockFileName);
        }

    }

}