using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace BusinessBLL.ViewModel
{
    public class SiteModel
    {
        /// <summary>
        /// 编号
        /// </summary>
        public int SiteId { get; set; }

        /// <summary>
        /// 排序
        /// </summary>
        public string SiteRank { get; set; }

        /// <summary>
        /// vip级别
        /// </summary>
        public int VipLevel { get; set; }

        /// <summary>
        /// 是否隐藏
        /// </summary>
        public int IsHided { get; set; }

        /// <summary>
        /// 站点名称
        /// </summary>
        public string SiteName { get; set; }

        /// <summary>
        /// 列表分页名称
        /// </summary>
        public string ListPage { get; set; }

        /// <summary>
        /// 页面编码
        /// </summary>
        public string PageEncode { get; set; }

        /// <summary>
        /// 域名
        /// </summary>
        public string Domain { get; set; }

        /// <summary>
        /// 站点地址
        /// </summary>
        public string SiteLink { get; set; }

        /// <summary>
        /// 列表开始标记
        /// </summary>
        public string ListStart { get; set; }

        /// <summary>
        /// 列表结束标记
        /// </summary>
        public string ListEnd { get; set; }

        /// <summary>
        /// 图片开始标记
        /// </summary>
        public string ImageStart { get; set; }

        /// <summary>
        /// 图片结束标记
        /// </summary>
        public string ImageEnd { get; set; }

        /// <summary>
        /// 地址包含字符
        /// </summary>
        public string OnInclude { get; set; }

        /// <summary>
        /// 地址不包含字符
        /// </summary>
        public string NotInclude { get; set; }

        /// <summary>
        /// 分页开始标记
        /// </summary>
        public string PageStart { get; set; }

        /// <summary>
        /// 分页结束标记
        /// </summary>
        public string PageEnd { get; set; }

        /// <summary>
        /// 下一分页
        /// </summary>
        public string PageNext { get; set; }
    }
}
