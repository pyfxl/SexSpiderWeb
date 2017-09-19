(function ($, undefined) {

/* FilterMultiCheck messages */

if (kendo.ui.FilterMultiCheck) {
kendo.ui.FilterMultiCheck.prototype.options.messages =
$.extend(true, kendo.ui.FilterMultiCheck.prototype.options.messages,{
    checkAll: "全选",
    selectedItemsFormat: "{0} 个项目被选中",
    clear: "清除",
    filter: "过滤",
    search: "搜索",
    cancel: "取消"
});
}

})(window.kendo.jQuery);