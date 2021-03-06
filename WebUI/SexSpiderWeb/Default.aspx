﻿<%@ Page Title="首页 - SexSpider" Language="C#" MasterPageFile="~/SexSpiderWeb/MasterPage.master" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="SexSpiderWeb_Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

    <div class="row">
        <div class="col-xs-12">
            <!-- PAGE CONTENT BEGINS -->                                           
            <div id="main">
                <div id="grid"></div>
            </div>
            <!-- PAGE CONTENT ENDS -->
        </div><!-- /.col -->
    </div><!-- /.row -->

    <script type="text/javascript">

        var resizeTimer;

        $(document).ready(function () {

            //刷新高度
            resizeMain();

            var dataSource = new kendo.data.DataSource({
                transport: {
                    read: {
                        url: "api/ListQuery.aspx",
                        dataType: "json",
                        cache: false
                    },
                    update: {
                        url: "api/ListUpdate.aspx",
                        dataType: "json",
                        //contentType: "application/json",
                        type: "POST",
                        complete: function (e) {
                            $("#grid").data("kendoGrid").dataSource.read();
                        }
                    },
                    destroy: {
                        url: "api/ListRemove.aspx",
                        dataType: "json",
                        //contentType: "application/json",
                        type: "POST",
                        complete: function (e) {
                            $("#grid").data("kendoGrid").dataSource.read();
                        }
                    },
                    create: {
                        url: "api/ListAdd.aspx",
                        dataType: "json",
                        //contentType: "application/json",
                        type: "POST",
                        complete: function (e) {
                            $("#grid").data("kendoGrid").dataSource.read();
                        }
                    },
                    parameterMap: function (options, operation) {
                        if (operation !== "read" && options.models) {
                            //return kendo.stringify(options.models);
                            return { models: kendo.stringify(options.models) };
                        }
                    }
                },
                batch: true,
                schema: {
                    model: {
                        id: "siteid",
                        fields: {
                            siteid: { type: "number", editable: false },
                            siterank: { type: "string", validation: { required: true, validationMessage: "排序为必填项" } },
                            viplevel: { type: "number", validation: { min: 0, max: 2 } },
                            ishided: { type: "boolean" },
                            sitename: { type: "string", validation: { required: true, validationMessage: "名称为必填项" } },
                            listpage: { type: "string", validation: { required: true, validationMessage: "下一页为必填项" } },
                            pageencode: { type: "string" },
                            doctype: { type: "string" },
                            imgtype: { type: "string" },
                            domain: { type: "string", validation: { required: true, validationMessage: "域名为必填项" } },
                            sitelink: { type: "string", validation: { required: true, validationMessage: "链接为必填项" } },
                            maindiv: { type: "string" },
                            listdiv: { type: "string" },
                            thumbdiv: { type: "string" },
                            imagediv: { type: "string" },
                            pagediv: { type: "string" },
                            pagelevel: { type: "number", validation: { min: 0, max: 3 } },
                            sitefilter: { type: "string" },
                            sitereplace: { type: "string" },
                            listfilter: { type: "string" },
                            imagefilter: { type: "string" },
                            pagefilter: { type: "string" }
                        }
                    }
                },
                requestEnd: function (e) {
                    //更新不会触发
                    //if (e.type && e.type !== "read") {
                    //    $("#grid").data("kendoGrid").dataSource.read();
                    //}
                }
            });

            var grid = $("#grid").kendoGrid({
                dataSource: dataSource,
                navigatable: true,
                editable: true,
                resizable: true,
                filterable: true,
                sortable: true,
                columnMenu: {
                    columns: false
                },
                saveChanges: function (e) {
                    var grid = this;
                    var lockedRows = grid.lockedTable.find("tr");
                    var rows = grid.tbody.find("tr");
                    if (!checkCells(grid, lockedRows)) {
                        e.preventDefault();       //prevents save if validation fails
                        return;
                    }
                    if (!checkCells(grid, rows)) {
                        e.preventDefault();       //prevents save if validation fails
                        return;
                    }
                },
                toolbar: ["create", "save", "cancel", { template: '<select id="RankFilter" multiple="multiple" data-placeholder="选择类别" style="width: 90px; float: right;"><option>A</option><option>B</option><option>C</option></select>' }],
                columns: [
                    {
                        template: "#=siteid# <a class='k-icon k-i-delete k-grid-delete' href='javascript:;'></a>",
                        field: "siteid",
                        title: "编号",
                        locked: true,
                        width: 80,
                        attributes: { "class": "cell-none" }
                    },
                    {
                        field: "siterank",
                        title: "排序",
                        locked: true,
                        width: 80
                    },
                    {
                        template: "#= ishided ? '是' : '否' #",
                        field: "ishided",
                        title: "隐藏",
                        locked: true,
                        width: 80,
                        filterable: { multi: true }
                    },
                    {
                        template: "<a class='link-stop' href='Details.aspx?siteId=#=siteid#&siteName=#=encodeURI(encodeURI(sitename))#' target='_blank'>#=sitename#</a>",
                        field: "sitename",
                        title: "名称（单击查看列表）",
                        locked: true,
                        width: 200,
                        attributes: { "class": "sitename" }
                    },
                    {
                        field: "viplevel",
                        title: "VIP",
                        width: 80,
                        filterable: { multi: true }
                    },
                    {
                        field: "pageencode",
                        title: "编码",
                        editor: function (container, options) {
                            var input = $("<input required validationmessage='编码为必选项' />");
                            input.attr("name", options.field);
                            input.appendTo(container);
                            input.kendoDropDownList({
                                dataSource: ["utf-8", "gb2312"],
                                animation: false
                            });
                            $('<span class="k-invalid-msg" data-for="' + options.field + '"></span>').appendTo(container);
                        },
                        width: 80,
                        filterable: { multi: true },
                        attributes: { "class": "pageencode" }
                    },
                    {
                        template: "<a class='link-stop' href='#=domain#' target='_blank'>#=domain#</a>",
                        field: "domain",
                        title: "域名",
                        width: 200,
                        attributes: { "class": "domain" }
                    },
                    {
                        template: "<a class='link-stop' href='#=sitelink#' target='_blank'>#=sitelink#</a>",
                        field: "sitelink",
                        title: "链接",
                        width: 300,
                        attributes: { "class": "sitelink" }
                    },
                    {
                        field: "listpage",
                        title: "下一页",
                        width: 200
                    },
                    {
                        field: "sitefilter",
                        title: "站点过滤",
                        width: 200
                    },
                    {
                        field: "sitereplace",
                        title: "站点替换",
                        width: 200
                    },
                    {
                        field: "doctype",
                        title: "主类型",
                        width: 80
                    },
                    {
                        field: "maindiv",
                        title: "主要DIV",
                        width: 200
                    },
                    {
                        field: "listdiv",
                        title: "列表DIV",
                        width: 200
                    },
                    {
                        field: "thumbdiv",
                        title: "缩略图DIV",
                        width: 200
                    },
                    {
                        field: "listfilter",
                        title: "列表过滤",
                        width: 200
                    },
                    {
                        field: "imgtype",
                        title: "图类型",
                        width: 80
                    },
                    {
                        field: "imagediv",
                        title: "图片DIV",
                        width: 200
                    },
                    {
                        field: "imagefilter",
                        title: "图片过滤",
                        width: 200
                    },
                    {
                        field: "pagediv",
                        title: "分页DIV",
                        width: 200
                    },
                    {
                        field: "pagelevel",
                        title: "分页",
                        width: 80,
                        filterable: { multi: true }
                    },
                    {
                        field: "pagefilter",
                        title: "分页过滤",
                        width: 200
                    }
                ]
            });

            //右边下拉过滤
            var dropDown = grid.find("#RankFilter").kendoMultiSelect({
                change: function () {
                    var filter = { logic: "or", filters: [] };
                    var values = this.value();
                    $.each(values, function (i, v) {
                        filter.filters.push({ field: "siterank", operator: "startswith", value: v });
                    });
                    grid.data("kendoGrid").dataSource.filter(filter);
                }
            }).data("kendoMultiSelect");

            $(window).resize(function () {
                clearTimeout(resizeTimer);
                resizeTimer = setTimeout(function () {
                    resizeMain();
                    $("#grid").data("kendoGrid").resize();
                }, 200);
            });

        });

        //阻止a事件冒泡
        $("#grid").on("click", ".link-stop", function (event) {
            event.stopPropagation();
        });

        //手动验证
        function checkCells(grid, rows) {
            //debugger;
            //var rows = grid.tbody.find("tr");                   //get rows
            for (var i = 0; i < rows.length; i++) {
                var rowModel = grid.dataItem(rows[i]);          //get row data
                if (rowModel && rowModel.isNew()) {
                    var colCells = $(rows[i]).find("td");       //get cells
                    for (var j = 0; j < colCells.length; j++) {
                        if ($(colCells[j]).hasClass('cell-none')) {
                            continue;
                        }
                        if ($(colCells[j]).hasClass('k-group-cell')) {
                            continue;                           //grouping enabled will add extra td columns that aren't actual columns
                        }
                        grid.editCell($(colCells[j]));          //open for edit
                        if (!grid.editable.end()) {             //trigger validation
                            return false;                       //if fail, return false
                        } else {
                            grid.closeCell();                   //if success, keep checking
                        }
                    }
                }
            }
            return true;                                        //all cells are valid
        }


    </script>
</asp:Content>

