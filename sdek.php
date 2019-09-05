<?php
if (!defined('_PS_VERSION_'))
{
    exit;
}
class Sdek extends Module
{
    public function __construct()
    {
        $this->name = 'sdek';
        $this->tab = 'front_office_features';
        $this->version = '1.0.0';
        $this->author = 'Egor Shubin';
        $this->need_instance = 0;
        $this->ps_versions_compliancy = array('min' => '1.6', 'max' => _PS_VERSION_);
        $this->bootstrap = true;

        parent::__construct();

        $this->displayName = $this->l('Sdek addresses');
        $this->description = $this->l('Add Sdek addresses');

        $this->confirmUninstall = $this->l('Are you sure you want to uninstall?');

        if (!Configuration::get('MYMODULE_NAME'))
            $this->warning = $this->l('No name provided');
    }

    public function install()
    {
        if (Shop::isFeatureActive())
            Shop::setContext(Shop::CONTEXT_ALL);

        return parent::install() &&
            $this->registerHook('displaySdekHook') &&
            Configuration::updateValue('MYMODULE_NAME', 'my friend');
    }

    public function uninstall()
    {
        if (!parent::uninstall())
            return false;
        return true;
    }

//    public function hookdisplayHeader()
//    {
//        $this->context->controller->addJS('modules/sdek/views/js/form2js.js', 150);
//        $this->context->controller->addJS('modules/sdek/views/js/json2.js', 150);
//    }

    public function hookdisplaySdekHook()
    {
        if ($this->parseRequest() == "listingCities") {
            $id = $_GET['id'];
            $this->context->smarty->assign(
                array(
                    'cities' => $this->getCities($id)
                )
            );
            return $this->display(__FILE__, 'cities.tpl');

        }
        else if ($this->parseRequest() == "listingPoints") {
            $id = $_GET['id'];
            $this->context->smarty->assign(
                array(
                    'points' => $this->getPoints($id)
                )
            );
            return $this->display(__FILE__, 'points.tpl');
        }

        else if ($this->parseRequest() == "page") {
            $id = $_GET['id'];
            $cityid = $_GET['cityid'];

            $this->context->smarty->assign(
                array(
                    'points' => $this->getPoints($cityid),
                    'attrs' => $this->getPage($id, $cityid)
                )
            );
            return $this->display(__FILE__, 'page.tpl');
        }

        else {
            $this->context->smarty->assign(
                array(
                    'regions' => $this->getRegions()
                )
            );
            return $this->display(__FILE__, 'index.tpl');
        }
    }

    public function parseRequest() {
        if (isset($_GET['c'])) {
            return $_GET['c'];
        }
        return false;
    }


    public function getRegions()
    {
        $xmlFile = simplexml_load_file("https://integration.cdek.ru/pvzlist.php?countryid=1");
        if (!$xmlFile) {
            $xmlFile = simplexml_load_file("https://integration.cdek.ru/pvzlist.php");
            if ((!$xmlFile)) {
                echo $this->getNoFile();
                exit();
            }
        }

        $regionsFirst = [];
        $regions = [];
        $regionsFinal = [];
        foreach($xmlFile->Pvz as $pvz) {
            if ((!array_key_exists(strval($pvz["RegionCode"]), $regionsFirst)) && ($pvz["CountryCode"] == 1)) {
                $regionsFirst += [strval($pvz["RegionCode"]) => [strval($pvz["RegionCode"]), strval($pvz["RegionName"])]];
            }
        }
        foreach($regionsFirst as $region) {
            $string = "{$region[1]}|{$region[0]}";
            array_push($regions, $string);
        }
        sort($regions);

        foreach($regions as $region) {
            $subarray = explode("|", $region);
            array_push($regionsFinal, $subarray);
        }

        return $regionsFinal;
    }

    public function getCities($id) {
        $xmlFile = simplexml_load_file("https://integration.cdek.ru/pvzlist.php?regionid={$id}");
        if (!$xmlFile) {
            $xmlFile = simplexml_load_file("https://integration.cdek.ru/pvzlist.php");
            if ((!$xmlFile)) {
                echo $this->getNoFile();
                exit();
            }
        }
        $citiesFirst = [];
        $cities = [];
        $citiesFinal = [];
        foreach($xmlFile->Pvz as $pvz) {
            if ((!array_key_exists(strval($pvz["CityCode"]), $citiesFirst)) && ($pvz["RegionCode"] == $id)) {
                $citiesFirst += [strval($pvz["CityCode"]) => [strval($pvz["CityCode"]), strval($pvz["City"]), strval($pvz["RegionName"])]];
            }
        }
        foreach($citiesFirst as $city) {
            $string = "{$city[1]}|{$city[0]}|{$city[2]}";
            array_push($cities, $string);
        }
        sort($cities);

        foreach($cities as $city) {
            $subarray = explode("|", $city);
            array_push($citiesFinal, $subarray);
        }

        return $citiesFinal;
    }

