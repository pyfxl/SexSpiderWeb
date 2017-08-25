using Business.ViewModel;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Data.Entity.Infrastructure;
using System.Linq;
using System.Text;

namespace Business
{
    public class SiteService
    {
        public SiteService()
        {
            AutoMapper.Mapper.Initialize(m => m.CreateMap<Repository.SexSpider, Business.ViewModel.SiteListViewModel>()
                .ForMember(vm => vm.siteid, dto => dto.MapFrom(mo => mo.SiteId))
                .ForMember(vm => vm.siterank, dto => dto.MapFrom(mo => mo.SiteRank))
                .ForMember(vm => vm.viplevel, dto => dto.MapFrom(mo => mo.VipLevel))
                .ForMember(vm => vm.ishided, dto => dto.MapFrom(mo => mo.IsHided))
                .ForMember(vm => vm.sitename, dto => dto.MapFrom(mo => mo.SiteName))
                .ForMember(vm => vm.listpage, dto => dto.MapFrom(mo => mo.ListPage))
                .ForMember(vm => vm.pageencode, dto => dto.MapFrom(mo => mo.PageEncode))
                .ForMember(vm => vm.domain, dto => dto.MapFrom(mo => mo.Domain))
                .ForMember(vm => vm.sitelink, dto => dto.MapFrom(mo => mo.SiteLink))
                .ForMember(vm => vm.listdiv, dto => dto.MapFrom(mo => mo.ListDiv))
                .ForMember(vm => vm.imagediv, dto => dto.MapFrom(mo => mo.ImageDiv))
                .ForMember(vm => vm.pagediv, dto => dto.MapFrom(mo => mo.PageDiv))
                .ForMember(vm => vm.pagelevel, dto => dto.MapFrom(mo => mo.PageLevel))
                .ForMember(vm => vm.listfilter, dto => dto.MapFrom(mo => mo.ListFilter))
                .ForMember(vm => vm.imagefilter, dto => dto.MapFrom(mo => mo.ImageFilter))
                .ForMember(vm => vm.pagefilter, dto => dto.MapFrom(mo => mo.PageFilter)).ReverseMap());
        }

        public string GetSiteList()
        {
            string html = "";

            using (var db = new Repository.AALifeDbContext())
            {
                var Businesss = db.SexSpider.OrderBy(s => s.SiteRank).ToList();

                var siteLists = AutoMapper.Mapper.Map<List<Repository.SexSpider>, List<SiteListViewModel>>(Businesss);

                html = Newtonsoft.Json.JsonConvert.SerializeObject(siteLists);
            }

            return html;
        }

        public void UpdateSiteList(string jsonHtml)
        {
            var jsonObject = Newtonsoft.Json.JsonConvert.DeserializeObject<List<SiteListViewModel>>(jsonHtml);

            var Business = AutoMapper.Mapper.Map<List<SiteListViewModel>, List<Repository.SexSpider>>(jsonObject);

            using (var db = new Repository.AALifeDbContext())
            {
                Business.ForEach(s => {
                    db.SexSpider.Attach(s);
                    DbEntityEntry<Repository.SexSpider> entry = db.Entry(s);
                    entry.State = EntityState.Modified;
                    db.SaveChanges();
                });
            }
        }

        public Repository.SexSpider GetSexSpider(int siteId)
        {
            using (var db = new Repository.AALifeDbContext())
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
            string word = "";

            string dic = "内射,內射,车震,大屁股,人妻,美臀,肥臀,翘臀,换妻,后入,後入,豐滿,水多,炮友,網友,白漿,闺蜜,陰道,少婦,熟婦,賓館,鮑魚,極品,鄰居";

            string[] dics = dic.Split(',');

            word = Newtonsoft.Json.JsonConvert.SerializeObject(dics);

            return word;
        }

        /// <summary>
        /// 取停止词典
        /// </summary>
        /// <returns></returns>
        public string GetStopDic()
        {
            string word = "";

            string dic = "的,了,在,是,我,有,和,就,不,人,都,一,一个,上,也,很,到,说,要,去,你,会,着,没有,看,好,自己,这";

            string[] dics = dic.Split(',');

            word = Newtonsoft.Json.JsonConvert.SerializeObject(dics);

            return word;
        }

    }
}
