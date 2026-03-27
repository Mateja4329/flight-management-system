using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data.SqlClient;

namespace AirportProject
{
    internal class Connection
    {
        public SqlConnection createConnection()
        {
            SqlConnectionStringBuilder ccnSb = new SqlConnectionStringBuilder
            {
                DataSource = ".\\SQLEXPRESS",
                InitialCatalog = "AirportSystem",
                IntegratedSecurity = true
            };

            string conn = ccnSb.ToString();
            SqlConnection connection = new SqlConnection(conn);
            return connection;
        }
    }
}
