using Business.Filter;
using Business.Models;
using CsQuery;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Reflection;
using System.Text;
using System.Text.RegularExpressions;

namespace Business
{
    public class SiteHelper
    {
        /// <summary>
        /// 取站点列表
        /// </summary>
        public static IEnumerable<ListModel> GetSiteList(string url, string encoding, string listStart, string listFilter, string domain)
        {
            string html = GetHtmlContent(url, encoding);

            FilterChain chain = LoadFilter(listFilter);
            
            CQ _document = CQ.CreateDocument(html);
            var content = _document[listStart];
            foreach (var item in content)
            {
                string _title = chain.DoFilter(item.InnerHTML);
                string _link = GetLink(item.Attributes["href"], domain);
                
                if (String.IsNullOrEmpty(_title)) continue;

                yield return new ListModel
                {
                    Title = System.Net.WebUtility.HtmlDecode(_title),
                    Link = _link
                };
            }
        }

        /// <summary>
        /// 取图片页面
        /// </summary>
        public static IEnumerable<ImageModel> GetListImage(string url, string encoding, string imgStart, string imgFilter, string domain)
        {
            string html = GetHtmlContent(url, encoding);

            FilterChain chain = LoadFilter(imgFilter);
            
            CQ _document = CQ.CreateDocument(html);
            var content = _document[imgStart];
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

                string _image = GetLink(link, domain);

                yield return new ImageModel
                {
                    ImageUrl = _image
                };
            }
        }

        /// <summary>
        /// 取有分页的图片
        /// </summary>
        public static IEnumerable<ImageModel> GetListImagePage(string url, string encoding, string imgStart, string imgFilter, string domain, string pageStart, string pageFilter, string pageLevel)
        {
            return GetListImagePage(url, encoding, imgStart, imgFilter, domain, pageStart, pageFilter, Convert.ToInt32(pageLevel));
        }

        /// <summary>
        /// 取有分页的图片
        /// </summary>
        public static IEnumerable<ImageModel> GetListImagePage(string url, string encoding, string imgStart, string imgFilter, string domain, string pageStart, string pageFilter, int pageLevel)
        {
            var images = new List<ImageModel>();
            var pages = new List<PageModel>();
            
            var newPages = SiteHelper.GetImagePage(url, encoding, pageStart, pageFilter).ToList();

            if (pageLevel == 2)
            {
                pages = GetPageMany(url, newPages);
            }
            else
            {
                pages = newPages;
            }
            
            //添加原始页面
            pages.Insert(0, new PageModel { PageUrl = url });
            
            foreach (var p in pages)
            {
                var image = SiteHelper.GetListImage(p.PageUrl, encoding, imgStart, imgFilter, domain).ToList();
                images.AddRange(image);
            }

            return images;
        }

        /// <summary>
        /// 取图片分页
        /// </summary>
        public static IEnumerable<PageModel> GetImagePage(string url, string encoding, string pageStart, string pageFilter)
        {
            string html = GetHtmlContent(url, encoding);

            FilterChain chain = LoadFilter(pageFilter);
            html = chain.DoFilter(html);

            string domain = url.Substring(0, url.LastIndexOf('/') + 1);

            CQ _document = CQ.CreateDocument(html);
            var content = _document[pageStart];
            foreach (var item in content)
            {
                if (!Regex.IsMatch(item.InnerHTML, @"^\d*$")) continue;

                string _link = item.Attributes["href"];

                if (_link == "#") continue;

                _link = GetLink(_link, domain);
                
                yield return new PageModel
                {
                    PageUrl = _link
                };
            }
        }

        /// <summary>
        /// 取html内容
        /// </summary>
        public static string GetHtmlContent(string url, string encoding)
        {
            WebClient client = new WebClient();
            //client.Proxy = new WebProxy("127.0.0.1", 32438);
            client.Encoding = Encoding.GetEncoding(encoding);
            client.Headers.Add("User-Agent", "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/61.0.3163.13 Safari/537.36");

            return client.DownloadString(url);
        }

        /// <summary>
        /// 加载过滤器
        /// </summary>
        private static FilterChain LoadFilter(string str)
        {
            FilterChain chain = new FilterChain();

            string[] cls = str.Split(',');

            foreach(var c in cls)
            {
                string className = string.Format("Business.Filter.{0}", c);
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
            
            return domain + url;
        }

        /// <summary>
        /// 取多个页面
        /// </summary>
        private static List<PageModel> GetPageMany(string url, List<PageModel> newPages)
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

            Int32.TryParse(Regex.Replace(pageStr, @"[^\d]", ""), out pageNum);

            for (int i = 2; i <= pageNum; i++)
            {
                Regex r = new Regex(@"\d+");

                string newString = r.Replace(pageStr, i.ToString());

                pages.Add(new PageModel { PageUrl = newUrl + newString });
            }

            return pages;
        }
    }
}
