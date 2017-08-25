using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Business.Filter
{
    public interface IFilter
    {
        string DoFilter(string str);
    }
}
