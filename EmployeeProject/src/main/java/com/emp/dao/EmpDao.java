package com.emp.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

import org.mindrot.jbcrypt.BCrypt;

import com.emp.entities.Attendance;
import com.emp.entities.Employees;
import com.emp.entities.Holidays;
import com.emp.entities.Leaves;

public class EmpDao {

	private Connection con;

	public EmpDao(Connection con) {
		this.con = con;
	}


	// Checking username and password
	public boolean validateLogin(String uname,String pwd)throws SQLException
	{
		String query = "SELECT * FROM User_credentials WHERE binary username = ?";
		PreparedStatement ps = con.prepareStatement(query);
		ps.setString(1, uname);

		ResultSet rs = ps.executeQuery();
		rs.next();

		String pswd= rs.getString("password");

		if(BCrypt.checkpw(pwd, pswd)) {
//			System.out.println("validateLogin returned true");
			return true;
		}
//		System.out.println("validateLogin returned false");
		return  false;
	}



	/// Getting employee Details based on username
	public Employees getEmpData(String uname) throws SQLException
	{
		Employees e1=new Employees();
		String qry ="select * from Employees where EmployeeID = (select EmployeeID from User_credentials where username =?)";
		PreparedStatement ps = con.prepareStatement(qry);
		ps.setString(1, uname);
		try {
			ResultSet rs = ps.executeQuery();
			rs.next();
			e1.setEmpId(rs.getInt("EmployeeID"));
			e1.setFname(rs.getString("FirstName"));
			e1.setLname(rs.getString("LastName"));
			e1.setDOB(rs.getString("DateOfBirth"));
			e1.setEmail(rs.getString("Email"));
			e1.setPhoneNo(rs.getString("Phone"));
			e1.setAddress(rs.getString("Address"));
			e1.setHiredate(rs.getString("Hiredate"));
			e1.setRoleId(rs.getInt("RoleID"));
		}catch(Exception e)
		{
			e.printStackTrace();
		}
		return e1;
	}


	//Getting difference of check-in and check-out of weekly attendance based on employee id..
	public List<Attendance> getAttendanceForDashBoard(int empid) throws SQLException
	{
		List<Attendance> list = new ArrayList<>();
		String qry="WITH RECURSIVE date_series AS ("
				+ "SELECT DATE(DATE_SUB(CURDATE(), INTERVAL WEEKDAY(CURDATE()) DAY)) AS date "
				+ "UNION ALL "
				+ "SELECT DATE_ADD(date, INTERVAL 1 DAY) "
				+ "FROM date_series "
				+ "WHERE date < DATE_ADD(DATE(DATE_SUB(CURDATE(), INTERVAL WEEKDAY(CURDATE()) DAY)), INTERVAL 6 DAY) "
				+ ") "
				+ "SELECT "
				+ "COALESCE(IFNULL(TIME_TO_SEC(TIMEDIFF(a.CheckOutTime, a.CheckInTime)) / 3600.0, 0), 0) AS duration "
				+ "FROM "
				+ "date_series d "
				+ "LEFT JOIN "
				+ "attendance a ON d.date = a.Date AND a.employeeid = ? "
				+ "ORDER BY "
				+ "d.date";
		PreparedStatement ps = con.prepareStatement(qry);
		ps.setInt(1, empid);
		ResultSet rs = ps.executeQuery();
		while(rs.next())
		{
			Attendance att = new Attendance();
			if(rs.getString("duration") == null) {
				att.setDuration("0.0");
			}else
			{
				att.setDuration(rs.getString("duration"));
			}

			list.add(att);
		}
		return list;
	}


	/// Getting current week's time logs..
	public Attendance getCheckInCheckOutTime(int empid) throws SQLException
	{
		Attendance att = new Attendance();
		String qry = "SELECT CheckInTime, CheckOutTime "
				+ "FROM Attendance "
				+ "WHERE EmployeeId = ? "
				+ "AND Date = CURDATE()";

		PreparedStatement ps = con.prepareStatement(qry);
		ps.setInt(1, empid);
		ResultSet rs = ps.executeQuery();

		while(rs.next())
		{
			att.setCheckin(rs.getString("checkintime"));
			att.setCheckout(rs.getString("checkouttime"));
			return att;
		}

		return att;
	}


	///  validating user password
	public boolean validateUserPassword(String uname,String pwd)throws SQLException
	{
		String query = "SELECT Password FROM User_credentials where username = ?";
		PreparedStatement ps = con.prepareStatement(query);
		ps.setString(1, uname);

		try {
			ResultSet rs = ps.executeQuery();
			rs.next();

			String pswd= rs.getString("password"); 
			//	         int id = rs.getInt("EmployeeID");

			if(BCrypt.checkpw(pwd, pswd)) {
				return true;
			}


		}catch(Exception e)
		{
			e.printStackTrace();
		}
		return  false;
	}



