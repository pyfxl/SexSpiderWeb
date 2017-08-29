﻿using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Data.Entity.Infrastructure;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class SexSpider_UpdateListJson4 : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BusinessBLL.SiteService service = new BusinessBLL.SiteService();

            string jsonHtml = Request["models"];

            if (jsonHtml == null || jsonHtml == "") return;

            service.UpdateSiteList(jsonHtml);

            //Response.Write("callback()");
            //Response.End();
        }

    }
}