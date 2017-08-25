﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;

namespace Business.Filter
{
    public class NoHtmlFilter : IFilter
    {
        public string DoFilter(string str)
        {
            return Regex.Replace(str, "<.+?>", "");
        }
    }
}