	/// updating user's password with session id
	public void updatePwd(int id,String pwd)
	{

		try {
			String qry="update user_credentials set password=? where employeeid =?";
			PreparedStatement ps=con.prepareStatement(qry);
			ps.setString(1,pwd);
			ps.setInt(2, id);

			int i=ps.executeUpdate();
			if(i>0)
			{
				System.out.println("password updated!!!");
			}
		}catch(Exception e)
		{
			e.printStackTrace();
		}

	}

	//Getting current month leaves based on employee id
	public List<Leaves> getCurrMonthLeaves(int empid) throws SQLException
	{
		List<Leaves> list = new ArrayList<>();
		String qry = "SELECT startdate,enddate,leavestatus "
				+ "FROM leaves "
				+ "WHERE MONTH(StartDate) = MONTH(CURRENT_DATE()) "
				+ "AND YEAR(StartDate) = YEAR(CURRENT_DATE()) "
				+ "AND EmployeeID = ?";
		PreparedStatement ps = con.prepareStatement(qry);
		ps.setInt(1, empid);
		ResultSet rs = ps.executeQuery();
		while(rs.next())
		{
			Leaves leave = new Leaves();
			leave.setFromDate(rs.getString("startdate"));
			leave.setToDate(rs.getString("enddate"));
			leave.setLeaveStatus(rs.getString("leavestatus"));
			list.add(leave);
		}
		return list;
	}

	//Storing all holidays into a list
	public List<Holidays> getHolidays() throws SQLException
	{
		List<Holidays> list = new ArrayList<>();
		String qry = "select holidaydate from holidays";
		Statement st = con.createStatement();
		ResultSet rs = st.executeQuery(qry);
		while(rs.next())
		{
			Holidays holi = new Holidays();
			holi.setDate(rs.getString("holidaydate"));
			list.add(holi);
		}
		return list;
	}

	//To get available leaves based employee id
	public int getAvailableLeaves(int eid) throws SQLException
	{
		String qry="select availableLeaves from LeavesStock where employeeid=?";
		PreparedStatement ps = con.prepareStatement(qry);
		ps.setInt(1, eid);
		ResultSet rs = ps.executeQuery();
		if(rs.next()) {
			int n =rs.getInt("AvailableLeaves");
			return n;
		}
		return 0;
	}


	public int validateLeaves(String date,String date2) throws SQLException
	{
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
		LocalDate fromdate = LocalDate.parse(date,formatter);
		LocalDate todate = LocalDate.parse(date2,formatter);
		int cnt =0;
		for(LocalDate d=fromdate;!d.isAfter(todate);d=d.plusDays(1))
		{
			DayOfWeek dw = d.getDayOfWeek();

			if(checkHoliday(d.format(formatter)))
			{
				if(dw != DayOfWeek.SATURDAY && dw != DayOfWeek.SUNDAY)
				{
					cnt++;	
				}
			}

		}
		return cnt;

	}



	public boolean checkHoliday(String date) throws SQLException
	{	
		System.out.println("Checking Holiday");
		String qry="select holidayDate from holidays where holidayDate = ?";
		PreparedStatement ps = con.prepareStatement(qry);
		ps.setString(1, date);
		ResultSet rs = ps.executeQuery();
		if(rs.next())
		{
			return false;
		}

		return true;
	}


