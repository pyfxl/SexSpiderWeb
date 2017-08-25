using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Business.ViewModel
{
    /// <summary>
    /// SiteListViewModel 的摘要说明
    /// </summary>
    public class SiteListViewModel
    {
        public SiteListViewModel()
        {
            //
            // TODO: 在此处添加构造函数逻辑
            //
        }

        public string siteid { get; set; }
        public string siterank { get; set; }
        public string viplevel { get; set; }
        public string ishided { get; set; }
        public string sitename { get; set; }
        public string listpage { get; set; }
        public string pageencode { get; set; }
        public string domain { get; set; }
        public string sitelink { get; set; }
        public string listdiv { get; set; }
        public string imagediv { get; set; }
        public string pagediv { get; set; }
        public string pagelevel { get; set; }
        public string listfilter { get; set; }
        public string imagefilter { get; set; }
        public string pagefilter { get; set; }

    }
}