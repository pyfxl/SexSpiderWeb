using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class SexSpider_Details : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if(!IsPostBack)
        {
            
        }
    }

    protected void Button1_Click(object sender, EventArgs e)
    {
        var lists = new List<BusinessBLL.ViewModel.ListModel>();
        
        string url = this.siteLinkHid.Value;
        string encoding = this.pageEncodeHid.Value;
        string docType = "html";
        string listStart = this.listDivHid.Value;
        string listFilter = this.listFilterHid.Value;
        string domain = this.domainHid.Value;

        var sexSpider = new BusinessBLL.Models.SexSpider() {
            SiteLink = url,
            PageEncode = encoding,
            DocType = docType,
            ListDiv = listStart,
            ListFilter = listFilter,
            Domain = domain
        };

        try
        {
            lists = BusinessBLL.SiteHelper.GetSiteList(sexSpider).ToList();
        }
        catch
        {
        }

        this.Repeater1.DataSource = lists;
        this.Repeater1.DataBind();
    }

    protected void Repeater1_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        var lists = new List<BusinessBLL.ViewModel.ImageModel>();

        string url = e.CommandArgument.ToString();
        string encoding = this.pageEncodeHid.Value;
        string imageStart = this.imageDivHid.Value;
        string imageFilter = this.imageFilterHid.Value;
        string pageStart = this.pageDivHid.Value;
        string pageFilter = this.pageFilterHid.Value;
        string domain = this.domainHid.Value;
        string pageLevel = this.pageLevelHid.Value;

        var sexSpider = new BusinessBLL.Models.SexSpider()
        {
            SiteLink = url,
            PageEncode = encoding,
            ImageDiv = imageStart,
            ImageFilter = imageFilter,
            PageDiv = pageStart,
            PageFilter = pageFilter,
            Domain = domain,
            PageLevel = Convert.ToByte(pageLevel)
        };

        try
        {
            if(sexSpider.PageLevel == 0)
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

        this.Repeater2.DataSource = lists;
        this.Repeater2.DataBind();

        this.UpdatePanel2.Update();
    }
}