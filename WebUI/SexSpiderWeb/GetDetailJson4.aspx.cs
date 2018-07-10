using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class SexSpiderWeb_GetDetailJson4 : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            string result = "";

            int siteId = Convert.ToInt32(Request["siteId"] ?? "0");
            int page = Convert.ToInt32(Request["page"] ?? "0");

            if (siteId > 0)
            {
                BusinessBLL.SiteService service = new BusinessBLL.SiteService();

                var sexSpider = service.GetSexSpider(siteId);

                var lists = GetLists(sexSpider, page);

                result = Newtonsoft.Json.JsonConvert.SerializeObject(lists);
            }
            else
            {
                result = "SiteId 无效！";
            }

            Response.Write(result.ToString());
            Response.End();
        }
    }

    private List<BusinessBLL.ViewModel.ListModel> GetLists(BusinessBLL.Models.SexSpider sexSpider, int page)
    {
        var lists = new List<BusinessBLL.ViewModel.ListModel>();

        try
        {
            GetNextPage(sexSpider, page);
            lists = BusinessBLL.SiteHelper.GetSiteList(sexSpider).ToList();
        }
        catch (Exception ex)
        {
        }

        return lists;
    }

    private void GetNextPage(BusinessBLL.Models.SexSpider sexSpider, int page)
    {
        if (page > 1)
        {
            string link = sexSpider.SiteLink.Substring(0, sexSpider.SiteLink.LastIndexOf("/") + 1);
            sexSpider.SiteLink = link + sexSpider.ListPage.Replace("(*)", page.ToString());
        }
    }
}