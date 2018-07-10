<%@ WebHandler Language="C#" Class="ImageHandler" %>

using System;
using System.Web;
using System.Net;
using System.Drawing;
using System.IO;

public class ImageHandler : IHttpHandler {

    public void ProcessRequest (HttpContext context) {
        string imgUrl = context.Request["url"];
        string imgDomain = context.Request["domain"];
        if (!string.IsNullOrEmpty(imgUrl))
        {
            Uri myUri = new Uri(imgUrl);
            HttpWebRequest webRequest = (HttpWebRequest)WebRequest.Create(myUri);
            webRequest.Referer = imgDomain;
            HttpWebResponse webResponse = (HttpWebResponse)webRequest.GetResponse();
            Bitmap myImage = new Bitmap(webResponse.GetResponseStream());

            MemoryStream ms = new MemoryStream();
            myImage.Save(ms, System.Drawing.Imaging.ImageFormat.Jpeg);
            context.Response.ClearContent();
            context.Response.ContentType = "image/jpeg";

            context.Response.BinaryWrite(ms.ToArray());
        }
    }

    public bool IsReusable {
        get {
            return false;
        }
    }

}