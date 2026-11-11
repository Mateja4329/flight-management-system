using System;
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

namespace AirportProject
{
    /// <summary>
    /// Interaction logic for LoginWindow.xaml
    /// </summary>
    public partial class LoginWindow : Window
    {
        public LoginWindow()
        {
            // create, configure, and position the components
            // (controls, layout, event handlers) on a user interface (UI)
            // form or window
            InitializeComponent();
        }

        private void btnExit_Click(object sender, RoutedEventArgs e)
        {
            Application.Current.Shutdown();
        }

        private void btnLogin_Click(object sender, RoutedEventArgs e)
        {
            string userinput = txtUsername.Text;
            string passinput = txtPassword.Password;

            if(string.IsNullOrEmpty(userinput) || string.IsNullOrEmpty(passinput))
            {
                MessageBox.Show("Please enter both username and password.");
                return;
            }

            try
            {
                Connection kon = new Connection();

                // using is used for opening a safe connection with the database
                // it means that the "door" will automatically close
                // once we finish. It's important because of garbage collection
                // and memory leak
                using (SqlConnection conn = kon.createConnection())
                {
                    conn.Open();

                    // checking if it's staff (admin)
                    string queryStaff = "SELECT staff_ID FROM tbl_staff WHERE username=@user AND password=@pass";
                    SqlCommand cmdStaff = new SqlCommand(queryStaff, conn);
                    // @user, @pass, etc. are used against SQL injections
                    // and are easier to use than the other method

                    // we say that anything that is inside of userinput is just data
                    // threat it like a text and don't execute it
                    cmdStaff.Parameters.AddWithValue("@user", userinput);
                    cmdStaff.Parameters.AddWithValue("@pass", passinput);

                    object resultStaff = cmdStaff.ExecuteScalar();

                    // if we found someone
                    if(resultStaff != null)
                    {
                        MessageBox.Show($"Welcome {userinput}");
                        MainWindow adminPanel = new MainWindow();
                        adminPanel.Show();
                        this.Close();
                        return;
                    }

                    // checking if it's a passenger
                    string queryPass = "SELECT passenger_ID FROM tbl_passenger WHERE username=@user AND password=@pass";
                    SqlCommand cmdPass = new SqlCommand(queryPass, conn);

                    cmdPass.Parameters.AddWithValue("@user", userinput);
                    cmdPass.Parameters.AddWithValue("@pass", passinput);

                    object resultPass = cmdPass.ExecuteScalar();

                    if(resultPass != null)
                    {
                        int foundID = Convert.ToInt32(resultPass);
                        MessageBox.Show($"Welcome {userinput}!");

                        PassengerDashboard userPanel = new PassengerDashboard(foundID, userinput);
                        userPanel.Show();
                        this.Close();
                        return;
                    }
                    else
                    {
                        MessageBox.Show("Invalid username or password.", "Login Failed", MessageBoxButton.OK, MessageBoxImage.Error);
                    }
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("Error: " +  ex.Message);
            }
        }
    }
}
