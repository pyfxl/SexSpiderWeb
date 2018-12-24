<%@ Page Title="查看图片 - SexSpider" Language="C#" MasterPageFile="~/SexSpiderWeb/MasterPage.master" AutoEventWireup="true" CodeFile="Images.aspx.cs" Inherits="SexSpiderWeb_Images" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
	<style type="text/css">
		body { padding-top: 0px; }
		.navbar { display: none; }
		p { padding: 0; }
	</style>	
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
	
	<form id="form1" runat="server">
		<asp:Repeater ID="Repeater1" runat="server">
			<ItemTemplate>
				<%# IsVideo(Eval("ImageUrl").ToString()) ? "<p style='padding: 10px;'><a href='javascript:;' onclick='playVideo(\""+Eval("ImageUrl").ToString()+"\", 1)'>播放html5</a>&nbsp;&nbsp;<a href='javascript:;' onclick='play(\""+Eval("ImageUrl").ToString()+"\", 0)'>播放flash</a></p>" : "<p><img src='"+Eval("ImageUrl")+"' title='' /></p>" %>
			</ItemTemplate>
		</asp:Repeater>
		<div>
			<script type="text/javascript" src="chplayer/chplayer.js"></script>
			<div id="video" style="width: 100%; height: 450px; display: none;"></div>
			<script type="text/javascript">
				var player;
				function playVideo(url, hls) {
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
				function sayHello(s) {
					alert(s);
				}
			</script>
		</div>
	</form>

</asp:Content>

