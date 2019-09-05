<script type="text/javascript">
    /**
     * автокомплит
     * подтягиваем список городов ajax`ом, данные jsonp в зависмости от введённых символов
     */
    $(function() {
        $("#city").autocomplete({
            source : function(request, response) {
                $.ajax({
                    url : "https://api.cdek.ru/city/getListByTerm/jsonp.php?callback=?",
                    dataType : "jsonp",
                    data : {
                        q : function() {
                            return $("#city").val()
                        },
                        name_startsWith : function() {
                            return $("#city").val()
                        }
                    },
                    success : function(data) {
                        response($.map(data.geonames, function(item) {
                            return {
                                label : item.name,
                                value : item.name,
                                id : item.id
                            }
                        }));
                    }
                });
            },
            minLength : 1,
            select : function(event, ui) {
                //console.log("Yep!");
                $('#receiverCityId').val(ui.item.id);
            }
        });

        /**
         * ajax-запрос на сервер для получения информации по доставке
         */
        $('#cdek').submit(function() {

            var formData = form2js('cdek', '.', true, function(node) {
                if(node.id && node.id.match(/callbackTest/)) {
                    return {
                        name : node.id,
                        value : node.innerHTML
                    };
                }
            });
            var formDataJson = JSON.stringify(formData);
            // console.log(JSON.stringify(formData));
//            document.getElementById('testArea').innerHTML = 'Отправляемые данные: <br />' + JSON.stringify(formData, null, '\t');

            $.ajax({
                url : 'https://api.cdek.ru/calculator/calculate_price_by_jsonp.php',
                jsonp : 'callback',
                data : {
                    "json" : formDataJson
                },
                type : 'GET',
                dataType : "jsonp",
                success : function(data) {
                    console.log(data);
                    if(data.hasOwnProperty("result")) {
                        document.getElementById('resArea').innerHTML =
							'<p>Цена доставки: <span class="bold">' + data.result.price + '&nbsp;руб.</span></p>' +
							'<p>Срок доставки: <span class="bold">' + data.result.deliveryPeriodMax + '&nbsp;дн. ' + '</span></p>' +
							'<p>Планируемая дата доставки: <span class="bold">' + data.result.deliveryDateMax + '</span></p>' +
							'<p>По тарифу: <span class="bold">Экономичный экспресс склад-склад</span></p><p><span class="bold">Внимание!</span> Окончательная стоимость доставки может отличаться.</p>';
                        if(data.result.hasOwnProperty("cashOnDelivery")) {
                            document.getElementById('resArea').innerHTML = document.getElementById('resArea').innerHTML + 'Ограничение оплаты наличными, от (руб): ' + data.result.cashOnDelivery;
                        }
                    } else {
                        for(var key in data["error"]) {
                            // console.log(key);
                            // console.log(data["error"][key]);
                            document.getElementById('resArea').innerHTML = document.getElementById('resArea').innerHTML+'Код ошибки: ' + data["error"][key].code + '<br />Текст ошибки: ' + data["error"][key].text + '<br /><br />';
                        }
                    }
                }
            });
            return false;
        });
    });

</script>

<div class="sdek-wrapper">
	<div class="sdek-image-wrapper"><img src="/images/extra/sdek-logo.png" alt="Доставка СДЭК"></div>
	<div id="calc-sdek-reveal" class="hidden-lg-up filter-reveal calc-reveal">
		<i class="fa fa-calculator" aria-hidden="true"></i>
		Калькулятор
		<i class="fa fa-chevron-down" aria-hidden="true"></i>
		<i class="fa fa-chevron-up" aria-hidden="true" style="display:none"></i>
	</div>
	<div id="calc-sdek-body" class="calculator-sdek-wrapper"><h3 class="hidden-md-down">Калькулятор</h3>
		<p>Приблизительный расчет стоимости</p>
		{*Город-отправитель: Санкт-Петербург<br/>*}
		<label for="city">Город-получатель: </label>
		<div class="ui-widget">
			<input id="city"/>
			<br/>
		</div>
		<form action="" id="cdek" method="GET"/>
		<!-- Версия API -->
		<input name="version" value="1.0" hidden/>
		<!-- Планируемая дата доставки (ГГГГ-ММ-ДД) -->
		<input name="dateExecute" value="2017-11-22" hidden/>

		<!-- Для получения логина/пароля (в т.ч. тестового) обратитесь к разработчикам СДЭК -->
		{*<input name="authLogin" value="262a88bfdd442cd966058aa28bb7453b" hidden />
		<input name="secure" value="38c24307e870cf48921c4c3f608d5344" hidden />*}

		<!-- Город-отправитель, Санкт-Петербург -->
		{*<input name="senderCityId" value="137" hidden/>*}
		<!-- Город-получатель -->
		<input name="receiverCityId" id="receiverCityId" value="" hidden/>

		{*<input name="tariffId" value="137" hidden />*}
		<!-- id тарифа, Посылка склад-дверь 137, требутеся авторизация, параметры authLogin и secure -->
		<!--<input name="tariffId" value="11" hidden />-->
		<!-- id тарифа, Экспресс-лайт склад-дверь 11, не требует авторизации -->
		<input name="tariffId" value="5" hidden/>

		<!-- Используется для задания списка тарифов с приоритетами, подробнее см. документацию. -->
		<!--<input name="tariffList[0].priority" value="1" hidden />-->
		<!--<input name="tariffList[0].id" value="137" hidden />-->
		<!-- <input name="tariffList[1].priority" value="2" hidden /> -->
		<!-- <input name="tariffList[1].id" value="136" hidden /> -->

		<!-- режим доставки, склад-дверь -->
		<input name="modeId" value="3" hidden/>
		<!-- Вес места, кг.  -->
		<div><label>Вес,&nbsp;кг.</label>
			<input name="goods[0].weight" value="3"/></div>
		<!-- Длина места, см. -->
		<div><label>Длина,&nbsp;см.</label>
			<input name="goods[0].length" value="120"/></div>
		<!-- Ширина места, см. -->
		<div><label>Ширина,&nbsp;см.</label>
			<input name="goods[0].width" value="50"/></div>
		<!-- Высота места, см. -->
		<div><label>Высота,&nbsp;см.</label>
			<input name="goods[0].height" value="21"/></div>

		<!-- Вес места, кг.-->
		<!--<input name="goods[1].weight" value="0.1" hidden />-->
		<!-- объём места, длина*ширина*высота, метры кубические -->
		<!--<input name="goods[1].volume" value="0.001" hidden />-->

		<input type="submit" value="Посчитать">
		</form></div>
{*<pre>
			<code id="testArea">
			</code>
		</pre>*}
	<div id="resArea" class="sdek-code-wrapper"></div>
</div>