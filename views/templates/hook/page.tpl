<div class="container">
    <div class="row">
        <div class="col-lg-3">
            {block name="calculator-sdek"}
                {include file="modules/sdek/views/templates/hook/calculator.tpl"}
            {/block}
            {*<ul class="sdek-all-wrap">
                {foreach from=$points item=point}
                    <li><a href="/dostavka-sdek?c=page&id={$point[1]}&cityid={$point[2]}">{$point[0]}</a></li>
                {/foreach}
            </ul>*}
        </div>
        <div class="col-lg-9">
            <div class="breadcrumbs-sdek">
                <ul>
                    <li><a href="/dostavka-sdek">Все регионы</a></li>

                    <li><i class="fa fa-long-arrow-left" aria-hidden="true"></i></li>
                    <li><a href="/dostavka-sdek?c=listingCities&id={$attrs.RegionCode}">{$attrs.RegionName}</a></li>
                    <li><i class="fa fa-long-arrow-left" aria-hidden="true"></i></li>
                    <li><a href="/dostavka-sdek?c=listingPoints&id={$attrs.CityCode}">{$attrs.City}</a></li>
                </ul>
            </div>
            <h1>{$attrs.Name}</h1>
            <p>{$attrs.Address}</p>
            <div id="map" class="yandex-sdek-map"></div>
            <h2>Контакты:</h2>
            <p>{$attrs.FullAddress}</p>
            <p>{$attrs.AddressComment}</p>
            {if $attrs.NearestStation != " "}
                <p><span class="bold">Остановка:</span> {$attrs.NearestStation}</p>
            {/if}
            {if $attrs.MetroStation != " "}
                <p><span class="bold">Станция метро:</span> {$attrs.MetroStation}</p>
            {/if}


            {if $attrs.Phone != " "}
            <p><span class="bold">Телефон:</span> {$attrs.Phone}</p>
            {/if}
            {if $attrs.Email != ""}
            <p><span class="bold">Email:</span> {$attrs.Email}</p>
            {/if}
            {if $attrs.WorkTime != " "}
            <h2>Время работы</h2>
            <p>{$attrs.WorkTime}</p>
            {/if}
            {if $attrs.WeightLimit}
                <h3>Органичения по весу:</h3>
                <p>{$attrs.WeightLimit.WeightMin} - {$attrs.WeightLimit.WeightMax} кг</p>
            {/if}
            <h3>Примечание</h3>
            <p>{$attrs.Note}</p>
            <p><span class="bold">Код:</span> {$attrs.Code}</p>
            {if $attrs.OfficeImage}
                <h3>Фото офиса</h3>
                <div class="office-image-wrap">{foreach from=$attrs.OfficeImage item=url}
                    <p><img src="{$url.url}" width="400" class="office-photo-img"></p>
                {/foreach}</div>
            {/if}

        </div>
    </div>
</div>
<script src="https://api-maps.yandex.ru/2.1/?lang=ru_RU" type="text/javascript">
</script>

    <script type="text/javascript">
        ymaps.ready(init);
        var myMap,
            myPlacemark;
        var coordY = {$attrs.coordY};
        var coordX = {$attrs.coordX};

        function init(){
            myMap = new ymaps.Map("map", {
                center: [coordY, coordX],
                zoom: 16
            });

            myPlacemark = new ymaps.Placemark([coordY, coordX], {
                hintContent: '{$attrs.Address}',
                balloonContent: '<b>{$attrs.Address}</b><br>Тел. <b>{$attrs.Phone}</b><br>{$attrs.WorkTime}'
            });

            myMap.geoObjects.add(myPlacemark);
        }
    </script>