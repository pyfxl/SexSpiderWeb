using NLog;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class SexSpiderWeb_GetImageJson4 : System.Web.UI.Page
{
    public static Logger log = LogManager.GetLogger("logsex");

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

    private List<BusinessBLL.ViewModel.ImageModel> GetImages(BusinessBLL.Models.SexSpider sexSpider, string url)
    {
        var lists = new List<BusinessBLL.ViewModel.ImageModel>();

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
        catch (Exception ex)
        {
            log.Error("图片错误", ex.Message);
        }

        return lists;
    }

    public bool IsVideo(string url)
    {
        //string[] files = new string[] { ".m3u8", ".mp4" };
        //return files.Contains(url);

        return url.LastIndexOf(".mp4") > 0 || url.LastIndexOf(".m3u8") > 0;
    }

}