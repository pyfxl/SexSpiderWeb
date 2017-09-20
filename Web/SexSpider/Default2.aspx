<%@ Page Title="" Language="C#" MasterPageFile="~/SexSpider/MasterPage.master" AutoEventWireup="true" CodeFile="Default2.aspx.cs" Inherits="SexSpider_Default2" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

    <div class="page-header">
        <h1>
            站点列表
        </h1>
    </div><!-- /.page-header -->

    <div class="row">
        <div class="col-xs-12">
            <!-- PAGE CONTENT BEGINS -->                                           
            <div id="main">
                <div id="window"></div>
                <div id="grid"></div>
            </div>
            <!-- PAGE CONTENT ENDS -->
        </div><!-- /.col -->
    </div><!-- /.row -->
     
    <script>

        var siteId = getUrlParam("siteId");

        //initGrid();

        function onChange(arg) {
            var selected = $.map(this.select(), function (item) {
                return $(item).text();
            });

            alert("Selected: " + selected.length + " item(s), [" + selected.join(", ") + "]");
        }

        function initGrid() {
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
                        template: "<a href='javascript:;' onclick='f_open(\"#:Link#\")'>#:Title#</a>",
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

        function f_open(url) {
            //debugger;
            //alert(url);

            //清除内容
            $("#window").html("");

            var _siteId = siteId;
            var _url = encodeURIComponent(url);

            var window = $("#window");
                  
            window.kendoWindow({
                width: "70%",
                height: "70%",
                title: "图片查看",
                actions: ["Refresh", "Maximize", "Close"],
                content: "GetImageJson4.aspx?siteId=" + _siteId + "&url=" + _url
            }).data("kendoWindow").open().center();
        }

        function set_active() {
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
        $.pjax.defaults.cache = false;

        $(document).pjax('a[data-pjax]', '#main', { fragment: '#main', timeout: 8000 });
        //$(document).pjax('[data-pjax] a, a[data-pjax]', '#pjax-container');

        $(document).on('ready pjax:end', function (event) {
            siteId = getUrlParam("siteId");
            initGrid();
        })

    </script>
</asp:Content>

