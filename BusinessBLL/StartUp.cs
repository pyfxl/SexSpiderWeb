using BusinessBLL.Models;
using BusinessBLL.ViewModel;
using Mapster;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web;

[assembly: PreApplicationStartMethod(typeof(BusinessBLL.Startup), "Start")]

namespace BusinessBLL
{
    public class Startup
    {
        public static void Start()
        {

            TypeAdapterConfig.GlobalSettings.Default.NameMatchingStrategy(NameMatchingStrategy.IgnoreCase);


            TypeAdapterConfig<SexSpider, SiteListViewModel>.NewConfig()
                .Map(dest => dest.siteid, src => src.SiteId)
                .Map(dest => dest.siterank, src => src.SiteRank)
                .Map(dest => dest.viplevel, src => src.VipLevel)
                .Map(dest => dest.ishided, src => src.IsHided)
                .Map(dest => dest.sitename, src => src.SiteName)
                .Map(dest => dest.listpage, src => src.ListPage)
                .Map(dest => dest.pageencode, src => src.PageEncode)
                .Map(dest => dest.domain, src => src.Domain)
                .Map(dest => dest.sitelink, src => src.SiteLink)
                .Map(dest => dest.listdiv, src => src.ListDiv)
                .Map(dest => dest.imagediv, src => src.ImageDiv)
                .Map(dest => dest.pagediv, src => src.PageDiv)
                .Map(dest => dest.pagelevel, src => src.PageLevel)
                .Map(dest => dest.listfilter, src => src.ListFilter)
                .Map(dest => dest.imagefilter, src => src.ImageFilter)
                .Map(dest => dest.pagefilter, src => src.PageFilter)
                .Map(dest => dest.doctype, src => src.DocType)
                .Map(dest => dest.sitefilter, src => src.SiteFilter);

        }
    }
}