    public function getPoints($id) {
        $xmlFile = simplexml_load_file("https://integration.cdek.ru/pvzlist.php?cityid={$id}");
        if (!$xmlFile) {
            $xmlFile = simplexml_load_file("https://integration.cdek.ru/pvzlist.php");
            if ((!$xmlFile)) {
                echo $this->getNoFile();
                exit();
            }
        }
        $pointsFirst = [];
        $points = [];
        $pointsFinal = [];
        foreach($xmlFile->Pvz as $pvz) {
            if ((!array_key_exists(strval($pvz["Code"]), $pointsFirst)) && ($pvz['CityCode'] == $id)) {
                $pointsFirst += [strval($pvz["Code"]) => [
                    'Code' => strval($pvz["Code"]),
                    'Name' => strval($pvz["Name"]),
                    'City' => strval($pvz["City"]),
                    'coordY' => strval($pvz["coordY"]),
                    'coordX' => strval($pvz["coordX"]),
                    'Address' => strval($pvz["Address"]),
                    'Phone' => strval($pvz["Phone"]),
                    'WorkTime' => strval($pvz["WorkTime"]),
                    'RegionCode' => strval($pvz["RegionCode"]),
                    'RegionName' => strval($pvz["RegionName"])
                ]];
            }
        }
        foreach($pointsFirst as $point) {
            $string = "{$point['Name']}|{$point['Code']}|{$id}|{$point['City']}|{$point['coordY']}|{$point['coordX']}|{$point['Address']}|{$point['Phone']}|{$point['WorkTime']}|{$point['RegionCode']}|{$point['RegionName']}";
            array_push($points, $string);
        }
        sort($points);

        foreach($points as $point) {
            $subarray = explode('|', $point);
            array_push($pointsFinal, $subarray);
        }
//        var_dump($subarray);
        return $pointsFinal;
    }

    public function getPage($id, $city_id) {
        $xmlFile = simplexml_load_file("https://integration.cdek.ru/pvzlist.php?cityid={$city_id}");
        if (!$xmlFile) {
            $xmlFile = simplexml_load_file("https://integration.cdek.ru/pvzlist.php");
            if ((!$xmlFile)) {
                echo $this->getNoFile();
                exit();
            }
        }
        foreach($xmlFile->Pvz as $pvz) {
            if (strval($pvz["Code"]) == $id) {
                $array = [
                    'Code' => strval($pvz["Code"]),
                'Name' => strval($pvz["Name"]),
                'RegionCode' => strval($pvz["RegionCode"]),
                'RegionName' => strval($pvz["RegionName"]),
                'CityCode' => strval($pvz["CityCode"]),
                'City' => strval($pvz["City"]),
                'WorkTime' => strval($pvz["WorkTime"]),
                'Address' => strval($pvz["Address"]),
                'FullAddress' => strval($pvz["FullAddress"]),
                'AddressComment' => strval($pvz["AddressComment"]),
                'Phone' => strval($pvz["Phone"]),
                'Email' => strval($pvz["Email"]),
                'Note' => strval($pvz["Note"]),
                'coordX' => strval($pvz["coordX"]),
                'coordY' => strval($pvz["coordY"]),
                'Type' => strval($pvz["Type"]),
                'HaveCashless' => strval($pvz["HaveCashless"]),
                'NearestStation' => strval($pvz["NearestStation"]),
                'MetroStation' => strval($pvz["MetroStation"]),
                'OfficeImage' => $pvz->OfficeImage,
                    'WeightLimit' => $pvz->WeightLimit
                ];

                break;
            }
        }
        return $array;
    }

    public function getNoFile() {
        $this->context->smarty->assign(
            array(
                'message' => 'Извините, информация временно недоступна. Вы можете ознакомиться со списком офисов СДЭК по этому адресу: https://www.cdek.ru/contacts/city-list.html'
            )
        );
        return $this->display(__FILE__, 'error.tpl');
    }
}