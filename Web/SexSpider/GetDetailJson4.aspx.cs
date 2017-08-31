using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class SexSpider_GetDetailJson4 : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            string result = "";
        
            int siteId = Convert.ToInt32(Request["siteId"] ?? "0");

            if (siteId > 0)
            {
                BusinessBLL.SiteService service = new BusinessBLL.SiteService();

                var sexSpider = service.GetSexSpider(siteId);

                var lists = GetLists(sexSpider);

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

    private List<BusinessBLL.Models.ListModel> GetLists(Repository.SexSpider sexSpider)
    {
        var lists = new List<BusinessBLL.Models.ListModel>();

        try
        {
            lists = BusinessBLL.SiteHelper.GetSiteList(sexSpider).ToList();
        }
        catch (Exception ex)
        {
        }

        return lists;
    }
}