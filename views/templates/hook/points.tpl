<div class="container">
    <div class="row">
        <div class="col-lg-3">
            {block name="calculator-sdek"}
                {include file="modules/sdek/views/templates/hook/calculator.tpl"}
            {/block}
        </div>
        <div class="col-lg-9">
            <div class="breadcrumbs-sdek">
                <ul>
                    <li><a href="/dostavka-sdek">Все регионы</a></li>
                    <li><i class="fa fa-long-arrow-left" aria-hidden="true"></i></li>
                    <li><a href="/dostavka-sdek?c=listingCities&id={$points[0][9]}">{$points[0][10]}</a></li>
                </ul>
            </div>
            <h1>{$points[0][3]}</h1>
            <div id="map" class="yandex-sdek-map"></div>
            <ul class="sdek-all-wrap">

                {foreach from=$points item=point}
                    <li><a href="/dostavka-sdek?c=page&id={$point[1]}&cityid={$point[2]}">{$point[0]}</a></li>
                {/foreach}
            </ul>
        </div>
    </div>
</div>
<script src="https://api-maps.yandex.ru/2.1/?lang=ru_RU" type="text/javascript">
</script>

<script type="text/javascript">
    ymaps.ready(init);
    var myMap,
        myPlacemark;
    var coordY = {$points[0][4]};
    var coordX = {$points[0][5]};

    function init(){
        myMap = new ymaps.Map("map", {
            center: [coordY, coordX],
            zoom: 10
        });

        {foreach from=$points item=point}
            addPlacemarks({$point[4]}, {$point[5]}, "{$point[1]}", {$point[2]}, "{$point[6]}", "{$point[7]}", "{$point[8]}");

        {/foreach}
    }

    function addPlacemarks(coordY, coordX, pageId, cityId, address, phone, workTime) {
        myPlacemark = new ymaps.Placemark([coordY, coordX], {
            hintContent: address,
            balloonContent: '<b><a href="/dostavka-sdek?c=page&id=' + pageId + '&cityid=' + cityId + '">' + address + '</a></b><br>Тел. <b>' + phone + '</b><br>' + workTime
        });

        myMap.geoObjects.add(myPlacemark);
    }
</script>