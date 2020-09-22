<%@ Page Language="C#" AutoEventWireup="true" %>


<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>

    <script language="c#" runat="server">

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!this.IsPostBack)
            {
                Configuration config = System.Web.Configuration.WebConfigurationManager.OpenWebConfiguration("~");
                foreach(KeyValueConfigurationElement app in config.AppSettings.Settings)
                {
                    this.lstAppSettings.Items.Add(app.Key+":"+app.Value);
                }
            }
        }

        private void ModifyValue(string key, string value)
        {
            Configuration config = System.Web.Configuration.WebConfigurationManager.OpenWebConfiguration("~");
            config.AppSettings.Settings.Remove(key);
            config.AppSettings.Settings.Add(key, value);
            config.Save();
        }

        protected void cmdChange_Click(object sender, EventArgs e)
        {
            string[] values = this.txtValue.Text.Split(new char[] { ':' }, StringSplitOptions.RemoveEmptyEntries);
            this.ModifyValue(values[0], values[1]);
        }

        protected void lstAppSettings_SelectedIndexChanged(object sender, EventArgs e)
        {

        }
</script>
<body>
    <form id="form1" runat="server">
        <div >

            <asp:ListBox ID="lstAppSettings" runat="server" style="width: 100%;height:100%" OnSelectedIndexChanged="lstAppSettings_SelectedIndexChanged"  />
        </div>
        <div>
            <asp:TextBox ID="txtValue" runat="server" />
            <asp:Button ID="cmdChange" runat="server" Text="Change Value" OnClick="cmdChange_Click" />
        </div>
    </form>
</body>
</html>
