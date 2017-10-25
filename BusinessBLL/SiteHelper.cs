using BusinessBLL.Filter;
using BusinessBLL.Models;
using BusinessBLL.ViewModel;
using CsQuery;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Reflection;
using System.Text;
using System.Text.RegularExpressions;
using System.Web;

namespace BusinessBLL
{
    public class SiteHelper
    {
        /// <summary>
        /// 取站点列表
        /// </summary>
        public static IEnumerable<ListModel> GetSiteList(SexSpider sex)
        {
            string html = GetHtmlContent(sex.SiteLink, sex.PageEncode, sex.Domain);

            //过滤站点
            html = FilterHtml(html, sex.SiteFilter);

            FilterChain chain = LoadFilter(sex.ListFilter);

            if (sex.DocType == "json")
            {
                string[] root = Regex.Split(sex.ListDiv, "\\|\\|");
                var jObject = Newtonsoft.Json.Linq.JObject.Parse(html);
                var jToken = jObject[root[0]];

                foreach (var item in jToken)
                {
                    string[] child = root[1].Split('&');

                    yield return new ListModel
                    {
                        Title = System.Net.WebUtility.HtmlDecode(item.Value<string>(child[0])),
                        Link = GetLink(item.Value<string>(child[1]), sex.Domain),
                        Domain = sex.Domain
                    };
                }
            }
            else
            {
                CQ _document = CQ.CreateDocument(html);
                var content = _document[sex.ListDiv];
                foreach (var item in content)
                {
                    string _title = chain.DoFilter(item.InnerHTML);
                    string _link = GetLink(item.Attributes["href"], sex.Domain);

                    if (String.IsNullOrEmpty(_title)) continue;

                    yield return new ListModel
                    {
                        Title = System.Net.WebUtility.HtmlDecode(_title),
                        Link = _link,
                        Domain = sex.Domain
                    };
                }
            }
        }

        /// <summary>
        /// 取图片页面
        /// </summary>
        public static IEnumerable<ImageModel> GetListImage(SexSpider sex, string url)
        {
            string html = GetHtmlContent(url, sex.PageEncode, sex.Domain);

            //过滤站点
            html = FilterHtml(html, sex.SiteFilter);

            FilterChain chain = LoadFilter(sex.ImageFilter);
            
            CQ _document = CQ.CreateDocument(html);
            var content = _document[sex.ImageDiv];
            foreach (var item in content)
            {
                string link = "";
                if (chain.Count() > 0)
                {
                    link = chain.DoFilter(item.OuterHTML);
                }
                else
                {
                    link = item.Attributes["src"];
                }

                if (String.IsNullOrEmpty(link)) continue;

                string _image = GetLink(link, sex.Domain);

                yield return new ImageModel
                {
                    ImageUrl = _image,
                    ImageDomain = sex.Domain
                };
            }
        }

        /// <summary>
        /// 取有分页的图片
        /// </summary>
        public static IEnumerable<ImageModel> GetListImagePage(SexSpider sex, string url)
        {
            var images = new List<ImageModel>();
            var pages = new List<PageModel>();

            var newPages = SiteHelper.GetImagePage(sex, url).ToList();

            if (sex.PageLevel == 3)
            {
                string total = GetPageTotal(sex, url);
                pages = GetPageMany(url, newPages, total);
            }
            else if (sex.PageLevel == 2)
            {
                pages = GetPageMany(url, newPages, "");
            }
            else
            {
                pages = newPages;
            }
                        
            //添加原始页面
            pages.Insert(0, new PageModel { PageUrl = url });
            
            foreach (var p in pages)
            {
                var image = SiteHelper.GetListImage(sex, p.PageUrl).ToList();
                images.AddRange(image);
            }

            return images;
        }

        /// <summary>
        /// 取图片总页数
        /// </summary>
        public static string GetPageTotal(SexSpider sex, string url)
        {
            string total = "";
            string html = GetHtmlContent(url, sex.PageEncode, sex.Domain);

            //过滤站点
            html = FilterHtml(html, sex.SiteFilter);
            
            CQ _document = CQ.CreateDocument(html);
            var content = _document[sex.PageFilter];
            foreach (var item in content)
            {
                string str = HttpContext.Current.Server.HtmlDecode(item.InnerHTML);
                total = Regex.Replace(str, "[^\\d]", "");
            }

            return total;
        }
        
