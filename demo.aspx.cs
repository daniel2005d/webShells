using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebUtils
{
    public partial class demo : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request.QueryString["id"] != null)
            {
                using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["Conexion"].ConnectionString))
                {
                    SqlDataAdapter da = new SqlDataAdapter("Select * from Clientes where Id=" + Request.QueryString["id"].ToString(), con);
                    DataSet ds = new DataSet();
                    da.Fill(ds);
if (ds.Tables.Count > 0)
                    {
                        Response.Write(ds.Tables[0].Rows[0]["Nombre"].ToString());
                     //   this.txtName.Text = ds.Tables[0].Rows[0]["Nombre"].ToString();
                    }
                }
                    
            }
        }
    }
}