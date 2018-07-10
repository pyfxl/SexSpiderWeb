using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class SexSpiderWeb_Player : System.Web.UI.Page
{
    public string VideoUrl = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            VideoUrl = Request.QueryString["v"] ?? "";
        }
    }
}