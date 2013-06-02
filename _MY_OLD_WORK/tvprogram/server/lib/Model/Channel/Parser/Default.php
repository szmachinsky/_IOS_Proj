<?php
/**
 * User: mamont
 * Date: 25.08.11
 * Time: 17:42
 */

class Model_Channel_Parser_Default {

    /**
     * @param string $xml
     * @return array|bool
     */

    function parse($xml) {

        $data = simplexml_load_string($xml);

        $result = array();

        // Идентификатор канала
        if (isset($data->{'channel'})) {
            $result['channel'] = $this->parseChannel($data->{'channel'});
        }
        else {
            return false;
        }

        if (isset($data->{'programme'})) {

            foreach ($data->{'programme'} as $programm) {
                $result['programme'][] = $this->parseProgramme($programm);
            }
        }

        if (isset($data->{'channel'}->{'logo'})) {
            $result['logo'] = (string)$data->{'channel'}->{'logo'};
        }

        return $result;
    }


    /**
     * Разбирает заголовки канала
     * @param SimpleXMLElement $xmlNode
     * @return array
     */

    private function parseChannel($xmlNode)
    {
        $result = array();

        // Идентификатор канала
        if (isset($xmlNode['id'])) {
            $result['id'] = (string)$xmlNode['id'];
        }

        // Имя канала
        if (isset($xmlNode->{'display-name'})) {
            $result['display-name'] = (string)$xmlNode->{'display-name'};
        }

        // Имя канала
        if (isset($xmlNode->{'logo'})) {
            $result['logo'] = (string)$xmlNode->{'logo'};
        }

        return $result;
    }

    /**
     * @param SimpleXMLElement $xmlNode
     * @return array
     */
    private function parseProgramme($xmlNode)
    {

        $dateFormat = 'YmdHis O';
        $result = array();

        if (isset($xmlNode['start'])) {
            $dateTime = (string)$xmlNode['start'];
            $parsedDate = DateTime::createFromFormat($dateFormat, $dateTime);
            $result['start'] = $parsedDate->format('U');
        }

        if (isset($xmlNode['stop'])) {
            $dateTime = (string)$xmlNode['stop'];
            $parsedDate = DateTime::createFromFormat($dateFormat, $dateTime);
            $result['stop'] = $parsedDate->format('U');
        }

        if (isset($xmlNode->{'title'})) {
            $result['title'] = (string)$xmlNode->{'title'};
        }

        if (isset($xmlNode->{'sub-title'})) {
            $subtitle = (string)$xmlNode->{'sub-title'};
            // Проверяем на наличие слова "серия" в названии передачи
            if (stripos($subtitle, 'серия') !== false) {
                $matches = array();
                // Выделяем подстоку "X серия"
                if (preg_match('([^\s()]*?\s*серия)', $subtitle, $matches) !== 0) {
                    $result['title'] .= ' ' . $matches[0];
                }
            }
        }

        if (isset($xmlNode->{'category'}) && mb_strlen((string)$xmlNode->{'category'}) > 0) {
            $result['category'] = Model_Channel::fixCategory((string)$xmlNode->{'category'});
            if (false === $result['category']) {
                unset($result['category']);
            }
        }

        if (isset($xmlNode->{'desc'})) {
            $result['desc'] = (string)$xmlNode->{'desc'};
        }

        if (isset($xmlNode->{'anons'}->genre)) {
            $result['genre'] = (string)$xmlNode->{'anons'}->genre;
        }

        if (isset($xmlNode->{'anons'}->text)) {
            $result['desc'] = (string)$xmlNode->{'anons'}->text;
        }

        return $result;
    }

}