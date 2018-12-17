using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;

namespace BusinessBLL.Filter
{
    public class FengNiaoFilter : IFilter
    {
        public string DoFilter(string str)
        {
            try
            {
                str = str.Substring(str.IndexOf("picList = ") + 10);
                str = str.Substring(0, str.IndexOf(";"));
                str = str.Replace("\\/", "/");
                str = "{\"picList\":" + str + "}";
                return str;
            }
            catch { }

            return "";
        }
    }
}
