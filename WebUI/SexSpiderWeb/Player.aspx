<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Player.aspx.cs" Inherits="SexSpiderWeb_Player" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
	<title></title>
</head>
<body>
	<form id="form1" runat="server">
	<div>
	<script type="text/javascript" src="chplayer/chplayer.js"></script>
	<div id="video" style="width:600px;height:400px;"></div>
	<script type="text/javascript">
		var videoObject = {
			container: '#video',//“#”代表容器的ID，“.”或“”代表容器的class
			variable: 'player',//该属性必需设置，值等于下面的new chplayer()的对象
			video:'<%=VideoUrl%>'//视频地址
		};
		var player=new chplayer(videoObject);
	</script>
	</div>
	</form>
</body>
</html>
