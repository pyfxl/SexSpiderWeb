using BusinessBLL.Models;
using BusinessBLL.ViewModel;
using Mapster;
using NLog;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Data.Entity.Infrastructure;
using System.Linq;
using System.Reflection;
using System.Text;

namespace BusinessBLL
{
    public class SiteService
    {
        public static Logger log = LogManager.GetLogger("logsex");

        public SiteService()
        {

        }

        public string GetSiteList()
        {
            string html = "";

            try
            {
                using (var db = new SexSpiderDbContext())
                {
                    var sexSpiders = db.SexSpider.OrderBy(s => s.SiteRank).ToList();

                    var models = sexSpiders.Adapt<List<SexSpider>, List<SiteListViewModel>> ();

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
                var jsonObject = Newtonsoft.Json.JsonConvert.DeserializeObject<List<SiteListViewModel>>(jsonHtml);

                var models = jsonObject.Adapt<List<SiteListViewModel>, List<SexSpider>>();

                using (var db = new SexSpiderDbContext())
                {
                    db.SexSpider.AddRange(models);
                    db.SaveChanges();
                }
            }
            catch (Exception ex)
            {
                log.Error(ex.Message);
            }
        }

        public void UpdateSiteList(string jsonHtml)
        {
            try
            {
                var jsonObject = Newtonsoft.Json.JsonConvert.DeserializeObject<List<SiteListViewModel>>(jsonHtml);

                var models = jsonObject.Adapt<List<SiteListViewModel>, List<SexSpider>>();

                using (var db = new SexSpiderDbContext())
                {
                    models.ForEach(s =>
                    {
                        db.SexSpider.Attach(s);
                        DbEntityEntry<SexSpider> entry = db.Entry(s);
                        entry.State = EntityState.Modified;
                        db.SaveChanges();
                    });
                }
            }
            catch (Exception ex)
            {
                log.Error(ex.Message);
            }
        }

        public void RemoveSiteList(string jsonHtml)
        {
            try
            {
                var jsonObject = Newtonsoft.Json.JsonConvert.DeserializeObject<List<SiteListViewModel>>(jsonHtml);

                var models = jsonObject.Adapt<List<SiteListViewModel>, List<SexSpider>>();

                using (var db = new SexSpiderDbContext())
                {
                    models.ForEach(s =>
                    {
                        db.SexSpider.Remove(db.SexSpider.Where(a => a.SiteId == s.SiteId).FirstOrDefault());
                        db.SaveChanges();
                    });
                }
            }
            catch (Exception ex)
            {
                log.Error(ex.Message);
            }
        }

        public SexSpider GetSexSpider(int siteId)
        {
            using (var db = new SexSpiderDbContext())
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
