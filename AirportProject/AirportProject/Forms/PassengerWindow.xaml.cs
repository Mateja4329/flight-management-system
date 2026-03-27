using System;
using AirportProject;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Shapes;
using System.Data;

namespace AirportProject.Forms
{
    public partial class PassengerWindow : Window
    {
        // this variable stortes passenger ID
        // if its 0 then insert, if not, then update
        private int passenger_ID = 0;
        public PassengerWindow()
        {
            InitializeComponent();
            passenger_ID = 0; // setting on 0 because new
        }

        public PassengerWindow(DataRowView row)
        {
            InitializeComponent();

            // save the id to know who to edit
            passenger_ID = (int)row["passenger_ID"];

            // filling the text boxes with the data from the table
            f_name.Text = row["f_name"].ToString();
            l_name.Text = row["l_name"].ToString();
            passportNo.Text = row["passportNo"].ToString();
            UMCN.Text = row["umcn"].ToString();
            email.Text = row["email"].ToString();
            address.Text = row["address"].ToString();
            contact.Text = row["contact"].ToString();
            username.Text = row["username"].ToString();
            password.Password = row["password"].ToString();

            this.Title = "Edit Passenger";
            btnSubmit.Content = "UPDATE";
        }

        private void btnCancel_Click(object sender, RoutedEventArgs e)
        {
            this.Close();
        }

        private void btnSubmit_Click(object sender, RoutedEventArgs e)
        {
            if(f_name.Text == "" || l_name.Text == "" 
                || passportNo.Text == "" || UMCN.Text == "" 
                || email.Text == "" || address.Text == "" 
                || contact.Text == "" || username.Text  == "" 
                || password.Password == "")
            {
                MessageBox.Show("Please fill all the required fields");
                return;
            }

            try
            {
                Connection kon = new Connection();
                string query = "";

                if (passenger_ID == 0)
                {
                    query = @"INSERT INTO tbl_passenger
                                (f_name, l_name, passportNo, umcn, email, address, contact, username, password)
                                VALUES
                                (@f_name, @l_name, @passportNo, @umcn, @email, @address, @contact, @username, @password)";
                }
                else
                {
                    query = @"UPDATE tbl_passenger
                                SET f_name=@f_name, l_name=@l_name, passportNo=@passportNo,
                                umcn=@umcn, email=@email, address=@address, contact=@contact,
                                username=@username, password=@password
                            WHERE passenger_ID=@id";
                                
                }

                using (SqlConnection conn = kon.createConnection())
                {
                    // Opening the database
                    conn.Open();
                    SqlCommand cmd = new SqlCommand(query, conn);

                    // Connecting textbox with the database
                    cmd.Parameters.AddWithValue("@f_name", f_name.Text);
                    cmd.Parameters.AddWithValue("@l_name", l_name.Text);
                    cmd.Parameters.AddWithValue("@passportNo", passportNo.Text);
                    cmd.Parameters.AddWithValue("@umcn", UMCN.Text);
                    cmd.Parameters.AddWithValue("@email", email.Text);
                    cmd.Parameters.AddWithValue("@address", address.Text);
                    cmd.Parameters.AddWithValue("@contact", contact.Text);
                    cmd.Parameters.AddWithValue("@username", username.Text);

                    cmd.Parameters.AddWithValue("@password", password.Password);

                    // if update, then add ID parameter
                    if(passenger_ID != 0)
                    {
                        cmd.Parameters.AddWithValue("@id", passenger_ID);
                    }

                    // EXECUTE (insert to the database)
                    cmd.ExecuteNonQuery();

                    MessageBox.Show("Passenger successfully added!", "Success", MessageBoxButton.OK, MessageBoxImage.Information);
                    this.Close();
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("Error saving data: " + ex.Message, "Database Error", MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }
    }
}
