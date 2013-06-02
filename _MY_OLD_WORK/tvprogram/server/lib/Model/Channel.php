<?php
/**
 * Created by JetBrains PhpStorm.
 * User: mamont
 * Date: 26.08.11
 * Time: 13:03
 * To change this template use File | Settings | File Templates.
 */

class Model_Channel
{

    private $parsers = array();

    /**
     * Получает и обрабтывает информацию о передачах по каналу
     * @param $xml
     * @param array $settings
     * @return array|bool
     */
    public function work($xml, &$settings)
    {
        // Получаем данные о канале
        $channelData = Url::getInstance()->getChannelData($xml);
        $channelMD5 = md5($channelData);
        // Если данные не изменились
        if ($settings['md5'] == $channelMD5) {
            return false;
        }

        // Получаем парсер для канала исходя из его настроек
        $parser = $this->getParser($settings);
        /**
         * @var Model_Channel_Parser_Default $parser
         */
        $channelData = $parser->parse($channelData);

        $filePath = JSON_PATH . '/' . $settings['id'] . '.json';
        $channelOldData = File::readFile($filePath);
        if (false === $channelOldData) {
            $channelOldData = array();
        }
        else {
            $channelOldData = json_decode($channelOldData, true);
        }

        $updateTime = time();
        $curDate = $updateTime - 86400;
        $programme = array();

        // Отбрасываем передачи которые уже прошли.
        foreach ($channelOldData as $program) {
            if ($program['start'] > $curDate) {
                $programme[$program['start']] = $program;
            }
        }

        unset($channelOldData);

        // Дописываем в программу новые передачи
        foreach ($channelData['programme'] as $program) {
            $programme[$program['start']] = $program;
        }

        ksort($programme);
        $channelData['programme'] = array_values($programme);

        if (!File::saveFile($filePath, json_encode($channelData['programme']))) {
            Log::Error('Unable to write file '.$filePath);
            return false;
        }

        // Обновляем информацию о канале в БД
        $this->updateInfo($settings['id'],$channelMD5,$updateTime);

        // Выкачиваем лого канала
        Url::getInstance()->getChannelLogo($settings['id'],$channelData['logo']);

        // Возвращаем массив содержащий новый набор данных
        return array(
            'md5' => $channelMD5,
            'lastUpdate' => $updateTime,
        );
    }

    /**
     * Добавляет информацию о новом канале в базу данных
     * @param SimpleXMLElement $xmlSpec
     * @return boolean
     */
    public function addNew($xmlSpec)
    {

        $db = Db::getInstance();

        $sql = 'INSERT INTO channels
                (channelId,channelName,md5,lastUpdate,enabled)
                VALUES
                (\'' . $db->esc((string)$xmlSpec->{'ChannelID'}) . '\',\'' . $db->esc((string)$xmlSpec->{'Channel'}) . '\',\'\',0,0)';

        $res = $db->doQuery($sql);
        if (false === $res) {
            return false;
        }
        return true;
    }

    /**
     * Обновляет информацию о канале в базе данных
     * @param string $channelId
     * @param string $md5
     * @param int $updateTime
     * @return boolean
     */
    public function updateInfo($channelId, $md5,$updateTime)
    {

        $db = Db::getInstance();

        $sql = 'UPDATE channels
                SET md5=\'' . $db->esc($md5) . '\', lastUpdate=\''.$db->esc($updateTime).'\'
                WHERE id=\'' . $db->esc($channelId) . '\'';

        $res = $db->doQuery($sql);
        if (false === $res) {
            return false;
        }
        return true;
    }

    private function getParser($settings)
    {
        $parser = null;
        $parserName = 'Default';

        // Если указан парсер и он валиден
        if (isset($settings['parser']) && isset($settings['parser'][0])) {
            $parserName = $settings['parser'];
        }
        else {
            Log::warn('Parser for channel ' . $settings['channelId'] . ' is invalid');
        }

        $parserName = ucwords(strtolower($parserName));

        if (isset($this->parsers[$parserName])) {
            $parser = $this->parsers[$parserName];
        }
        else {
            $class = 'Model_Channel_Parser_' . $parserName;
            if (!class_exists($class, true)) {
                Log::warn('Unable to call a controller ' . $class . ' ::work()');
            }
            $parser = new $class;
            $this->parsers[$parserName] = &$parser;
        }

        return $parser;
    }


    public static function fixCategory($category)
    {
        $fixTable = array('Д/с' => 1, 'Д/с.' => 1, 'Д/ф' => 2, 'Д/ф.' => 2, 'M/с' => 3, 'M/с.' => 3, 'М/с' => 3, 'М/ф' => 4, 'М/ф.' => 4, 'Т/с' => 5, 'Т/с.' => 5, 'Х/ф' => 6, 'Х/ф.' => 6,);

        if (isset($fixTable[$category])) {
            return $fixTable[$category];
        }

        return false;
    }


}