using BusinessBLL.Models;
using BusinessBLL.ViewModel;
using Mapster;
using NLog;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Data.Entity.Infrastructure;
using System.Linq;
using System.Text;

namespace BusinessBLL
{
    public class SiteService
    {
        public static Logger log = LogManager.GetCurrentClassLogger();

        public SiteService()
        {
            TypeAdapterConfig<Models.SexSpider, SiteListViewModel>.NewConfig()
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
                .Map(dest => dest.sitefilter, src => src.SiteFilter)
                .Compile();
        }

        public string GetSiteList()
        {
            string html = "";

            try
            {
                using (var db = new Models.SexSpiderDbContext())
                {
                    var sexSpiders = db.SexSpider.OrderBy(s => s.SiteRank).ToList();

                    var models = sexSpiders.Adapt<List<SiteListViewModel>>();

                    html = Newtonsoft.Json.JsonConvert.SerializeObject(models);
                }
            }
            catch(Exception ex)
            {
                log.Error(ex.Message);
            }

            return html;
        }

        public void AddSiteList(string jsonHtml)
        {
            try
            {
                var jsonObject = Newtonsoft.Json.JsonConvert.DeserializeObject<List<ViewModel.SiteListViewModel>>(jsonHtml);

                var models = jsonObject.Adapt<List<SexSpider>>();

                using (var db = new BusinessBLL.Models.SexSpiderDbContext())
                {
                    db.SexSpider.AddRange(models);
                    db.SaveChanges();
                }
            }
            catch
            {
            }
        }

        public void UpdateSiteList(string jsonHtml)
        {
            try
            {
                var jsonObject = Newtonsoft.Json.JsonConvert.DeserializeObject<List<ViewModel.SiteListViewModel>>(jsonHtml);

                var models = jsonObject.Adapt<List<SexSpider>>();

                using (var db = new Models.SexSpiderDbContext())
                {
                    models.ForEach(s =>
                    {
                        db.SexSpider.Attach(s);
                        DbEntityEntry<Models.SexSpider> entry = db.Entry(s);
                        entry.State = EntityState.Modified;
                        db.SaveChanges();
                    });
                }
            }
            catch
            {
            }
        }

        public void RemoveSiteList(string jsonHtml)
        {
            try
            {
                var jsonObject = Newtonsoft.Json.JsonConvert.DeserializeObject<List<ViewModel.SiteListViewModel>>(jsonHtml);

                var models = jsonObject.Adapt<List<SexSpider>>();

                using (var db = new Models.SexSpiderDbContext())
                {
                    models.ForEach(s =>
                    {
                        db.SexSpider.Remove(db.SexSpider.Where(a => a.SiteId == s.SiteId).FirstOrDefault());
                        db.SaveChanges();
                    });
                }
            }
            catch
            {
            }
        }

        public Models.SexSpider GetSexSpider(int siteId)
        {
            using (var db = new Models.SexSpiderDbContext())
            {
                return db.SexSpider.Where(s => s.SiteId == siteId).FirstOrDefault();
            }
        }

        /// <summary>
        /// 取外部字典
        /// </summary>
        /// <returns></returns>
        public string GetExtDic()
        {
            string[] dics = "内射,內射,车震,大屁股,人妻,美臀,肥臀,翘臀,换妻,后入,後入,豐滿,水多,炮友,網友,白漿,闺蜜,陰道,少婦,熟婦,賓館,鮑魚,極品,鄰居".Split(',');
            
            return Newtonsoft.Json.JsonConvert.SerializeObject(dics);
        }

        /// <summary>
        /// 取停止词典
        /// </summary>
        /// <returns></returns>
        public string GetStopDic()
        {
            string[] dics = "的,了,在,是,我,有,和,就,不,人,都,一,一个,上,也,很,到,说,要,去,你,会,着,没有,看,好,自己,这".Split(',');
            
            return Newtonsoft.Json.JsonConvert.SerializeObject(dics); ;
        }

    }
}
