<%@ Page Title="首页" Language="C#" MasterPageFile="~/SexSpiderWeb/MasterPage.master" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="SexSpiderWeb_Default" %>

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

    <script>

        $(document).ready(function () {
            
            var grid = $("#grid").kendoGrid({
                dataSource: {
                    transport: {
                        read: {
                            url: "GetListJson4.aspx",
                            dataType: "json",
                            cache: false
                        },
                        update: {
                            url: "UpdateListJson4.aspx",
                            dataType: "json",
                            type: "POST"
                        },
                        destroy: {
                            url: "RemoveListJson4.aspx",
                            dataType: "json",
                            type: "POST"
                        },
                        create: {
                            url: "AddListJson4.aspx",
                            dataType: "json",
                            type: "POST"
                        },
                        parameterMap: function (options, operation) {
                            if (operation !== "read" && options.models) {
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
                                ishided: { type: "number", validation: { min: 0, max: 1 } },
                                sitename: { type: "string", validation: { required: true, validationMessage: "名称为必填项" } },
                                listpage: { type: "string", validation: { required: true, validationMessage: "下一页为必填项" } },
                                pageencode: { type: "string", validation: { required: true, validationMessage: "编码为必填项" } },
                                doctype: { type: "string" },
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
                        if (e.type !== "read") {
                            $("#grid").data("kendoGrid").dataSource.read();
                            //window.location.reload();
                        }
                    }
                },
                height: 450,
                navigatable: true,
                editable: true,
                resizable: true,
                filterable: true,
                columnMenu: {
                    columns: false
                },
                sortable: true,
                toolbar: ["create", "save", "cancel", { name: "refresh", text: "刷新", iconClass: "k-icon k-i-refresh" }, { template: '<select id="required" multiple="multiple" data-placeholder="选择类别" style="width: 130px; float: right;"><option>A</option><option>B</option><option>C</option></select>' }],
                //toolbar: kendo.template($("#template").html()),
                columns: [
                    {
                        template: "#:siteid# <a class=\"k-icon k-i-delete k-grid-delete\" href=\"javascript:;\"></a>",
                        field: "siteid",
                        title: "编号",
                        width: 80
                    },
                    {
                        field: "siterank",
                        title: "排序",
                        width: 80
                    },
                    {
                        field: "viplevel",
                        title: "VIP",
                        width: 80,
                        filterable: { multi: true }
                    },
                    {
                        field: "ishided",
                        title: "隐藏",
                        width: 80,
                        filterable: { multi: true }
                    },
                    {
                        template: "<a class='stop' href='Details.aspx?siteId=#:siteid#&siteName=#:encodeURI(encodeURI(sitename))#' target='_blank'>#:sitename#</a>",
                        field: "sitename",
                        title: "名称（单击查看列表）",
                        width: 200,
                        attributes: { "class": "sitename" }
                    },
                    {
                        field: "pageencode",
                        title: "编码",
                        editor: function (container, options) {
                            var input = $("<input />");
                            input.attr("name", options.field);
                            input.appendTo(container);
                            input.kendoDropDownList({
                                dataSource: ["utf-8", "gb2312"],
                                animation: false
                            });
                        },
                        width: 80,
                        filterable: { multi: true },
                        attributes: { "class": "pageencode" }
                    },
                    {
                        field: "doctype",
                        title: "类型",
                        width: 80
                    },
                    {
                        template: "<a href='#:domain#' target='_blank'>#:domain#</a>",
                        field: "domain",
                        title: "域名",
                        width: 200,
                        attributes: { "class": "domain" }
                    },
                    {
                        template: "<a href='#:sitelink#' target='_blank'>#:sitelink#</a>",
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
                        field: "imagediv",
                        title: "图片DIV",
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
                        field: "sitefilter",
                        title: "站点过滤",
                        width: 150
                    },
                    {
                        field: "sitereplace",
                        title: "站点替换",
                        width: 200
                    },
                    {
                        field: "listfilter",
                        title: "列表过滤",
                        width: 200
                    },
                    {
                        field: "imagefilter",
                        title: "图片过滤",
                        width: 150
                    },
                    {
                        field: "pagefilter",
                        title: "分页过滤",
                        width: 150
                    }
                ]
            });
            
            var dropDown = grid.find("#required").kendoMultiSelect({
                change: function () {
                    var filter = { logic: "or", filters: [] };
                    var values = this.value();
                    $.each(values, function (i, v) {
                        filter.filters.push({ field: "siterank", operator: "startswith", value: v });
                    });
                    grid.data("kendoGrid").dataSource.filter(filter);
                }
            }).data("kendoMultiSelect");

            resizeGrid();

        });

        $("#grid").on("click", ".k-grid-refresh", function () {
            //custom actions
            $(".k-grid-content table[role='grid'] tr").each(function (i, v) {

                var $title = $(v).find(".sitename");
                var _url = $(v).find(".sitelink").text();
                var _encode = $(v).find(".pageencode").text();
                var _domain = $(v).find(".domain").text();

                setTimeout(function () {
                    $.ajax({
                        type: "POST",
                        //async: false,
                        url: "GetSiteJson4.aspx?_url=" + encodeURIComponent(_url) + "&_encode=" + _encode+ "&_domain=" + _domain,
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: function (data) {
                            $title.find("a").css("color", "green");
                            f_loading($title, false);
                        },
                        error: function (e) {
                            $title.find("a").css("color", "red");
                            f_loading($title, false);
                        },
                        beforeSend: function () {
                            f_loading($title, true);
                        }
                    });
                }, 1000 * i);

            });
        });

        function f_loading(obj, show) {
            if (show) {
                obj.append("<img src='../theme/kendoui/Default/loading.gif' style='padding-left: 5px;' />");
            } else {
                obj.find("img").remove();
            }
        }

    </script>
</asp:Content>

