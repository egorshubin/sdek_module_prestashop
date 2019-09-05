<div class="container">
    <div class="row">
        <div class="col-lg-3">

            {block name="calculator-sdek"}
                {include file="modules/sdek/views/templates/hook/calculator.tpl"}
            {/block}

        </div>
        <div class="col-lg-9">
            <h1>Пункты выдачи СДЭК</h1>
            <ul class="sdek-regions-wrap sdek-all-wrap">
                {foreach from=$regions item=region}
                    <li><a href="/dostavka-sdek?c=listingCities&id={$region[1]}">{$region[0]}</a></li>
                {/foreach}
            </ul>
        </div>
    </div>
</div>