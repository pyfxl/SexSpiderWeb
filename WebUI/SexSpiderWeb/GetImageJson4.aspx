﻿<%@ Page Language="C#" AutoEventWireup="true" CodeFile="GetImageJson4.aspx.cs" Inherits="SexSpiderWeb_GetImageJson4" %>

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
                <%# IsVideo(Eval("ImageUrl").ToString()) ? "<p><a href='Player.aspx?v="+HttpUtility.UrlEncode(Eval("ImageUrl").ToString())+"' target='_blank'>"+Eval("ImageUrl")+"</a></p>" : "<p><img src='"+Eval("ImageUrl")+"' title='' /></p>" %>
                <%--<p><img src="<%# Eval("ImageUrl") %>" title="" /></p>--%>
                <%--<p><%# Eval("ImageUrl") %></p>--%>
            </ItemTemplate>
        </asp:Repeater>
    </form>
</body>
</html>
