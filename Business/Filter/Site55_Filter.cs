using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Business.Filter
{
    public class Site55_Filter : IFilter
    {
        public string DoFilter(string str)
        {
            str = str.Replace("-lp", "");

            return str;
        }
    }
}
