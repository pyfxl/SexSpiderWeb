using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class SexSpiderWeb_GetSiteJson4 : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            string url = Request["_url"];
            string encode = Request["_encode"];
            string domain = Request["_domain"];

            string content = BusinessBLL.SiteHelper.GetHtmlContent(url, encode, domain);
            if (content == "") throw new Exception("获取网站错误。");

            Response.Write("{\"result\":\"ok\"}");
            Response.End();
        }
        
    }
}