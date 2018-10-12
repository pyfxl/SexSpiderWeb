<%@ Page Title="站点列表 - SexSpider" Language="C#" MasterPageFile="~/SexSpiderWeb/MasterPage.master" AutoEventWireup="true" CodeFile="Details.aspx.cs" Inherits="SexSpiderWeb_Details" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    
    <div id="window"></div>

    <div class="row">
        <div class="col-xs-6" id="page-title">
            <h4>
                <span>站点列表</span>
            </h4>
        </div>
        <div class="col-xs-6">
            <div class="tools pull-right">
                <span class="pagetxt"></span>
                <button class="k-button" id="prevButton">上页</button>
                <button class="k-button" id="nextButton">下页</button>
            </div>
        </div>
    </div>

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

        //var siteId = getUrlParam("siteId");
        var page = 1;
        set_header();

        function set_header() {
            var siteName = getUrlParam("siteName");
            if ($.isEmptyObject(siteName)) {
            } else {
                $("#page-title span").text(decodeURI(siteName));
            }
        }

        function onChange(arg) {
            var selected = $.map(this.select(), function (item) {
                return $(item).text();
            });

            alert("Selected: " + selected.length + " item(s), [" + selected.join(", ") + "]");
        }

        //列表grid
        function initGrid(siteId, page) {
            page = page || 1;
            $(".pagetxt").text("page: " + page);
            $("#grid").kendoGrid({
                dataSource: {
                    transport: {
                        read: {
                            url: "GetDetailJson4.aspx?siteId=" + siteId + (page == null ? "" : "&page=" + page),
                            dataType: "json"
                        }
                    },
                    schema: {
                        model: {
                            fields: {
                                Thumb: { type: "string" },
                                Title: { type: "string" },
                                Domain: { type: "string" },
                                Link: { type: "string" }
                            }
                        }
                    }
                },
                change: onChange,
                dataBound: function () {
                    $('img').jqthumb();
                },
                height: 490,
                //toolbar: "",
                columns: [
                    {
                        template: "<img src='#:Thumb#'/>",
                        field: "Thumb",
                        title: "缩略图"
                    },
                    {
                        template: "<a href='javascript:;' onclick='f_open(" + siteId + ",\"#:Link#\")'>#:Title#</a>",
                        field: "Title",
                        title: "标题（单击查看图片）"
                    },
                    //{
                    //    template: "<a href='#:Domain#' target='_blank'>#:Domain#</a>",
                    //    field: "Domain",
                    //    title: "域名"
                    //},
                    {
                        template: "<a href='#:Link#' target='_blank'>#:Link#</a>",
                        field: "Link",
                        title: "链接"
                    }
                ]
            });
        }

        //弹出window
        function f_open(siteId, url) {
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
  
            var dialog = $("#window").kendoWindow({
                width: _width,
                height: _height,
                title: "图片查看",
                actions: ["Refresh", "Maximize", "Close"],
                close: function () {
                    try { pause(); } catch (e) { }
                },
                content: "GetImageJson4.aspx?siteId=" + _siteId + "&url=" + _url
            }).data("kendoWindow").open().center();
        }

        $("#prevButton").click(function () {            
            var siteId = getUrlParam("siteId");
            page = page <= 1 ? 1 : page -= 1;
            initGrid(siteId, page);
            resizeGrid();
        });

        $("#nextButton").click(function () {
            var siteId = getUrlParam("siteId");
            page += 1;
            initGrid(siteId, page);
            resizeGrid();
        });

        //$.pjax.defaults.cache = false;
        //$(document).pjax('a[data-pjax]', '#main', { fragment: '#main', timeout: 8000 });
        //$(document).pjax('[data-pjax] a, a[data-pjax]', '#pjax-container');
        //$(document).on('ready pjax:start', function () { NProgress.start(); });

        $(document).ready(function() {
            //NProgress.done();
            var siteId = getUrlParam("siteId");
            initGrid(siteId);
            set_header();
            resizeGrid();
        });

    </script>

</asp:Content>

