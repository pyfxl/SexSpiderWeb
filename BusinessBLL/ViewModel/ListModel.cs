using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace BusinessBLL.ViewModel
{
    public class ListModel
    {
        /// <summary>
        /// 标题
        /// </summary>
        public string Title { get; set; }

        /// <summary>
        /// 地址
        /// </summary>
        public string Link { get; set; }

        /// <summary>
        /// 域名
        /// </summary>
        public string Domain { get; set; }

        /// <summary>
        /// 缩略图
        /// </summary>
        public string Thumb { get; set; }
    }
}
