using CsQuery;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Xml;

namespace BusinessBLL.Filter
{
    public class Site55_Filter : IFilter
    {
        public string DoFilter(string str)
        {
            CQ _document = CQ.Create(str);

            str = _document[0].Attributes["src"];

            if (str == "") return "";

            return str.Replace("-lp", "");
        }
        
    }
}
