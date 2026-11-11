using System;
using System.Collections.Generic;
using System.Data;
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
    /// Interaction logic for PassengerDashboard.xaml
    /// </summary>
    public partial class PassengerDashboard : Window
    {
        private int myID;
        public PassengerDashboard(int IDloggedUser, string username)
        {
            InitializeComponent();
            this.myID = IDloggedUser;

            this.Title = "Dashboard: " + username;

            LoadMyFlights();
        }

        private void LoadMyFlights()
        {
            try
            {
                Connection kon = new Connection();

                string query = @"
                            SELECT 
                            B.booking_ID, 
                            F.flightNo, 
                            F.destination, 
                            F.departureTime, 
                            F.status AS FlightStatus,
                            B.status AS BookingStatus,
                            T.seatNo,
                            T.class,
                            B.totalPrice
                            FROM tbl_Booking B
                            INNER JOIN tbl_Ticket T ON B.booking_ID = T.booking_ID
                            INNER JOIN tbl_Flight F ON T.flight_ID = F.flight_ID
                            WHERE B.passenger_ID = @myID";

                using (SqlConnection conn = kon.createConnection())
                {
                    conn.Open();
                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@myID", this.myID);

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    dgMyFlights.ItemsSource = dt.DefaultView;
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("Error: " + ex.Message);
            }
        }

        private void dgMyFlights_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            // if nothing loaded, reset the button
            if (dgMyFlights.SelectedItem == null)
            {
                ResetUI();
                return;
            }

            // if we select the data row in the datatable
            // then it turns into DataRowView (row from database)
            // so the program can read columns such as booking_ID or BookingStatus
            DataRowView row = (DataRowView)dgMyFlights.SelectedItem;
            // trim is used for e.g. "Pending " -> "Pending"
            string bookingStatus = row["BookingStatus"].ToString().Trim();

            if (bookingStatus == "Pending")
            {
                // button to confirm
                btnAction.Content = "✅ Confirm & Pay";
                btnAction.Background = new SolidColorBrush(Colors.Green);
                btnAction.IsEnabled = true;

                // show checkbox
                pnlTerms.Visibility = Visibility.Visible;
                cbTerms.IsChecked = false;
            }
            else if (bookingStatus == "Confirmed")
            {
                // if its paid
                btnAction.Content = "Already Confirmed";
                btnAction.Background = new SolidColorBrush(Colors.Gray);
                btnAction.IsEnabled = false;

                pnlTerms.Visibility = Visibility.Hidden;
            }
            else
            {
                // if its canceled
                btnAction.Content = bookingStatus;
                btnAction.IsEnabled = false;
                pnlTerms.Visibility = Visibility.Hidden;
            }
        }

        private void ResetUI()
        {
            btnAction.Content = "Select a Flight";
            btnAction.Background = new SolidColorBrush(Colors.Gray);
            btnAction.IsEnabled = false;
            pnlTerms.Visibility = Visibility.Hidden;
        }

        private void btnAction_Click(object sender, RoutedEventArgs e)
        {
            // more protection
            if (dgMyFlights.SelectedItem == null) return;

            // checking if its ckecked (how original)
            if (cbTerms.IsChecked == false)
            {
                MessageBox.Show("You must agree to the Terms of Service first!", "Terms Required", MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }

            try
            {
                DataRowView row = (DataRowView)dgMyFlights.SelectedItem;
                int bookingID = (int)row["booking_ID"];

                Connection kon = new Connection();
                using (SqlConnection conn = kon.createConnection())
                {
                    conn.Open();

                    // UPDATE STATUS NA CONFIRMED
                    string query = "UPDATE tbl_Booking SET status = 'Confirmed' WHERE booking_ID = @id";
                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@id", bookingID);
                    // ExecuteQuery is not expected to return some data,
                    // but rather just execute an order
                    cmd.ExecuteNonQuery();

                    MessageBox.Show("Reservation Confirmed! Have a safe flight.", "Success", MessageBoxButton.OK, MessageBoxImage.Information);

                    LoadMyFlights();
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("Error: " + ex.Message);
            }
        }

        private void btnExit_Click(object sender, RoutedEventArgs e)
        {
            LoginWindow login = new LoginWindow();
            login.Show();
            this.Close();
        }
    }
}
