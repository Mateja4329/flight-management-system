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

namespace AirportProject.Forms
{
    /// <summary>
    /// Interaction logic for AddReservationWindow.xaml
    /// </summary>
    public partial class AddReservationWindow : Window
    {
        public AddReservationWindow()
        {
            InitializeComponent();

            LoadPassengerCombo();
            LoadFlightCombo();

        }

        private void LoadPassengerCombo()
        {
            try
            {
                Connection kon = new Connection();
                string query = "SELECT passenger_ID, f_name + ' ' + l_name + ' (' + passportNo + ')' AS FullInfo FROM tbl_Passenger";

                using(SqlConnection conn = kon.createConnection())
                {
                    conn.Open();
                    SqlDataAdapter da = new SqlDataAdapter(query, conn);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    cbPassengers.ItemsSource = dt.DefaultView;
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("Error: " + ex.Message);
            }
        }

        private void LoadFlightCombo()
        {
            try
            {
                Connection kon = new Connection();
                string query = "SELECT flight_ID, flightNo + ' - ' + destination AS FlightInfo FROM tbl_Flight";

                using (SqlConnection conn = kon.createConnection())
                {
                    conn.Open();
                    SqlDataAdapter da = new SqlDataAdapter(query, conn);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    cbFlights.ItemsSource = dt.DefaultView;
                }
            }
            catch (Exception ex) 
            { 
                MessageBox.Show("Error: " + ex.Message);
            }
        }

        private void btnSave_Click(object sender, RoutedEventArgs e)
        {
            if (cbPassengers.SelectedValue == null ||
            cbFlights.SelectedValue == null ||
            cbClass.SelectedItem == null ||
            cbCheckInType.SelectedItem == null ||
            string.IsNullOrEmpty(txtPrice.Text) ||
            string.IsNullOrEmpty(txtSeat.Text))
            {
                MessageBox.Show("Please fill ALL fields (Passenger, Flight, Price, Seat, Class, Check-In Type).", "Error", MessageBoxButton.OK, MessageBoxImage.Error);
                return;
            }

            try
            {
                // getting the passengers
                int passengerID = (int)cbPassengers.SelectedValue;
                int flightID = (int)cbFlights.SelectedValue;
                decimal price = decimal.Parse(txtPrice.Text);
                string seatNo = txtSeat.Text;
                DateTime now = DateTime.Now;

                // reading comboboxes
                string ticketClass = ((ComboBoxItem)cbClass.SelectedItem).Content.ToString();
                string checkInType = ((ComboBoxItem)cbCheckInType.SelectedItem).Content.ToString();

                // Generating boarding code
                DataRowView selectedFlight = (DataRowView)cbFlights.SelectedItem;
                string flightInfo = selectedFlight["FlightInfo"].ToString();
                string flightNo = flightInfo.Split('-')[0].Trim();

                string boardingCode = $"{flightNo}-{seatNo}-{new Random().Next(1000, 9999)}";

                Connection kon = new Connection();
                using (SqlConnection conn = kon.createConnection())
                {
                    conn.Open();

                    // Duplicates check (The Bouncer)
                    string checkQuery = @"SELECT COUNT(*) FROM tbl_Booking B
                                  INNER JOIN tbl_Ticket T ON B.booking_ID = T.booking_ID
                                  WHERE B.passenger_ID = @passID AND T.flight_ID = @flightID";

                    SqlCommand cmdCheck = new SqlCommand(checkQuery, conn);
                    cmdCheck.Parameters.AddWithValue("@passID", passengerID);
                    cmdCheck.Parameters.AddWithValue("@flightID", flightID);

                    int count = (int)cmdCheck.ExecuteScalar();

                    if (count > 0)
                    {
                        MessageBox.Show("This passenger already has a reservation for this flight!", "Duplicate Error", MessageBoxButton.OK, MessageBoxImage.Warning);
                        return;
                    }

                    // 4. INSERT BOOKING
                    string queryBooking = @"INSERT INTO tbl_Booking (bookingDate, status, totalPrice, passenger_ID) 
                                    VALUES (@date, 'Pending', @price, @passID);
                                    SELECT SCOPE_IDENTITY();";

                    SqlCommand cmdBooking = new SqlCommand(queryBooking, conn);
                    cmdBooking.Parameters.AddWithValue("@date", now);
                    cmdBooking.Parameters.AddWithValue("@price", price);
                    cmdBooking.Parameters.AddWithValue("@passID", passengerID);

                    int newBookingID = Convert.ToInt32(cmdBooking.ExecuteScalar());

                    // 5. INSERT TICKET
                    string queryTicket = @"INSERT INTO tbl_Ticket (seatNo, class, price, flight_ID, booking_ID)
                                   VALUES (@seat, @class, @price, @flightID, @bookingID);
                                   SELECT SCOPE_IDENTITY();";

                    SqlCommand cmdTicket = new SqlCommand(queryTicket, conn);
                    cmdTicket.Parameters.AddWithValue("@seat", seatNo);
                    cmdTicket.Parameters.AddWithValue("@class", ticketClass);
                    cmdTicket.Parameters.AddWithValue("@price", price);
                    cmdTicket.Parameters.AddWithValue("@flightID", flightID);
                    cmdTicket.Parameters.AddWithValue("@bookingID", newBookingID);

                    int newTicketID = Convert.ToInt32(cmdTicket.ExecuteScalar());

                    // 6. INSERT CHECK-IN
                    string queryCheckIn = @"INSERT INTO tbl_CheckIn (checkinTime, type, boardingPassCode, ticket_ID, desk_ID)
                                    VALUES (@time, @type, @code, @ticketID, 'AdminDesk')";

                    SqlCommand cmdCheckIn = new SqlCommand(queryCheckIn, conn);
                    cmdCheckIn.Parameters.AddWithValue("@time", now);
                    cmdCheckIn.Parameters.AddWithValue("@type", checkInType);
                    cmdCheckIn.Parameters.AddWithValue("@code", boardingCode);
                    cmdCheckIn.Parameters.AddWithValue("@ticketID", newTicketID);

                    cmdCheckIn.ExecuteNonQuery();

                    MessageBox.Show("Reservation Created Successfully!", "Success", MessageBoxButton.OK, MessageBoxImage.Information);
                    this.Close();
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("Error creating reservation: " + ex.Message);
            }
        }

        private void btnCancel_Click(object sender, RoutedEventArgs e)
        {
            this.Close();
        }
    }
}
