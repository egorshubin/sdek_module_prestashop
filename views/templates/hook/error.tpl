<div class="container">
    <div class="row">
        <div class="col-lg-3">
            {block name="calculator-sdek"}
                {include file="modules/sdek/views/templates/hook/calculator.tpl"}
            {/block}
        </div>
        <div class="col-lg-9">
            <h1>Не удалось загрузить список офисов</h1>
            <p>{$message}</p>
        </div>
    </div>
</div>