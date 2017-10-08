using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;

namespace BusinessBLL.Filter
{
    public class GetJpgFilter : IFilter
    {
        public string DoFilter(string str)
        {
            return Regex.Replace(str, @"\?.*?([^""]+)", "");
        }
    }
}