	// Method to insert leaves into table
	public int insertLeave(Leaves leave)
	{
		int leaveid =0;
		String query = "INSERT INTO Leaves (EmployeeID, LeaveType, StartDate, EndDate, LeaveStatus, reason,TotalDays,AppliedDate) VALUES (?, ?, ?, ?, ?, ?, ?,curdate())";
		String qry2="SELECT LeaveId FROM Leaves ORDER BY LeaveId DESC LIMIT 1";

		try (PreparedStatement pst = con.prepareStatement(query)) {
			pst.setInt(1, leave.getEmployeeID());
			pst.setString(2, leave.getLeaveType());
			pst.setString(3, leave.getFromDate());
			pst.setString(4, leave.getToDate());
			pst.setString(5, leave.getLeaveStatus());
			pst.setString(6, leave.getAppliedReason());
			pst.setInt(7, leave.getTotalDays());

			int rowCount = pst.executeUpdate();
			if (rowCount > 0) {
				ResultSet rs= con.prepareStatement(qry2).executeQuery();
				rs.next();
				leaveid=rs.getInt("LeaveId");

			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return leaveid;
	}


	// after inserting leaves updating the available leaves
	public boolean updateLeavestock(int leaveid) throws SQLException
	{
		boolean flag=false;
		String qry="select employeeid,leavestatus,totaldays from leaves where leaveid=?";
		String qry1="update leavesStock set availableleaves = availableleaves - ?,consumedleaves = consumedleaves + ? where employeeid=?";
		String qry2="update leavesStock set availableleaves = availableleaves + ?,consumedleaves = consumedleaves - ? where employeeid=?";
		PreparedStatement ps=con.prepareStatement(qry);
		ps.setInt(1, leaveid);
		ResultSet rs = ps.executeQuery();
		rs.next();
		int empid = rs.getInt("employeeid");
		String status = rs.getString("leavestatus");
		int totaldays = rs.getInt("totaldays");

		if(status.equals("Pending")||status.equals("Approved"))
		{
			PreparedStatement ps1=con.prepareStatement(qry1);
			ps1.setInt(1, totaldays);
			ps1.setInt(2, totaldays);
			ps1.setInt(3, empid);
			ps1.executeUpdate();
			flag = true;
		}
		else
		{
			PreparedStatement ps2=con.prepareStatement(qry2);
			ps2.setInt(1, totaldays);
			ps2.setInt(2, totaldays);
			ps2.setInt(3, empid);
			ps2.executeUpdate();
			flag = true;
		}


		return flag;
	}	


	/// Getting all employees records except HR
	public List<Employees> getEmployees() throws Exception {
		List<Employees> list = new ArrayList<>();
		String qry = "SELECT EmployeeID, FirstName, LastName " +
				"FROM Employees";
		PreparedStatement ps = con.prepareStatement(qry);
		ResultSet rs = ps.executeQuery();
		while (rs.next()) {
			Employees r = new Employees();
			r.setEmpId(rs.getInt("EmployeeId"));
			r.setFname(rs.getString("FirstName"));
			r.setLname(rs.getString("LastName"));
			list.add(r);
		}
		return list;
	}


	public List<Leaves> getEmployeeLeaves(int empid) throws SQLException
	{
		List<Leaves> list = new ArrayList<>();

		String qry="select * from leaves where employeeid=?";
		PreparedStatement ps = con.prepareStatement(qry);
		ps.setInt(1, empid);
		ResultSet rs = ps.executeQuery();
		while(rs.next())
		{
			Leaves lev = new Leaves();
			lev.setLeaveId(rs.getInt("leaveid"));
			lev.setEmployeeID(rs.getInt("employeeid"));
			lev.setFromDate(rs.getString("startdate"));
			lev.setToDate(rs.getString("enddate"));
			lev.setTotalDays(rs.getInt("totaldays"));
			lev.setLeaveType(rs.getString("leavetype"));
			lev.setLeaveStatus(rs.getString("leavestatus"));
			list.add(lev);
		}
		return list;
	}


	//Method to get holiday records
	public List<Holidays> getAllHolidays () throws SQLException
	{
		List<Holidays> list = new ArrayList<>();
		String query = "SELECT * FROM holidays WHERE Year(holidayDate) = Year(CURRENT_DATE()) order by HolidayDate";
		Statement st = con.createStatement();
		ResultSet rs = st.executeQuery(query);
		while (rs.next()) {

			Holidays ad = new Holidays();

			ad.setId(rs.getInt("holidayid"));
			ad.setDate(rs.getString("holidayDate"));
			ad.setName(rs.getString("holidayName"));

			list.add(ad);

		}
		return list;
	}
	
	//Method to insert Holidays
	public boolean insertHoliday(String date,String name) throws SQLException
	{
		String qry = "insert into holidays(holidaydate,holidayname) values (?,?)";
		PreparedStatement ps = con.prepareStatement(qry);
		ps.setString(1, date);
		ps.setString(2, name);
		int i = ps.executeUpdate();
		if(i>0)
		{
			return true;
		}else
		{
			return false;
		}
		
	}
	
	//Method to delete holiday
	public boolean deleteHolidayRecord(int lid) throws SQLException
	{
		String qry="delete from holidays where holidayid=?";
		PreparedStatement ps = con.prepareStatement(qry);
		ps.setInt(1, lid);
		int i = ps.executeUpdate();
		if(i>0)
		{
			return true;
		}else
		{
			return false;
		}
	}
	
	
	//Method to add leaves to employees
	public boolean addLeavesStock(int n) throws SQLException
	{
		String qry="update leavesStock set availableLeaves = availableLeaves+? ";
		PreparedStatement ps = con.prepareStatement(qry);
		ps.setInt(1,n);
		int i = ps.executeUpdate();
		if(i>0)
		{
			return true;
		}else
		{
			return false;
		}
	}
	
	//Method to delete leave record (Cancel Leave)
	public boolean deleteLeaveRecord(int lid) throws SQLException
	{
		
		String qry="UPDATE leavesStock ls "
				+ "JOIN Leaves l ON ls.employeeid = l.employeeid "
				+ "SET ls.availableleaves = ls.availableleaves + l.TotalDays, "
				+ "ls.consumedleaves = ls.consumedleaves - l.TotalDays "
				+ "WHERE l.leaveid = ?;";
		
		String qry2="delete from leaves where leaveid=?";
		
		PreparedStatement ps = con.prepareStatement(qry);
		ps.setInt(1, lid);
		ps.executeUpdate();
		
		PreparedStatement ps2=con.prepareStatement(qry2);
		ps2.setInt(1, lid);
		
		int i =ps2.executeUpdate();
		if(i>0)
		{
			return true;
		}else
		{
			return false;
		}
	}
	
	//Method to get the current user's role
	public String getRoleByLogin(String uname,String pwd)throws SQLException
	{
		String query = "SELECT u.EmployeeID, u.Password, e.RoleID, r.RoleName FROM User_credentials u JOIN Employees e ON u.EmployeeID = e.EmployeeID JOIN Roles r ON e.RoleID = r.RoleID WHERE binary u.Username = ?";
		PreparedStatement ps = con.prepareStatement(query);
		ps.setString(1, uname);

		try {
			ResultSet rs = ps.executeQuery();
			rs.next();

			String pswd= rs.getString("password");
			String role = rs.getString("RoleName"); 
			//	         int id = rs.getInt("EmployeeID");

			if(BCrypt.checkpw(pwd, pswd)) {
				return role;
			}


		}catch(Exception e)
		{
			e.printStackTrace();
		}
		return  "error";
	}
	
	//Method to get the reportees of a manager
	public List<Employees> getReportees(int mId) throws SQLException
	{
		List<Employees> l1 = new ArrayList<>();

		String qry=" SELECT e.EmployeeId, e.FirstName,e.LastName FROM Employees e JOIN Manager m ON e.EmployeeId = m.employee WHERE m.Manager = ?";
		PreparedStatement ps = con.prepareStatement(qry);
		ps.setInt(1, mId);
		ResultSet rs = ps.executeQuery();
		while(rs.next())
		{
			Employees e1  = new Employees();
			e1.setEmpId(rs.getInt("EmployeeID"));
			e1.setFname(rs.getString("FirstName"));
			e1.setLname(rs.getString("LastName"));

			l1.add(e1);
		}
		return l1;
	}
	
	
	//Method to filter leaves based on year and month
	public List<Leaves> getLeaveByYearMonth(int eid, String year, String month) {
		List<Leaves> list = new ArrayList<>();
		try {
			String query = "SELECT * FROM leaves WHERE EmployeeID= ? AND YEAR(StartDate) = ? AND MONTH(StartDate) = ?";
			PreparedStatement ps = this.con.prepareStatement(query);
			ps.setInt(1, eid);
			ps.setString(2, year);
			ps.setString(3, month);
			ResultSet rs = ps.executeQuery();
			while (rs.next()) {
				Leaves lev = new Leaves();
				lev.setFromDate(rs.getString("startDate"));
				lev.setToDate(rs.getString("endDate"));
				lev.setTotalDays(rs.getInt("TotalDays"));
				lev.setLeaveType(rs.getString("LeaveType"));
				lev.setLeaveStatus(rs.getString("LeaveStatus"));
				list.add(lev);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}
	
	//Method to filter leaves based on month
	public List<Leaves> getLeaveByYear(int eid, String year) {
		List<Leaves> list = new ArrayList<>();
		try {
			String query = "SELECT * FROM leaves WHERE EmployeeID = ? AND YEAR(StartDate) = ?";
			PreparedStatement ps = this.con.prepareStatement(query);
			ps.setInt(1, eid);
			ps.setString(2, year);
			ResultSet rs = ps.executeQuery();
			while (rs.next()) {
				Leaves lev = new Leaves();
				lev.setFromDate(rs.getString("startDate"));
				lev.setToDate(rs.getString("endDate"));
				lev.setTotalDays(rs.getInt("TotalDays"));
				lev.setLeaveType(rs.getString("LeaveType"));
				lev.setLeaveStatus(rs.getString("LeaveStatus"));
				list.add(lev);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}
	
	
	//Method to check user name 
	public boolean validateEmail(String uname,String email) throws SQLException
	{
		String qry="select email from employees where employeeid =(select employeeid from user_credentials where username=?)";
		PreparedStatement ps = con.prepareStatement(qry);
		ps.setString(1, uname);
		ResultSet rs = ps.executeQuery();
		rs.next();
		if(email.equals(rs.getString("email")))
		{
			return true;
		
		}
		return false;
	}
	
	
	//Method to reset password through login page
	public boolean changePassword(String pwd, String uname) throws SQLException {
	    String qry = "update user_credentials set password=? where username=?";
	    PreparedStatement ps = con.prepareStatement(qry);
	    ps.setString(1, pwd);
	    ps.setString(2, uname);
	    int i = ps.executeUpdate();
	    if (i > 0) {
	        return true;
	    }
	    return false;
	}
	
	
	// Method to get all employees pending leaves
	public List<Leaves> getPendingLeaves() throws SQLException
	{
		List<Leaves> list = new ArrayList<>();
		String qry="SELECT l.leaveid,l.startdate, l.enddate, l.totaldays, l.leavetype, l.reason,l.leavestatus, e.firstname, e.lastname FROM leaves l JOIN employees e ON l.employeeid = e.EmployeeID WHERE l.leaveStatus = 'pending'";
		Statement st = con.createStatement();
		ResultSet rs = st.executeQuery(qry);
		while(rs.next())
		{
			Leaves l = new Leaves();
			l.setLeaveId(rs.getInt("leaveid"));
			l.setFromDate(rs.getString("startdate"));
			l.setToDate(rs.getString("enddate"));
			l.setTotalDays(rs.getInt("totaldays"));
			l.setLeaveType(rs.getString("leavetype"));
			l.setLeaveStatus(rs.getString("leavestatus"));
			l.setAppliedReason(rs.getString("reason"));
			l.setFname(rs.getString("firstname"));
			l.setLname(rs.getString("lastname"));
			list.add(l);
		}
		return list;
	}
	
	
	// Method to get all employee leaves reporting to their manager
	public List<Leaves> getMgrPendingLeaves(int mid) throws SQLException
	{
		List<Leaves> list = new ArrayList<>();
		String qry="SELECT l.leaveid,l.startdate,l.enddate,l.totaldays,l.leavetype,l.reason,l.leavestatus, e.firstname, e.lastname FROM Leaves l JOIN Manager m ON l.employeeid = m.employee JOIN Employees e ON l.employeeid = e.employeeid WHERE m.manager = ? AND l.leaveStatus = 'pending'";
		PreparedStatement ps = con.prepareStatement(qry);
		 ps.setInt(1, mid);
		 ResultSet rs = ps.executeQuery();
		while(rs.next())
		{
			Leaves l = new Leaves();
			l.setLeaveId(rs.getInt("leaveid"));
			l.setFromDate(rs.getString("startdate"));
			l.setToDate(rs.getString("enddate"));
			l.setTotalDays(rs.getInt("totaldays"));
			l.setLeaveType(rs.getString("leavetype"));
			l.setLeaveStatus(rs.getString("leavestatus"));
			l.setAppliedReason(rs.getString("reason"));
			l.setFname(rs.getString("firstname"));
			l.setLname(rs.getString("lastname"));
			list.add(l);
		}
		return list;
	}
	
	
	// Method to get current date and time
	public String getCurrDateTime() {
		// Get current date and time in IST
		ZoneId istZone = ZoneId.of("Asia/Kolkata"); // Replace with "Asia/Calcutta" if needed
		ZonedDateTime nowIST = ZonedDateTime.now(istZone);

		// Format date and time with desired pattern
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss") ;


		String dateTime = nowIST.format(formatter);

//		System.out.println("Current date" + dateTime);
		return dateTime;
	}
	
	
	// Method to update reject reason
	public boolean updaterejectreason(String rs,int eid,int leaveid,String status) throws SQLException
	{
		String[] str = getCurrDateTime().split(" ");
		String qry="update leaves set rejectreason =?,leavestatus=?,approveddate=?,approvedby=? where leaveid=?";
		PreparedStatement ps = con.prepareStatement(qry);
		ps.setString(1,rs);
		ps.setString(2, status);
		ps.setString(3, str[0]);
		ps.setInt(4, eid);
		ps.setInt(5, leaveid);
		int i = ps.executeUpdate();
		if(i>0)
		{
			return true;
		}else
		{
			return false;
		}
	}

}
