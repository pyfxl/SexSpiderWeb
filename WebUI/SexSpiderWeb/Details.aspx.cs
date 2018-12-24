using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class SexSpiderWeb_Details : System.Web.UI.Page
{
    public static int siteId = 0;
    public static string siteName = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            siteId = Convert.ToInt32(Request.QueryString["siteId"] ?? "0");
            siteName = HttpUtility.UrlDecode(Request.QueryString["siteName"] ?? "");
        }
    }
}