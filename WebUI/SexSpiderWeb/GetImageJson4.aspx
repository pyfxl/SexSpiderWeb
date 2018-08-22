<%@ Page Language="C#" AutoEventWireup="true" CodeFile="GetImageJson4.aspx.cs" Inherits="SexSpiderWeb_GetImageJson4" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <asp:Repeater ID="Repeater1" runat="server">
            <ItemTemplate>
                <%# IsVideo(Eval("ImageUrl").ToString()) ? "<p><a href='javascript:;' onclick='play(\""+Eval("ImageUrl").ToString()+"\", 1)'>播放html5</a>&nbsp;&nbsp;<a href='javascript:;' onclick='play(\""+Eval("ImageUrl").ToString()+"\", 0)'>播放flash</a></p>" : "<p><img src='"+Eval("ImageUrl")+"' title='' /></p>" %>
                <%--<p><img src="<%# Eval("ImageUrl") %>" title="" /></p>--%>
                <%--<p><%# Eval("ImageUrl") %></p>--%>
            </ItemTemplate>
        </asp:Repeater>
        <div>
	        <script type="text/javascript" src="chplayer/chplayer.js"></script>
	        <div id="video" style="width:100%; height:430px; display:none;"></div>
	        <script type="text/javascript">
                var player;
                function play(url, hls) {
                    $("#video").show();
                    console.log(url);
                    var videoObject = {
                        container: '#video',//“#”代表容器的ID，“.”或“”代表容器的class
                        variable: 'player',//该属性必需设置，值等于下面的new chplayer()的对象
                        video: url//视频地址
                    };
                    if (hls == 1) {
                        videoObject['html5m3u8'] = true;
                    }
                    player = new chplayer(videoObject);
                }
                function pause() {
                    player.pause();
                }
                function remove() {
                    player.removeChild();
                }
	        </script>
	    </div>
    </form>
</body>
</html>
