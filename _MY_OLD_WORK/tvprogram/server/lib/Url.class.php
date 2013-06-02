<?php
/**
 * Created by JetBrains PhpStorm.
 * User: mamont
 * Date: 25.08.11
 * Time: 16:04
 * To change this template use File | Settings | File Templates.
 */

class Url
{
	/**
	 * @var Url $instance
	 */
	protected static $instance = null;

	/**
	 * Строка для хранения авторизационных cookie
	 * @var bool
	 */
	protected $cookie = false;


	/**
	 * @static
	 * @return Url
	 */

	public static function &getInstance()
	{
		if (!self::$instance instanceof Url) {
			self::$instance = new self ();
		}
		return self::$instance;
	}

	/**
	 * Получает список каналов с сервера и возвращает массив каналов для обработки
	 * @return array
	 */
	public function getChannelsData()
	{

		$filePath = XML_PATH . '/index.xml';
		$md5Path = XML_PATH . '/index.xml.md5';

		if (DEBUG < 2 || !is_file($filePath)) {
			// Получаем индексную XML с сервера
			$channelsData = $this->get(XML_URL);
			if (false !== $channelsData) {
				$oldMd5Checksumm = File::readFile($md5Path);
				$newMd5Checksumm = md5($channelsData);
				if ($oldMd5Checksumm == $newMd5Checksumm) {
					Log::warn('Checksums are identical. Update is not need');
					exit(1);
				}
				// Сохраняем её на сервере
				File::saveFile($filePath, $channelsData);
				File::saveFile($md5Path, $newMd5Checksumm);
			}
			else {
				new Error('Error loading from remote server');
			}
		}
		else {
			$channelsData = File::readFile($filePath);
		}

		return $channelsData;
	}

	public function getChannelLogo($id, $uri)
	{

		if (!is_dir(CHANNELS_LOGO_PATH)) {
			$mask = umask(0022);
			mkdir(CHANNELS_LOGO_PATH);
			chmod(CHANNELS_LOGO_PATH, 0755);
			umask($mask);
		}

		$fileSlice = parse_url($uri);
		$fileSlice = pathinfo($fileSlice['path']);
		$fileSlice = $id . '.' . $fileSlice['extension'];

		$filePath = CHANNELS_LOGO_PATH . '/' . $fileSlice;

		if (DEBUG < 2 || !is_file($filePath)) {

			$oldPic = File::readFile($filePath);
			// Загружаем данные по каналу
			$data = Url::getInstance()->get($uri);

			if (md5($oldPic) !== md5($data)) {
				// Сохраняем её на сервере
				File::saveFile($filePath, $data);
			}
		}

		return $fileSlice;
	}

	/**
	 * Получает данные из запроса
	 * @static
	 * @param string $url
	 * @return string
	 */

	public function get($url)
	{
		$ch = curl_init();
		curl_setopt($ch, CURLOPT_HTTPAUTH, CURLAUTH_BASIC);
		//        curl_setopt($ch, CURLOPT_USERPWD, XML_USERNAME . ':' . XML_PASSWORD);
		curl_setopt($ch, CURLOPT_ENCODING, "gzip");
		//        curl_setopt($ch, CURLOPT_HEADER, true);
		curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
		curl_setopt($ch, CURLOPT_URL, $url);
		$result = curl_exec($ch);

		if (false !== $result) {
			return $result;
		}
		else {
			return false;
		}
	}

}
