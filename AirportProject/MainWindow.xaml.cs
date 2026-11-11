using AirportProject.Forms;
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
using System.Windows.Navigation;
using System.Windows.Shapes;

namespace AirportProject
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        public MainWindow()
        {
            InitializeComponent();

            LoadPassengers();
            LoadFlights();
            LoadReservations();
        }

        private void LoadPassengers()
        {
            try
            {
                Connection kon = new Connection();

                string query = "SELECT * FROM tbl_Passenger";

                using (SqlConnection conn = kon.createConnection())
                {
                    conn.Open();

                    // it is used for reading
                    SqlDataAdapter adapter = new SqlDataAdapter(query, conn);

                    // making an empty table first, then inserting the data
                    DataTable dt = new DataTable();

                    // adapter goes to the base and then fills the data in the table
                    adapter.Fill(dt);

                    // we connect DataGrid (dgPassengers) with this table in memory
                    dgPassengers.ItemsSource = dt.DefaultView;
                }
            }
            catch(Exception ex)
            {
                MessageBox.Show("Error while loading: " + ex.Message);
            }
        }

        private void btnAddPassenger_Click(object sender, RoutedEventArgs e)
        {
            PassengerWindow pw = new PassengerWindow();
            pw.ShowDialog();
            LoadPassengers();
        }

        private void btnEditPassenger_Click(object sender, RoutedEventArgs e)
        {
            // checking if the user selected the item
            if(dgPassengers.SelectedItem == null)
            {
                MessageBox.Show("Please select a passenger to edit.", "Warning", MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }

            // then taking the data from the selected item
            DataRowView row = (DataRowView)dgPassengers.SelectedItem;

            PassengerWindow editForm = new PassengerWindow(row);
            editForm.ShowDialog();

            LoadPassengers();
        }

        private void btnDeletePassenger_Click(object sender, RoutedEventArgs e)
        {
            if (dgPassengers.SelectedItem == null)
            {
                MessageBox.Show("Please select a passenger to delete.", "Warning", MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }

            MessageBoxResult result = MessageBox.Show("Are you sure you want to delete this passenger?", "Confirm", MessageBoxButton.YesNo, MessageBoxImage.Question);

            if (result == MessageBoxResult.No)
                return;

            try
            {
                // this (DataRowView) is called "casting" which means
                // that this isn't just an object
                DataRowView row = (DataRowView)dgPassengers.SelectedItem;
                int idForDeletion = (int)row["passenger_ID"];

                Connection kon = new Connection();
                using(SqlConnection conn = kon.createConnection())
                {
                    conn.Open();

                    // CheckIn
                    string queryDeleteCheckIn = @"DELETE C FROM tbl_CheckIn C
                                                INNER JOIN tbl_Ticket T ON C.ticket_ID = T.ticket_ID
                                                INNER JOIN tbl_Booking B ON T.booking_ID = B.booking_ID
                                                WHERE B.passenger_ID = @id";

                    SqlCommand cmd1 = new SqlCommand(queryDeleteCheckIn, conn);
                    cmd1.Parameters.AddWithValue("@id", idForDeletion);
                    cmd1.ExecuteNonQuery();

                    // Tickets
                    string queryDeleteTickets = @"DELETE T FROM tbl_Ticket T
                                                INNER JOIN tbl_Booking B ON T.booking_ID = B.booking_ID
                                                WHERE B.passenger_ID = @id";
                    SqlCommand cmd2 = new SqlCommand(queryDeleteTickets, conn);
                    cmd2.Parameters.AddWithValue("@id", idForDeletion);
                    cmd2.ExecuteNonQuery();

                    // Payment
                    string queryDeletePayments = "DELETE FROM tbl_Payment WHERE booking_ID IN (SELECT booking_ID FROM tbl_Booking WHERE passenger_ID = @id)";
                    SqlCommand cmd3 = new SqlCommand(queryDeletePayments, conn);
                    cmd3.Parameters.AddWithValue("@id", idForDeletion);
                    cmd3.ExecuteNonQuery();

                    // Booking
                    string queryDeleteBooking = "DELETE FROM tbl_Booking WHERE passenger_ID = @id";
                    SqlCommand cmd4 = new SqlCommand(queryDeleteBooking, conn);
                    cmd4.Parameters.AddWithValue("@id", idForDeletion);
                    cmd4.ExecuteNonQuery();

                    // Passenger
                    string queryDeletePassenger = "DELETE FROM tbl_Passenger WHERE passenger_ID = @id";
                    SqlCommand cmdFinal = new SqlCommand(queryDeletePassenger, conn);
                    cmdFinal.Parameters.AddWithValue("@id", idForDeletion);
                    cmdFinal.ExecuteNonQuery();

                    MessageBox.Show("Passenger deleted successfully.", "Success", MessageBoxButton.OK, MessageBoxImage.Information);

                    LoadPassengers();
                    LoadReservations();
                }
            }
            catch (Exception ex)
            {
                // IF passenger has foreign keys it will NOT get deleted due to safety measures
                MessageBox.Show("Error deleting passenger: " + ex.Message, "Error", MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private void LoadFlights()
        {
            try
            {
                Connection kon = new Connection();

                string query = "SELECT flightNo, destination, departureTime, arrivalTime, status FROM tbl_Flight";

                using(SqlConnection conn = kon.createConnection())
                {
                    conn.Open();
                    SqlDataAdapter adapter = new SqlDataAdapter(query, conn);
                    DataTable dt = new DataTable();

                    adapter.Fill(dt);
                    
                    // connecting it with the flights table
                    dgFlights.ItemsSource = dt.DefaultView;
                }
            }
            catch (System.Exception ex)
            {
                MessageBox.Show("Error loading flights: " + ex.Message);
            }
        }

        private void LoadReservations()
        {
            try
            {
                Connection kon = new Connection();

                string query = @"
                        SELECT 
                        B.booking_ID,
                        P.f_name + ' ' + P.l_name AS Passenger,
                        T.seatNo AS Seat,
                        T.class AS Class,
                        ISNULL(C.boardingPassCode, 'NOT CHECKED-IN') AS QRCode,
                        C.checkinTime AS CheckInTime,
                        ISNULL(C.type, 'Pending') AS CheckInType
                        FROM tbl_Ticket T
                        INNER JOIN tbl_Booking B ON T.booking_ID = B.booking_ID
                        INNER JOIN tbl_Passenger P ON B.passenger_ID = P.passenger_ID
                        LEFT JOIN tbl_CheckIn C ON T.ticket_ID = C.ticket_ID";

                using (SqlConnection conn = kon.createConnection())
                {
                    conn.Open();
                    SqlDataAdapter adapter = new SqlDataAdapter(query, conn);
                    DataTable dt = new DataTable();

                    adapter.Fill(dt);

                    dgReservations.ItemsSource = dt.DefaultView;
                }
            }
            catch(System.Exception ex)
            {
                MessageBox.Show("Error loading reservations: " + ex.Message);
            }
        }

        private void btnExit_Click(object sender, RoutedEventArgs e)
        {
            LoginWindow login = new LoginWindow();
            login.Show();
            this.Close();
        }

        private void btnAddReservation_Click(object sender, RoutedEventArgs e)
        {
            AddReservationWindow addRes = new AddReservationWindow();
            addRes.ShowDialog();

            // this refreshes the table
            LoadReservations();
        }

        private void btnDeleteReservation_Click(object sender, RoutedEventArgs e)
        {
            if (dgReservations.SelectedItem == null)
            {
                MessageBox.Show("Please select a reservation to delete.");
                return;
            }

            if (MessageBox.Show("Are you sure? This will delete the booking, ticket and check-in info.", "Confirm", MessageBoxButton.YesNo, MessageBoxImage.Warning) == MessageBoxResult.No)
            {
                return;
            }

            try
            {
                DataRowView row = (DataRowView)dgReservations.SelectedItem;

                int bookingID = (int)row["booking_ID"];

                Connection kon = new Connection();
                using (SqlConnection conn = kon.createConnection())
                {
                    conn.Open();

                    // Delete check-in
                    string q1 = "DELETE C FROM tbl_CheckIn C INNER JOIN tbl_Ticket T ON C.ticket_ID = T.ticket_ID WHERE T.booking_ID = @id";
                    SqlCommand cmd1 = new SqlCommand(q1, conn);
                    cmd1.Parameters.AddWithValue("@id", bookingID);
                    cmd1.ExecuteNonQuery();

                    // Delete ticket
                    string q2 = "DELETE FROM tbl_Ticket WHERE booking_ID = @id";
                    SqlCommand cmd2 = new SqlCommand(q2, conn);
                    cmd2.Parameters.AddWithValue("@id", bookingID);
                    cmd2.ExecuteNonQuery();

                    // Delete payment (if it exists)
                    string q3 = "DELETE FROM tbl_Payment WHERE booking_ID = @id";
                    SqlCommand cmd3 = new SqlCommand(q3, conn);
                    cmd3.Parameters.AddWithValue("@id", bookingID);
                    cmd3.ExecuteNonQuery();

                    // Delete the selected reservation
                    string q4 = "DELETE FROM tbl_Booking WHERE booking_ID = @id";
                    SqlCommand cmd4 = new SqlCommand(q4, conn);
                    cmd4.Parameters.AddWithValue("@id", bookingID);
                    cmd4.ExecuteNonQuery();

                    MessageBox.Show("Reservation deleted successfully.");

                    // Refresh
                    LoadReservations();
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("Error deleting reservation: " + ex.Message);
            }
        }
    }
}
