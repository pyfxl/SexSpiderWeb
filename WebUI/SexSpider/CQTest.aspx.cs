using CsQuery;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class SexSpider_CQTest : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        CQ dom = CQ.CreateDocument("<html><body><div>Hello world! <b>I am feeling bold!</b> What about <textarea><b>you?</b></textarea></div></body></html>");
        CQ bold = dom["b"];
    }
}