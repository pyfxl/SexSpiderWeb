<%@ Page Title="" Language="C#" MasterPageFile="~/SexSpiderWeb/MasterPage.master" AutoEventWireup="true" CodeFile="Details.aspx.cs" Inherits="SexSpiderWeb_Details" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    
    <div id="window"></div>

    <div class="page-header">
        <h1>
            <span>站点列表</span>
            <small>
                <a href="javascript:history.go(-1);"><i class="ace-icon fa fa-angle-double-left"></i>
                返回</a>
            </small>
        </h1>
    </div><!-- /.page-header -->

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
        set_header();

        function set_header() {
            var siteName = getUrlParam("siteName");
            if ($.isEmptyObject(siteName)) {
            } else {
                $(".page-header h1 span").text(decodeURI(siteName));
            }
        }

        function onChange(arg) {
            var selected = $.map(this.select(), function (item) {
                return $(item).text();
            });

            alert("Selected: " + selected.length + " item(s), [" + selected.join(", ") + "]");
        }

        function initGrid(siteId) {
            $("#grid").kendoGrid({
                dataSource: {
                    transport: {
                        read: {
                            url: "GetDetailJson4.aspx?siteId=" + siteId,
                            dataType: "json"
                        }
                    },
                    schema: {
                        model: {
                            fields: {
                                Title: { type: "string" },
                                Domain: { type: "string" },
                                Link: { type: "string" }
                            }
                        }
                    }
                },
                change: onChange,
                height: 490,
                columns: [
                    {
                        template: "<a href='javascript:;' onclick='f_open(" + siteId + ",\"#:Link#\")'>#:Title#</a>",
                        field: "Title",
                        title: "标题（单击查看图片）"
                    },
                    {
                        template: "<a href='#:Domain#' target='_blank'>#:Domain#</a>",
                        field: "Domain",
                        title: "域名"
                    },
                    {
                        template: "<a href='#:Link#' target='_blank'>#:Link#</a>",
                        field: "Link",
                        title: "链接"
                    }
                ]
            });
        }

        function f_open(siteId, url) {
            var _width = "75%";
            var _height = "75%";

            //是否手机
            if ('ontouchstart' in document.documentElement) {
                _width = "95%";
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
                content: "GetImageJson4.aspx?siteId=" + _siteId + "&url=" + _url
            }).data("kendoWindow").open().center();
        }

        function set_active() {
            var siteId = getUrlParam("siteId");
            if ($.isEmptyObject(siteId)) return;

            $("#site_menu").parent().addClass("open");

            $("#site_menu li").each(function () {
                var li = $(this);
                li.removeClass("active");
                var val = li.attr("value");
                if (val == siteId) {
                    li.addClass("active");
                }
            });
        };
    </script>
    
    <script>
        //$.pjax.defaults.cache = false;

        $(document).pjax('a[data-pjax]', '#main', { fragment: '#main', timeout: 8000 });
        //$(document).pjax('[data-pjax] a, a[data-pjax]', '#pjax-container');

        //$(document).on('ready pjax:start', function () { NProgress.start(); });

        $(document).on('ready pjax:end', function (event) {
            //NProgress.done();
            var siteId = getUrlParam("siteId");
            initGrid(siteId);
            set_active();
            set_header();
            resizeGrid();
        });

    </script>
</asp:Content>

