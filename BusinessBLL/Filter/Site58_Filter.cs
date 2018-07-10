using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace BusinessBLL.Filter
{
    public class Site58_Filter : IFilter
    {
        public string DoFilter(string str)
        {
            var obj = Newtonsoft.Json.Linq.JObject.Parse(str);

            return obj["title"].ToString() + "," + obj["htmlname"].ToString() + ",";
        }
                
    }
}
