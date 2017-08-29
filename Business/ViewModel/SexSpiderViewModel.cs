using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace BusinessBLL.ViewModel
{
    /// <summary>
    /// BusinessViewModel 的摘要说明
    /// </summary>
    public class BusinessViewModel
    {
        public BusinessViewModel()
        {
            //
            // TODO: 在此处添加构造函数逻辑
            //
        }

        public List<SiteListViewModel> site_list { get; set; }

        public List<string> ext_dic { get; set; }

        public List<string> stop_dic { get; set; }

        public List<string> del_dic { get; set; }

    }
}