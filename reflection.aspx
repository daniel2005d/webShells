<%@ Page Language="C#" AutoEventWireup="true" %>

<%@ Import Namespace="System.Reflection" %>

<script language="c#" runat="server">
    void Page_Load(object sender, EventArgs e)
    {
        if (!this.IsPostBack)
        {
            this.loadFile();
        }

    }

    void loadFile()
    {
        this.litClases.Text = String.Empty;
        System.Reflection.Assembly asm = null;
        if (string.IsNullOrEmpty(this.txtDll.Text))
        {
            asm = System.Reflection.Assembly.GetExecutingAssembly();
        }
        else
        {
            asm = System.Reflection.Assembly.LoadFrom(this.txtDll.Text);
        }



        if (asm != null)
        {
            this.litAssembly.Text = "<b>Name: </b>" + asm.FullName + "<br/>";
            this.litAssembly.Text += "<b>In GAC </b>" + (asm.GlobalAssemblyCache ? "Yes" : "No") + "<br/>";
            this.litAssembly.Text += "<b>Code Base: </b>" + asm.CodeBase + "<br/>";
            this.litAssembly.Text += "<b>Location: </b>" + asm.Location + "<br/>";



            foreach (Type tc in asm.GetTypes())
            {
                this.litClases.Text += "<ul><b>" + tc.Name + "</b>";
                MemberInfo[] methodName = tc.GetMethods();
                PropertyInfo[] properties = tc.GetProperties();
                string li = "";
                foreach (MemberInfo method in methodName)
                {
                    li += "<li>" + method.Name.ToString() + "</li>";
                }
                this.litClases.Text += li + "</ul>";
                li = String.Empty;
                li += "<ul><b>Properties</b>";
                foreach (PropertyInfo info in properties)
                {
                    li += "<li>" + info.Name + "</li>";
                }
                this.litClases.Text += li + "</ul><hr/>";

            }
        }

    }

    protected void cmdExamine_Click(object sender, EventArgs e)
    {
        this.loadFile();
    }
</script>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Reflection - Cyb3rb0b</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link href="//netdna.bootstrapcdn.com/bootstrap/3.1.0/css/bootstrap.min.css" rel="stylesheet" />
    <script src="//code.jquery.com/jquery-1.11.1.min.js"></script>

    <script src="//netdna.bootstrapcdn.com/bootstrap/3.1.0/js/bootstrap.min.js"></script>

</head>
<body>
    <form id="form1" runat="server">
        <div style="margin-left: 38px;">


            <div class="row">
                <div class="col-md-10">
                    <asp:TextBox ID="txtDll" runat="server" Style="width: 100%"></asp:TextBox>
                </div>
                <div class="col-md-10">
                    <asp:Button ID="cmdExamine" runat="server" Text="Analyze" OnClick="cmdExamine_Click" />
                </div>
            </div>
            <div class="row">
                <h3>Assembly</h3>
            </div>
            <div class="row">
                <asp:Literal ID="litAssembly" runat="server"></asp:Literal>
            </div>
            <hr />
            <div class="row">
                <h3>Clases</h3>
            </div>
            <div class="row">
                <asp:Literal ID="litClases" runat="server"></asp:Literal>
            </div>
        </div>
    </form>
</body>
</html>
