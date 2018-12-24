<%@ Page Title="站点列表 - SexSpider" Language="C#" MasterPageFile="~/SexSpiderWeb/MasterPage.master" AutoEventWireup="true" CodeFile="Details.aspx.cs" Inherits="SexSpiderWeb_Details" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <style type="text/css">
        .k-grid-toolbar { text-align: right; }
    </style>    
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    
    <div id="window"></div>

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
        var siteId = <%=siteId%>, siteName = "<%=siteName%>", page = 1, resizeTimer;
        var winImage = $("#window").data("kendoWindow");

        $(document).ready(function() {
            
            //刷新高度
            resizeMain();

            var grid = $("#grid").kendoGrid({
                dataSource: {
                    transport: {
                        read: {
                            url: "api/DetailQuery.aspx?siteId=" + siteId + "&page=" + page,
                            dataType: "json",
                            cache: false
                        }
                    },
                    schema: {
                        model: {
                            fields: {
                                thumb: { type: "string" },
                                title: { type: "string" },
                                domain: { type: "string" },
                                link: { type: "string" }
                            }
                        }
                    },
                    requestEnd: function (e) {
                        var grid = $("#grid").data("kendoGrid");
                        grid.element.find(".k-grid-content").scrollTop(0);
                    }
                },
                scrollable: true,
                sortable: false,
                pageable: false,
                toolbar: [                   
                    {
                        name: "name",
                        template: "<p class='bar-name pull-left'><%=siteName%></p>"
                    },
                    { 
                        name: "refresh", 
                        text: "刷新", 
                        iconClass: "k-icon k-i-refresh" 
                    }, 
                    { 
                        name: "prevPage", 
                        text: "上页", 
                        iconClass: "k-icon k-i-arrow-chevron-left" 
                    }, 
                    { 
                        name: "nextPage", 
                        text: "下页", 
                        iconClass: "k-icon k-i-arrow-chevron-right" 
                    }
                ],
                columns: [
                    {
                        template: "<img src='#:thumb#' title='' />",
                        field: "thumb",
                        title: "缩略图",
                        width: "33%"
                    },
                    {
                        template: "<a href='javascript:;' onclick='openWin(<%=siteId%>,\"#:link#\")'>#:title#</a>",
                        field: "title",
                        title: "标题（单击查看图片）",
                        width: "34%"
                    },
                    {
                        template: "<a href='#:link#' target='_blank'>#:link#</a>",
                        field: "link",
                        title: "链接",
                        width: "33%"
                    }
                ],
                noRecords: false,
                dataBound: function () {
                    $('#grid img').jqthumb();
                }
            });
          
            $(window).resize(function () {
                clearTimeout(resizeTimer);
                resizeTimer = setTimeout(function () { 
                    resizeMain();
                    $("#grid").data("kendoGrid").resize();
                }, 200);
            });

        });

        $("#grid").on("click", ".k-grid-refresh", function () {
            reloadGrid();
        });

        $("#grid").on("click", ".k-grid-nextPage", function () {
            page += 1;
            reloadGrid();
        });

        $("#grid").on("click", ".k-grid-prevPage", function () {
            page > 1 ? page -= 1 : page = 1;
            reloadGrid();
        });

        function reloadGrid() {
            var grid = $("#grid").data("kendoGrid");
            grid.dataSource.transport.options.read.url = "api/DetailQuery.aspx?siteId=" + siteId + "&page=" + page;
            grid.dataSource.read();
        }

        //弹出window
        function openWin(siteId, url) {
            var _width = "75%";
            var _height = $(window).innerHeight() - 100;

            //是否手机
            if (IsSmallScreen()) {
                _width = "95%";
                //_height = "85%";
            }

            //清除内容
            $("#window").html("");

            var _siteId = siteId;
            var _url = encodeURIComponent(url);
            var _viewUrl = "Images.aspx?siteId=" + _siteId + "&url=" + _url

            if (!winImage) {
                winImage = $("#window").kendoWindow({
                    width: _width,
                    height: _height,
                    title: "图片查看",
                    actions: ["Refresh", "Maximize", "Close"],
                    close: function () {
                        try { $(".k-content-frame")[0].contentWindow.pause(); } catch (e) { }
                    },
                    open: onOpen,
                    refresh: onRefresh,
                    content: _viewUrl,
                    iframe: true
                }).data("kendoWindow");
            } else {
                winImage.refresh(_viewUrl);
            }
            winImage.open().center();
        }

        function onOpen(e) {
           kendo.ui.progress(e.sender.element, true);
        }
 
        function onRefresh(e) {
           kendo.ui.progress(e.sender.element, false);
        }
    </script>

</asp:Content>

