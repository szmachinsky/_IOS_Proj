<?php
/**
 * Created by JetBrains PhpStorm.
 * User: mamont
 * Date: 25.08.11
 * Time: 16:51
 * To change this template use File | Settings | File Templates.
 */

class Model_Channels
{
    private $parsers = array();


    public function buidlChannelsList()
    {

        $channelsData = Url::getInstance()->getChannelsData();

        $channelsXML = simplexml_load_string($channelsData);
        if (false === $channelsXML) {
            new Error('Unable read channels list as XML');
        }

        unset($channelsData);

        if (!isset($channelsXML->{'channel'}) || count($channelsXML->{'channel'}) <= 0) {
            new Error('There is no table of contents channels');
        }

        $channels = array();
        $resultList = array();

        // Парсим структуру каналов.
        foreach ($channelsXML->{'channel'} as $channel) {
            $tmp = array();
            $tmp['id'] = (string)$channel['id'];

            if (isset($channel->{'display-name'})) {
                $tmp['name'] = (string)$channel->{'display-name'};
            } else {
                new Error('For display-name is missing ' . json_encode($channel));
            }
            if (isset($channel->{'icon'}['src'])) {
                $tmp['logo'] = (string)$channel->{'icon'}['src'];
            } else {
//                Log::warn('For there is no channel logo image');
				continue;
            }

            $tmp['programme'] = array();

            $channels[$tmp['id']] = $tmp;
        }

        if (!isset($channelsXML->{'programme'}) || count($channelsXML->{'programme'}) <= 0) {
            new Error('There is no program guide');
        }

        // Парсим структуру программы передач
        foreach ($channelsXML->{'programme'} as $programme) {
            $tmp = array();
            if (!isset($programme['channel']) || !isset($channels[(string)$programme['channel']])) {
                // Пропускаем передачи для которых не установлен канал или он не существует в оглавлении
                continue;
            }

            if (isset($programme['start'])) {
                $parsedDate = new DateTime((string)$programme['start']);
                $tmp['start'] = $parsedDate->format('U');
            }

            if (isset($programme['stop'])) {
                $parsedDate = new DateTime((string)$programme['stop']);
                $tmp['stop'] = $parsedDate->format('U');
            }

            if (isset($programme->{'title'})) {
                $tmp['title'] = (string)$programme->{'title'};
            }

            if (isset($programme->{'desc'}) && (string)$programme->{'desc'} !== '') {
                $tmp['desc'] = (string)$programme->{'desc'};
            }

            if (isset($programme->{'category'}) && (string)$programme->{'category'} !== '') {
                $tmp['category'] = $this->fixCategory((string)$programme->{'category'});
                if (false === $tmp['category']) {
                    echo (string)$programme->{'category'}, "\n";
                    unset($tmp['category']);
                }
            }

            $channels[(string)$programme['channel']]['programme'][$tmp['start']] = $tmp;

        }

        unset($channelsXML);

        // Сортируем программу передач и выкачиваем иконку канала
        $updateTime = time();
        $curDate = $updateTime - 86400;

        foreach ($channels as $channel) {
            ksort($channels[$channel['id']]['programme']);

            // Проверяем на изменение логотип
            if (isset($channel['logo'])) {
                // Получаем имя файла логотипа
                $channels[$channel['id']]['logo'] = Url::getInstance()->getChannelLogo($channel['id'], $channel['logo']);
            }

            // Читаем файл с предыдущей программой
            $filePath = JSON_PATH . '/' . $channel['id'] . '.json';
            $channelOldData = File::readFile($filePath);
            if (false === $channelOldData) {
                $channelOldData = array();
            } else {
                $channelOldData = json_decode($channelOldData, true);
            }

            $programme = array();
            // Сохраняем передачи которые начинаются от текущего момента -1 сутки для часовых поясов -24 часа
			if (count($channelOldData) > 0) {
				foreach ($channelOldData as $program) {
					if ($program['start'] > $curDate) {
						$programme[$program['start']] = $program;
					}
				}
			}

            unset($channelOldData);
            // Дописываем новую программу передач
            foreach ($channels[$channel['id']]['programme'] as $program) {
                if ($program['start'] > $curDate) {
                    $programme[$program['start']] = $program;
                }
            }
            // Очищаем данные программы передач
            $channels[$channel['id']]['programme'] = array();

            // Сортируем программу передач в порядке нарастания
            ksort($programme);


            // Сохраняем текущую программу передач для последующего сравнения
            if (!File::saveFile($filePath, json_encode(array_values($programme)))) {
                Log::Error('Unable to write file ' . $filePath);
                return false;
            }

            //            $channels[$channel['id']]['programme'] = array_values($programme);

            $date = new DateTime();

            foreach ($programme as $time => $programm) {
                $key = $date->setTimestamp($time)->format('Ymd');
                $channels[$channel['id']]['programme'][$key][] = $programm;
            }

            unset($programme);
        }

        if (!is_dir(OUT_PATH)) {
            File::createDir(OUT_PATH);
        }


        foreach ($channels as $channel) {
            $dirPath = OUT_PATH . '/' . $channel['id'];
            File::createDir($dirPath);
            $urls = array();
            foreach ($channel['programme'] as $day => $dayProgramm) {
                $fileName = $channel['id'] . '_' . $day;
                $filePath = $dirPath . '/' . $fileName . '.json';
                File::saveFile($filePath, json_encode($dayProgramm));
                $urls[] = BASE_URI . $channel['id'] . '/' . $fileName . '.json.bz2';
            }

            $channelData = array();
            $channelData['id'] = $channel['id'];
            $channelData['name'] = $channel['name'];
            $channelData['updated'] = time();
            $channelData['url'] = $urls;

            $picPath = CHANNELS_LOGO_PATH . '/' . $channel['logo'];
            $picData = File::readFile($picPath);
            $picPath = OUT_PATH . '/' . $channel['logo'];
            File::saveFile($picPath, $picData);

            if (is_file($picPath)) {
                $channelData['logo'] = BASE_URI . $channel['logo'];
            }

            $resultList[] = $channelData;
        }

        if (count($resultList) > 0) {
            $filePath = OUT_PATH . '/index.json';
            File::saveFile($filePath, json_encode($resultList));
            exit (0);
        }
    }