        /// <summary>
        /// 取图片分页
        /// </summary>
        public static IEnumerable<PageModel> GetImagePage(SexSpider sex, string url)
        {
            string html = GetHtmlContent(url, sex.PageEncode, sex.Domain);

            //过滤站点
            html = FilterHtml(html, sex.SiteFilter);

            FilterChain chain = LoadFilter(sex.PageFilter);
            html = chain.DoFilter(html);

            //分页的时候取当前页
            string _domain = url.Substring(0, url.LastIndexOf('/') + 1);

            CQ _document = CQ.CreateDocument(html);
            var content = _document[sex.PageDiv];
            foreach (var item in content)
            {
                //分页是点击类型没有内容要注释，此处与获取多分页时冲突
                if (!Regex.IsMatch(item.InnerHTML, @"^\d*$")) continue;

                string _link = item.Attributes["href"];

                if (_link == null || _link == "#" || _link.Contains("javascript")) continue;

                _link = GetLink(_link, _domain, sex.Domain);
                
                yield return new PageModel
                {
                    PageUrl = _link
                };
            }
        }

        /// <summary>
        /// 取html内容
        /// </summary>
        public static string GetHtmlContent2(string url, string encoding, string domain)
        {
            WebClient client = new WebClient();
            //client.Proxy = new WebProxy("127.0.0.1", 32438);
            client.Encoding = Encoding.GetEncoding(encoding);
            client.Headers.Add("User-Agent", "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/61.0.3163.13 Safari/537.36");
            client.Headers.Add("referer", domain);
            
            return client.DownloadString(url);
        }

        /// <summary>
        /// 取html内容
        /// </summary>
        public static string GetHtmlContent(string url, string encode, string domain)
        {
            HttpWebRequest req = (HttpWebRequest)WebRequest.Create(url);
            //req.Proxy = new WebProxy("127.0.0.1", 11866);
            req.AutomaticDecompression = DecompressionMethods.GZip;
            req.Referer = domain;
            req.UserAgent = "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/61.0.3163.13 Safari/537.36";
            
            HttpWebResponse rep = (HttpWebResponse)req.GetResponse();

            Stream stream = rep.GetResponseStream();
            StreamReader sr = new StreamReader(stream, Encoding.GetEncoding(encode));

            return sr.ReadToEnd();
        }

        /// <summary>
        /// 加载过滤器
        /// </summary>
        private static FilterChain LoadFilter(string str)
        {
            FilterChain chain = new FilterChain();

            if (str == null || str == "") return chain;

            string[] cls = str.Split(',');

            foreach(var c in cls)
            {
                string className = string.Format("BusinessBLL.Filter.{0}", c);
                var t = Type.GetType(className);
                if (t != null)
                {
                    var filter = Activator.CreateInstance(t) as IFilter;
                    chain.AddFilter(filter);
                }
            }

            return chain;
        }
        
        /// <summary>
        /// 取url地址
        /// </summary>
        private static string GetLink(string url, string domain)
        {
            if(url.StartsWith("http://") || url.StartsWith("https://"))
            {
                return url;
            }

            url = url.Replace("./", "").Replace("../", "");
            
            return domain + url;
        }

        /// <summary>
        /// 取url地址
        /// </summary>
        private static string GetLink(string url, string _domain, string domain)
        {
            if (url.StartsWith("http://") || url.StartsWith("https://"))
            {
                return url;
            }
            else if (url.StartsWith("/"))
            {
                return domain + url;
            }

            url = url.Replace("./", "").Replace("../", "");

            return _domain + url;
        }

        /// <summary>
        /// 取多个页面，用来取只显示部分页面站点，比如妹子图[1][2][3]...[70]
        /// </summary>
        private static List<PageModel> GetPageMany(string url, List<PageModel> newPages, string total)
        {
            var pages = new List<PageModel>();

            int lastPos = url.LastIndexOf('/');
            string urlFirst = url.Substring(0, lastPos);
            string urlEnd = url.Substring(lastPos);

            int dianPos = urlEnd.LastIndexOf('.');
            string dianFirst = "";
            if (dianPos != -1)
            {
                dianFirst = urlEnd.Substring(0, dianPos);
            }
            else
            {
                dianFirst = urlEnd;
            }

            string newUrl = urlFirst + dianFirst;

            string lastPage = newPages.FindLast(a => a.PageUrl != "").PageUrl;

            string pageStr = lastPage.Replace(newUrl, "");

            int pageNum = 0;

            if (total != "")
            {
                pageNum = Convert.ToInt32(total);
            }
            else
            {
                Int32.TryParse(Regex.Replace(pageStr, @"[^\d]", ""), out pageNum);
            }

            for (int i = 2; i <= pageNum; i++)
            {
                Regex r = new Regex(@"\d+");

                string newString = r.Replace(pageStr, i.ToString());

                pages.Add(new PageModel { PageUrl = newUrl + newString });
            }

            return pages;
        }
        
        /// <summary>
        /// 过滤站点html
        /// </summary>
        /// <param name="html"></param>
        /// <param name="filter"></param>
        /// <returns></returns>
        private static string FilterHtml(string html, string filter)
        {
            FilterChain chain = LoadFilter(filter);
            if (chain.Count() > 0)
            {
                html = chain.DoFilter(html);
            }

            return html;
        }
        
    }
}
