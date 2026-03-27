USE [master]
GO
/****** Object:  Database [AirportSystem]    Script Date: 14.12.2025. 14:47:29 ******/
CREATE DATABASE [AirportSystem]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'AirportSystem', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL17.SQLEXPRESS\MSSQL\DATA\AirportSystem.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'AirportSystem_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL17.SQLEXPRESS\MSSQL\DATA\AirportSystem_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [AirportSystem] SET COMPATIBILITY_LEVEL = 170
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [AirportSystem].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [AirportSystem] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [AirportSystem] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [AirportSystem] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [AirportSystem] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [AirportSystem] SET ARITHABORT OFF 
GO
ALTER DATABASE [AirportSystem] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [AirportSystem] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [AirportSystem] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [AirportSystem] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [AirportSystem] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [AirportSystem] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [AirportSystem] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [AirportSystem] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [AirportSystem] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [AirportSystem] SET  DISABLE_BROKER 
GO
ALTER DATABASE [AirportSystem] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [AirportSystem] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [AirportSystem] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [AirportSystem] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [AirportSystem] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [AirportSystem] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [AirportSystem] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [AirportSystem] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [AirportSystem] SET  MULTI_USER 
GO
ALTER DATABASE [AirportSystem] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [AirportSystem] SET DB_CHAINING OFF 
GO
ALTER DATABASE [AirportSystem] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [AirportSystem] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [AirportSystem] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [AirportSystem] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [AirportSystem] SET OPTIMIZED_LOCKING = OFF 
GO
ALTER DATABASE [AirportSystem] SET QUERY_STORE = ON
GO
ALTER DATABASE [AirportSystem] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [AirportSystem]
GO
/****** Object:  Table [dbo].[tbl_Baggage]    Script Date: 14.12.2025. 14:47:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Baggage](
	[baggabe_ID] [int] IDENTITY(1,1) NOT NULL,
	[weight] [decimal](5, 2) NOT NULL,
	[type] [nvarchar](20) NOT NULL,
	[isFragile] [bit] NOT NULL,
	[status] [nvarchar](15) NOT NULL,
	[checkIn_ID] [int] NOT NULL,
 CONSTRAINT [PK_tbl_Baggage] PRIMARY KEY CLUSTERED 
(
	[baggabe_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_Booking]    Script Date: 14.12.2025. 14:47:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Booking](
	[booking_ID] [int] IDENTITY(1,1) NOT NULL,
	[bookingDate] [datetime] NOT NULL,
	[status] [nvarchar](50) NOT NULL,
	[totalPrice] [decimal](5, 2) NOT NULL,
	[passenger_ID] [int] NOT NULL,
 CONSTRAINT [PK_tbl_Booking] PRIMARY KEY CLUSTERED 
(
	[booking_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_CheckIn]    Script Date: 14.12.2025. 14:47:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_CheckIn](
	[checkIn_ID] [int] IDENTITY(1,1) NOT NULL,
	[checkinTime] [datetime] NOT NULL,
	[type] [nvarchar](20) NOT NULL,
	[boardingPassCode] [nvarchar](50) NOT NULL,
	[desk_ID] [nvarchar](10) NULL,
	[ticket_ID] [int] NOT NULL,
 CONSTRAINT [PK_tbl_CheckIn] PRIMARY KEY CLUSTERED 
(
	[checkIn_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [IX_tbl_CheckIn] UNIQUE NONCLUSTERED 
(
	[ticket_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_Flight]    Script Date: 14.12.2025. 14:47:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Flight](
	[flight_ID] [int] IDENTITY(1,1) NOT NULL,
	[flightNo] [nvarchar](20) NOT NULL,
	[destination] [nvarchar](50) NOT NULL,
	[departureTime] [datetime] NOT NULL,
	[arrivalTime] [datetime] NOT NULL,
	[status] [nvarchar](20) NOT NULL,
	[gate_ID] [int] NULL,
	[airlineStaff_ID] [int] NULL,
 CONSTRAINT [PK_tbl_Flight] PRIMARY KEY CLUSTERED 
(
	[flight_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_Gate]    Script Date: 14.12.2025. 14:47:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Gate](
	[gate_ID] [int] IDENTITY(1,1) NOT NULL,
	[gateNo] [nvarchar](10) NOT NULL,
	[status] [nvarchar](20) NOT NULL,
 CONSTRAINT [PK_tbl_Gate] PRIMARY KEY CLUSTERED 
(
	[gate_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_Passenger]    Script Date: 14.12.2025. 14:47:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Passenger](
	[passenger_ID] [int] IDENTITY(1,1) NOT NULL,
	[f_name] [nvarchar](20) NOT NULL,
	[l_name] [nvarchar](20) NOT NULL,
	[passportNo] [nvarchar](20) NOT NULL,
	[UMCN] [nchar](13) NOT NULL,
	[email] [nvarchar](100) NOT NULL,
	[address] [nvarchar](30) NOT NULL,
	[contact] [nvarchar](20) NOT NULL,
	[username] [nvarchar](50) NOT NULL,
	[password] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_tbl_Passenger] PRIMARY KEY CLUSTERED 
(
	[passenger_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [IX_tbl_Passenger] UNIQUE NONCLUSTERED 
(
	[username] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [IX_tbl_Passenger_1] UNIQUE NONCLUSTERED 
(
	[email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_Payment]    Script Date: 14.12.2025. 14:47:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Payment](
	[payment_ID] [int] IDENTITY(1,1) NOT NULL,
	[amount] [decimal](5, 2) NOT NULL,
	[paymentDate] [datetime] NOT NULL,
	[paymentMethod] [nvarchar](50) NOT NULL,
	[status] [nvarchar](20) NOT NULL,
	[booking_ID] [int] NOT NULL,
 CONSTRAINT [PK_tbl_Payment] PRIMARY KEY CLUSTERED 
(
	[payment_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_SecurityCheck]    Script Date: 14.12.2025. 14:47:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_SecurityCheck](
	[security_ID] [int] IDENTITY(1,1) NOT NULL,
	[securityTime] [datetime] NOT NULL,
	[type] [nvarchar](20) NOT NULL,
	[status] [nvarchar](20) NOT NULL,
	[checkIn_ID] [int] NOT NULL,
	[staff_ID] [int] NOT NULL,
 CONSTRAINT [PK_tbl_SecurityCheck] PRIMARY KEY CLUSTERED 
(
	[security_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_Staff]    Script Date: 14.12.2025. 14:47:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Staff](
	[staff_ID] [int] IDENTITY(1,1) NOT NULL,
	[f_name] [nvarchar](30) NOT NULL,
	[l_name] [nvarchar](30) NOT NULL,
	[position] [nvarchar](30) NOT NULL,
	[salary] [decimal](10, 2) NOT NULL,
	[username] [nvarchar](50) NOT NULL,
	[password] [nvarchar](50) NOT NULL,
	[licenseNo] [nvarchar](20) NULL,
	[weaponPermit] [bit] NULL,
 CONSTRAINT [PK_tbl_Staff] PRIMARY KEY CLUSTERED 
(
	[staff_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [IX_tbl_Staff] UNIQUE NONCLUSTERED 
(
	[username] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_Ticket]    Script Date: 14.12.2025. 14:47:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Ticket](
	[ticket_ID] [int] IDENTITY(1,1) NOT NULL,
	[seatNo] [nvarchar](10) NULL,
	[class] [nvarchar](10) NOT NULL,
	[price] [decimal](5, 2) NOT NULL,
	[booking_ID] [int] NOT NULL,
	[flight_ID] [int] NOT NULL,
 CONSTRAINT [PK_tbl_Ticket] PRIMARY KEY CLUSTERED 
(
	[ticket_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_Baggage]  WITH CHECK ADD  CONSTRAINT [FK_tbl_Baggage_tbl_CheckIn] FOREIGN KEY([checkIn_ID])
REFERENCES [dbo].[tbl_CheckIn] ([checkIn_ID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[tbl_Baggage] CHECK CONSTRAINT [FK_tbl_Baggage_tbl_CheckIn]
GO
ALTER TABLE [dbo].[tbl_Booking]  WITH CHECK ADD  CONSTRAINT [FK_Booking_Passenger] FOREIGN KEY([passenger_ID])
REFERENCES [dbo].[tbl_Passenger] ([passenger_ID])
GO
ALTER TABLE [dbo].[tbl_Booking] CHECK CONSTRAINT [FK_Booking_Passenger]
GO
ALTER TABLE [dbo].[tbl_CheckIn]  WITH CHECK ADD  CONSTRAINT [FK_tbl_CheckIn_tbl_Ticket] FOREIGN KEY([ticket_ID])
REFERENCES [dbo].[tbl_Ticket] ([ticket_ID])
GO
ALTER TABLE [dbo].[tbl_CheckIn] CHECK CONSTRAINT [FK_tbl_CheckIn_tbl_Ticket]
GO
ALTER TABLE [dbo].[tbl_Flight]  WITH CHECK ADD  CONSTRAINT [FK_tbl_Flight_tbl_Gate] FOREIGN KEY([gate_ID])
REFERENCES [dbo].[tbl_Gate] ([gate_ID])
GO
ALTER TABLE [dbo].[tbl_Flight] CHECK CONSTRAINT [FK_tbl_Flight_tbl_Gate]
GO
ALTER TABLE [dbo].[tbl_Flight]  WITH CHECK ADD  CONSTRAINT [FK_tbl_Flight_tbl_Staff] FOREIGN KEY([airlineStaff_ID])
REFERENCES [dbo].[tbl_Staff] ([staff_ID])
GO
ALTER TABLE [dbo].[tbl_Flight] CHECK CONSTRAINT [FK_tbl_Flight_tbl_Staff]
GO
ALTER TABLE [dbo].[tbl_Payment]  WITH CHECK ADD  CONSTRAINT [FK_tbl_Payment_tbl_Booking] FOREIGN KEY([booking_ID])
REFERENCES [dbo].[tbl_Booking] ([booking_ID])
GO
ALTER TABLE [dbo].[tbl_Payment] CHECK CONSTRAINT [FK_tbl_Payment_tbl_Booking]
GO
ALTER TABLE [dbo].[tbl_SecurityCheck]  WITH CHECK ADD  CONSTRAINT [FK_tbl_SecurityCheck_tbl_CheckIn] FOREIGN KEY([staff_ID])
REFERENCES [dbo].[tbl_Staff] ([staff_ID])
GO
ALTER TABLE [dbo].[tbl_SecurityCheck] CHECK CONSTRAINT [FK_tbl_SecurityCheck_tbl_CheckIn]
GO
ALTER TABLE [dbo].[tbl_Ticket]  WITH CHECK ADD  CONSTRAINT [FK_tbl_Ticket_tbl_Booking] FOREIGN KEY([booking_ID])
REFERENCES [dbo].[tbl_Booking] ([booking_ID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[tbl_Ticket] CHECK CONSTRAINT [FK_tbl_Ticket_tbl_Booking]
GO
ALTER TABLE [dbo].[tbl_Ticket]  WITH CHECK ADD  CONSTRAINT [FK_tbl_Ticket_tbl_Flight] FOREIGN KEY([flight_ID])
REFERENCES [dbo].[tbl_Flight] ([flight_ID])
GO
ALTER TABLE [dbo].[tbl_Ticket] CHECK CONSTRAINT [FK_tbl_Ticket_tbl_Flight]
GO
USE [master]
GO
ALTER DATABASE [AirportSystem] SET  READ_WRITE 
GO