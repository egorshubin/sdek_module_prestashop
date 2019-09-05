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
                </ul>
            </div>
            <h1>{$cities[0][2]}</h1>
            <ul class="sdek-all-wrap">
                {foreach from=$cities item=city}
                    <li><a href="/dostavka-sdek?c=listingPoints&id={$city[1]}">{$city[0]}</a></li>
                {/foreach}
            </ul>
        </div>
    </div>
</div>