using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class SexSpiderWeb_GetImageJson4 : System.Web.UI.Page
{    
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            string url = Request["url"] ?? "";

            int siteId = Convert.ToInt32(Request["siteId"] ?? "0");

            if (siteId > 0 && url != "")
            {
                BusinessBLL.SiteService service = new BusinessBLL.SiteService();

                var sexSpider = service.GetSexSpider(siteId);

                var lists = GetImages(sexSpider, Server.UrlDecode(url));

                this.Repeater1.DataSource = lists;
                this.Repeater1.DataBind();
            }
        }
    }

    private List<BusinessBLL.Models.ImageModel> GetImages(BusinessBLL.Models.SexSpider sexSpider, string url)
    {
        var lists = new List<BusinessBLL.Models.ImageModel>();

        try
        {
            //PageLevel==0没有分页，==1有分页，==2只显示部分分页
            if (sexSpider.PageLevel == 0)
            {
                lists = BusinessBLL.SiteHelper.GetListImage(sexSpider, url).ToList();
            }
            else
            {
                lists = BusinessBLL.SiteHelper.GetListImagePage(sexSpider, url).ToList();
            }
        }
        catch
        {
        }

        return lists;
    }

}