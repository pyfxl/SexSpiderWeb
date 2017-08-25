using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;

namespace Business.Filter
{
    public class SplitTitleFilter : IFilter
    {
        public string DoFilter(string str)
        {
            return str.Substring(0, str.IndexOf("&#12305;")) + "&#12305;";
        }
    }
}