    /**
     * @param SimpleXMLElement $xml
     * @param array            $settings
     *
     * @return array|boolean
     */

    private function loadChannel($xml, &$settings)
    {
        $parser = null;

        if (isset($settings['parser'])) {
            $parserName = $settings['parser'];
        }

        if ($parserName == '') {
            $parserName = 'Default';
        }

        $parserName = ucwords(strtolower($parserName));

        if (isset($this->parsers[$parserName])) {
            $parser = $this->parsers[$parserName];
        } else {
            $class = 'Model_Channel_Parser_' . $parserName;
            if (!class_exists($class, true)) {
                Log::warn('Unable to call a controller ' . $class . ' ::work()');
            }
            $parser = new $class;
            $this->parsers[$parserName] = &$parser;
        }

        $result = $parser->{'load'}($xml);

        return $result;
    }

    private function getLocalChannelsList()
    {

        $channelsList = array();

        $db = Db::getInstance();
        $sql = 'SELECT * FROM channels';

        $result = $db->doQuery($sql);
        $result = $db->rowsAssoc($result);

        foreach ($result as $row) {
            $channelsList[$row['channelId']] = $row;
        }

        return $channelsList;

    }

    private function fixCategory($category)
    {
		if ($category == 'Детям') {
			echo 1;
		}
        $fixTable = array(
			'д/с' => 1,
			'д/с.' => 1,
			'д/ф' => 2,
			'д/ф.' => 2,
			'док.кино' => 2,
			'м/с' => 3,
			'м/с.' => 3,
			'м/с' => 3,
			'м/ф' => 4,
			'м/ф.' => 4,
			'мультфильмы' => 4,
			'т/с' => 5,
			'т/с.' => 5,
			'телесериалы' => 5,
			'сериал' => 5,
			'х/ф' => 6,
			'х/ф.' => 6,
			'кино' => 6,
			'художественный фильм' => 6,
            'спорт' => 7, // Спортивная программа
            'новости' => 8, // Новостная программа
            'музыка' => 9, // Музыкальная программа


        );

		$category = mb_strtolower($category,'UTF-8');

        if (isset($fixTable[$category])) {
            return $fixTable[$category];
        }

        return false;
    }

    private function array2json($arr)
    {
        $parts = array();
        $is_list = false;

        if (!is_array($arr)) {
            return;
        }
        if (count($arr) < 1) {
            return '{}';
        }

        //Find out if the given array is a numerical array
        $keys = array_keys($arr);
        $max_length = count($arr) - 1;

        if (($keys[0] == 0) and !empty($keys[$max_length]) and ($keys[$max_length] == $max_length)
        ) { //See if the first key is 0 and last key is length - 1
            $is_list = true;
            for ($i = 0; $i < count($keys); $i++) { //See if each key correspondes to its position
                if ($i != $keys[$i]) { //A key fails at position check.
                    $is_list = false; //It is an associative array.
                    break;
                }
            }
        }
        foreach ($arr as $key => $value) {
            if (is_array($value)) { //Custom handling for arrays
                if ($is_list) {
                    $parts[] = $this->array2json($value);
                } /* :RECURSION: */ else {
                    $parts[] = '"' . $key . '":' . $this->array2json($value);
                } /* :RECURSION: */
            } else {
                $str = '';
                if (!$is_list) {
                    $str = '"' . $key . '":';
                }
                //Custom handling for multiple data types
                if (is_numeric($value)) {
                    $str .= $value;
                } //Numbers
                elseif ($value === false) {
                    $str .= 'false';
                } //The booleans
                elseif ($value === true) {
                    $str .= 'true';
                } else {
                    $str .= '"' . addslashes($value) . '"';
                } //All other things
                // :TODO: Is there any more datatype we should be in the lookout for? (Object?)
                $parts[] = $str;
            }
        }
        $json = implode(',', $parts);
        if ($is_list) {
            return '[' . $json . ']';
        } //Return numerical JSON
        return '{' . $json . '}'; //Return associative JSON
    }

}

