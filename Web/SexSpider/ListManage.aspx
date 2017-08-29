<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ListManage.aspx.cs" Inherits="SexSpider_ListManage" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
    <link href="../theme/kendoui/kendo.common.min.css" rel="stylesheet" />
    <link href="../theme/kendoui/kendo.default.min.css" rel="stylesheet" />
    <script src="../common/jquery-1.10.2.js"></script>
    <script src="../theme/kendoui/kendo.all.min.js"></script>
    <script src="../theme/kendoui/messages/kendo.messages.zh-CN.min.js"></script>
    <title>列表页面</title>
    <script>
        function resizeContainers() {
            var htmlHeight = window.innerHeight - 20;
            //alert(htmlHeight);
            //alert($('html').height());
            $("#grid").height(htmlHeight);
        }

        $(document).ready(resizeContainers);
        $(window).resize(resizeContainers);
    </script>
</head>
<body>
    <div id="main">
        <div id="grid"></div>        
        <script type="text/x-kendo-template" id="template">
            <div class="refreshBtnContainer">
                <a href="\\#" class="k-pager-refresh k-link k-button" title="Refresh"><span class="k-icon k-i-reload"></span></a>
            </div>
            <div class="toolbar">
                <label class="category-label" for="category">Show products by category:</label>
                <input type="search" id="category" style="width: 150px"/>
            </div>
        </script>
    </div>
    <script>
        $(document).ready(function () {
            $("#grid").kendoGrid({
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
                                siteid: { type: "number", editable: false, nullable: true },
                                siterank: { type: "string" },
                                viplevel: { type: "number" },
                                ishided: { type: "number" },
                                sitename: { type: "string" },
                                listpage: { type: "string" },
                                pageencode: { type: "string" },
                                doctype: { type: "string" },
                                domain: { type: "string" },
                                sitelink: { type: "string" },
                                listdiv: { type: "string" },
                                imagediv: { type: "string" },
                                pagediv: { type: "string" },
                                pagelevel: { type: "number" },
                                sitefilter: { type: "string" },
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
                navigatable: true,
                toolbar: ["create", "save", "cancel", { name: "refresh", text: "刷新" }],
                //toolbar: kendo.template($("#template").html()),
                columns: [
                    {
                        template: "#:siteid# <a class=\"k-icon k-i-delete k-grid-delete\" href=\"javascript:;\"></a>",
                        field: "siteid",
                        title: "编号",
                        width: 60
                    },
                    {
                        field: "siterank",
                        title: "排序",
                        width: 60
                    },
                    {
                        field: "viplevel",
                        title: "VIP",
                        width: 60
                    },
                    {
                        field: "ishided",
                        title: "隐藏",
                        width: 60
                    },
                    {
                        template: "<a href='ListDetails.aspx?siteId=#:siteid#' target='_blank'>#:sitename#</a>",
                        field: "sitename",
                        title: "名称（单击查看列表）",
                        width: 200
                    },
                    {
                        field: "listpage",
                        title: "下一页",
                        width: 200
                    },
                    {
                        field: "pageencode",
                        title: "编码",
                        width: 80
                    },
                    {
                        field: "doctype",
                        title: "类型",
                        width: 60
                    },
                    {
                        field: "domain",
                        title: "域名",
                        width: 200
                    },
                    {
                        template: "<a href='#:sitelink#' target='_blank'>#:sitelink#</a>",
                        field: "sitelink",
                        title: "链接",
                        width: 300
                    },
                    {
                        field: "listdiv",
                        title: "列表DIV",
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
                        width: 60
                    },
                    {
                        field: "sitefilter",
                        title: "站点过滤",
                        width: 150
                    },
                    {
                        field: "listfilter",
                        title: "列表过滤",
                        width: 150
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
                ],
                editable: true
            });
        });

        $("#grid").on("click", ".k-grid-refresh", function () {
            //custom actions
            $(".k-grid-content table[role='grid'] tr").each(function (i, v) {

                var $title = $(v).find("td").eq(4);

                var _url = $(v).find("td").eq(8).text();
                var _encode = $(v).find("td").eq(6).text();

                setTimeout(function () {
                    $.ajax({
                        type: "POST",
                        //async: false,
                        url: "GetSiteJson4.aspx?_url=" + encodeURIComponent(_url) + "&_encode=" + _encode,
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
                }, 500 * i);

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
    <style>
        
    </style>
</body>
</html>
