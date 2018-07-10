using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace BusinessBLL.Filter
{
    public interface IFilter
    {
        string DoFilter(string str);
    }
}
