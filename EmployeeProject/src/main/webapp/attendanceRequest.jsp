<%@page import="org.apache.taglibs.standard.tag.common.xml.ForEachTag"%>
<%@page import="org.apache.jasper.tagplugins.jstl.core.ForEach"%>
<%@ page import="java.util.List"%>
<%@ page import="com.emp.entities.Attendance"%>
<%@ page import="com.emp.entities.Employees"%>
<%@ page import="com.emp.entities.Leaves"%>
<%@ page import="com.emp.jdbc.DBConnect"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="com.emp.dao.EmpDao"%>

<%@ page import="java.time.LocalTime"%>
<%@ page import="java.time.Duration"%>

<%@ page import="java.time.LocalDate"%>
<%@ page import="java.time.format.DateTimeFormatter"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Employee Management</title>

<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<script src="script.js" defer></script>
</head>
<style>


body {
	font-family: Arial, sans-serif;
	margin: 0;
    padding: 0;
	display: flex;
	transition: padding-left 0.3s ease;
	background-color: #f5f5f5;
	box-sizing: border-box;
}

.sidebar {
	width: 250px;
	background-color: white;
	height: 100vh;
	position: fixed;
	left: 0;
	top: 0;
	transition: all 0.3s ease;
	overflow-x: hidden;
	z-index: 1000;
	box-shadow: 2px 0 5px rgba(0, 0, 0, 0.1);
	border-radius: 0 20px 20px 0;
}

.sidebar.collapsed {
	width: 60px;
}

.logo {
	padding: 20px;
	border-bottom: 1px solid #e0e0e0;
}

.logo img {
	max-width: 100%;
	height: auto;
}

.sidebar-menu {
	list-style-type: none;
	padding: 0;
	margin: 0;
}

.sidebar-menu li {
	padding: 15px 20px;
	transition: all 0.3s ease;
	white-space: nowrap;
}

.sidebar-menu li:hover {
	background-color: #f0f0f0;
}

.sidebar-menu li.active {
	background-color: #ff8c00;
	color: white;
}

.sidebar-menu i {
	margin-right: 10px;
}

.sidebar.collapsed .menu-text {
	display: none;
}

.sidebar.collapsed .sidebar-menu li {
	text-align: center;
}

.toggle-btn {
	position: fixed;
	left: 230px;
	top: 10px;
	background: linear-gradient(to left,#FF9671 ,#FFC75F );
	
	border:none;
	border-radius: 30px;
	padding: 10px;
	cursor: pointer;
	transition: all 0.3s ease;
	z-index: 1001;
	box-shadow: 2px 0 5px rgba(0, 0, 0, 0.1);
}

.toggle-btn i {
	display: none;
}

.toggle-btn i.show {
	display: inline;
}

.sidebar.collapsed+.toggle-btn {
	left: 40px;
}

.main-content {
	flex: 1;
	padding: 20px;
	margin-left: 230px;
	transition: margin-left 0.3s ease;
}

.header {
	
	background: linear-gradient(to left,#FF9671 ,#FFC75F );
	color: white;
	padding: 10px 20px;
	display: flex;
	justify-content: space-between;
	align-items: center;
	position: fixed;
    top: 0;
    right: 0;
    left: 230px;
    height: 60px;
    transition: left 0.3s ease;
    z-index: 999;

}

body.sidebar-collapsed .main-content {
    margin-left: 40px;
}

body.sidebar-collapsed .header {
    left: 40px;
}

.dashboard-grid {
	display: grid;
	grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
	gap: 20px;
	margin-top: 80px;
	padding:20px;
}

.dashboard-item {
	background-color: #fff;
	border-radius: 30px;
	box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
	padding: 15px;
}

.user-profile {
	position: relative;
}

.user-dropdown {
	display: inline-block;
}


.dropbtn {
	background:linear-gradient(to left,#FFC75F ,#FF9671 );
	color: white;
	padding: 10px 15px;
	font-size: 16px;
	border: none;
	cursor: pointer;
	border-radius: 5px;
	transition: background-color 0.3s;
	box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
}

.dropbtn:hover, .dropbtn:focus {
	background-color: #e67e00;
}

.dropdown-content {
	display: none;
	position: absolute;
	right: 0;
	background-color: #f9f9f9;
	min-width: 160px;
	box-shadow: 0px 8px 16px 0px rgba(0, 0, 0, 0.2);
	z-index: 1001;
	border-radius: 5px;
}

.dropdown-content a {
	color: black;
	padding: 12px 16px;
	text-decoration: none;
	display: block;
}

.dropdown-content a:hover {
	background-color: #f1f1f1;
}

.show {
	display: block !important;
}

.time-at-work {
	padding: 20px;
}

.punch-status {
	display: flex;
	align-items: center;
	margin-bottom: 15px;
}

.time-today {
	background-color: #f0f0f0;
	padding: 10px;
	border-radius: 5px;
	margin-bottom: 15px;
}

.time-today .hours {
	font-weight: bold;
}



.weekly-chart h4 {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-bottom: 10px;
}

.chart-container {
	height: 150px;
	display: flex;
	align-items: flex-end;
	justify-content: space-between;
	margin-bottom: 10px;
}

.chart-bar-wrapper {
    
    
}

.chart-bar {
	width: 12%;
	background: linear-gradient(to left,#FF9671 ,#FFC75F );
	transition: height 0.3s ease;
	border-radius:15px 15px 0 0;
	position: relative;
	display: flex;
    justify-content: center;
    align-items: flex-end;
    padding-bottom: 5px;

}

.hour-value {
    color: white;
    font-size: 0.8em;
    font-weight: bold;

    
}

.chart-labels {
	display: flex;
	justify-content: space-between;
	font-size: 0.8em;
	color: #666;
}

@media screen and (max-width: 768px) {
	body {
		flex-direction: column;
	}
	.sidebar {
		width: 100%;
		height: auto;
	}
	.main-content {
		margin-left: 0;
	}
	.toggle-btn {
		display: none;
	}
		.user-dropdown {
		display: block;
		width: 100%;
	}
	.dropdown-content {
		width: 100%;
	}
}


body.sidebar-collapsed {
	padding-left: 60px;
}

body.sidebar-collapsed .main-content {
	margin-left: 0px;
}
a {
    text-decoration: none;
    color:black;
}

h1
{
margin:30px;
}



/* below css for My Leaves card  */
.leave-entry {
	background-color: #f0f0f0;
	border-radius: 6px;
	padding: 15px;
	margin-bottom: 10px;
}

.leave-row {
	display: flex;
	justify-content: space-between;
	margin-bottom: 5px;
}

.leave-label {
	font-weight: bold;
	color: #333;
}

.leave-value {
	text-align: right;
	color: #666;
}

.status-approved {
	color: #4caf50;
}

.status-rejected {
	color: #f44336;
}


.sidebar-menu li.active {
  background-color: red; /* Adjust color as desired */
}

/*CSS for Quick Launch*/

.quick-launch-grid {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 15px;
}

.quick-launch-button {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    background-color: #f5f5f5;
    border-radius: 8px;
    padding: 15px;
    text-align: center;
    transition: background-color 0.3s ease;
}

.quick-launch-button:hover {
    background-color: #e0e0e0;
}

.quick-launch-icon {
    width: 40px;
    height: 40px;
    background-color: #ddd;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    margin-bottom: 8px;
}

.quick-launch-icon i {
    color: #666;
    font-size: 20px;
}

.quick-launch-text {
    font-size: 12px;
    color: #333;
}


/*====================================table starts========================================*/

.leave-table {
  width: 100%;
  border-collapse: separate;
  border-spacing: 0 15px;
  
}


.leave-table th {
  text-align: left;
  padding: 10px 15px;
  color: black;
  font-weight: normal;
  border-bottom: 1px solid #e0e0e0;
  background-color:#c0c0c0;
  font-weight:bold;

  
}

.leave-table td {
  padding: 15px;
  background-color: #f5f5f5;
}

.leave-table tbody tr {
  box-shadow: 0 2px 5px rgba(0, 0, 0, 0.05);
  border-radius: 20px;
}

.leave-table tbody tr td:first-child {
  border-top-left-radius: 20px;
  border-bottom-left-radius: 20px;
}

.leave-table tbody tr td:last-child {
  border-top-right-radius: 20px;
  border-bottom-right-radius: 20px;
}


/*==============================table css ends=================================================*/

/*========================================poup css starts==================================*/

.popup {
	display: none;
	position: fixed;
	z-index: 9;
	left: 50%;
	top: 50%;
	transform: translate(-50%, -50%);
	border: 1px solid #888;
	border-radius: 8px;
	background-color: #fefefe;
	padding: 20px;
	box-shadow: 0 5px 15px rgba(0, 0, 0, 0.3);
	width: 400px;
	text-align: center;
}

.close-btn {
	color: #aaa;
	float: right;
	font-size: 28px;
	font-weight: bold;
}

.close-btn:hover, .close-btn:focus {
	color: black;
	text-decoration: none;
	cursor: pointer;
}

.popup h2 {
	color: #333;
	margin: 10px;
}

.popup textarea {
	width: 95%;
	padding: 10px;
	border: 1px solid #ddd;
	border-radius: 4px;
	font-size: 14px;
}

.popup input.sub {
	width: 50%;
	padding: 10px;
	margin-top: 20px;
	background-color: #007bff;
	color: white;
	border: none;
	border-radius: 4px;
	cursor: pointer;
	font-size: 16px;
	transition: background-color 0.3s ease;
}

.popup input.sub:hover {
	background-color: #0056b3;
}

.warning {
	margin: 10px;
}

.msg {
	margin: 15px;
}

/* Styling for form container */
.PopupForm {
	max-width: 400px;
	margin: 0 auto;
	padding: 20px;
	background-color: #ffffff;
	border-radius: 8px;
	box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
}

/* Styling for form labels */
.PopupForm label {
	display: block;
	margin-bottom: 5px;
	color: #333333;
	font-weight: bold;
}

/* Styling for form inputs */
.PopupForm input[type="text"] {
	width: calc(100% - 20px);
	padding: 10px;
	margin-bottom: 10px;
	border: 1px solid #cccccc;
	border-radius: 4px;
	font-size: 14px;
}

/* Styling for submit button */
.PopupForm input[type="submit"] {
	width: 100%;
	padding: 10px;
	background-color: #007bff;
	color: #ffffff;
	border: none;
	border-radius: 4px;
	font-size: 16px;
	cursor: pointer;
	transition: background-color 0.3s ease;
}

.PopupForm input[type="submit"]:hover {
	background-color: #0056b3;
}

/* =============================================popup css ends======================================*/

/*=================attendance links starts================================================*/

.attendanceLinks {
	display: flex;
	background-color: white;
	padding: 15px;
	margin-top:5%;
	border-radius: 8px;
	box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
	
}
.attendanceLinks a {
	color: #6c757d;
	text-decoration: none;
	padding: 10px 15px;
	font-size: 14px;
	transition: all 0.3s ease;
	margin: 0 5px;
	border-radius: 10px;
	background-color: #f5f5f5;
	box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
}

.attendanceLinks a:hover, .attendanceLinks a:focus {
	color: #ff8c00;
	background-color: #fff9f0;
	box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
	transform: translateY(-2px);
}

/* attendance links ends========================================================================*/


</style>

<script >




</script>

<body>
	<%
        Connection con = DBConnect.getConnection();
        EmpDao empDao = new EmpDao(con);
        
        HttpSession sess = request.getSession();
        Employees emp = (Employees)sess.getAttribute("employee");
        String role = (String)sess.getAttribute("role");
        
    	DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
    	List<Attendance> attendanceList = (List<Attendance>) request.getAttribute("filteredAttendance");
    	String empName = emp.getFname() + " " + emp.getLname();
    	
       // if(sess.getAttribute("role").equals("HR"))
       // {
       //  list2 = empDao.getPendingLeaves();
       // }else if(sess.getAttribute("role").equals("Manager"))
       // {
       // list2 = empDao.getMgrPendingLeaves(emp.getEmpId());
       // }
        
    %>

	<div class="sidebar" id="sidebar">
    <div class="logo">
        
    </div>
    <ul class="sidebar-menu">
        <li><a href="dashboard.jsp" id="dashboard-link"><i class="fas fa-tachometer-alt"></i><span class="menu-text"> Dashboard</span></a></li>
        <li><a href="admin.jsp" id="admin-link"><i class="fas fa-user-cog"></i><span class="menu-text"> Admin</span></a></li>
        <li><a href="pim.jsp" id="pim-link"><i class="fas fa-users"></i><span class="menu-text"> PIM</span></a></li>
        <li><a href="applyLeave.jsp" id="leave-link"><i class="fas fa-calendar-alt"></i><span class="menu-text"> Leave</span></a></li>
        <li><a href="attendance.jsp" id="time-link"><i class="fas fa-clock"></i><span class="menu-text">Time Logs</span></a></li>
        <li><a href="recruitment.jsp" id="recruitment-link"><i class="fas fa-user-plus"></i><span class="menu-text"> Recruitment</span></a></li>
        <li><a href="myinfo.jsp" id="myinfo-link"><i class="fas fa-id-badge"></i><span class="menu-text"> My Info</span></a></li>
    </ul>
</div>


	<button id="toggleSidebar" class="toggle-btn">
		<i class="fas fa-chevron-left show"></i> <i
			class="fas fa-chevron-right"></i>
	</button>

	<div class="main-content">
		<header class="header">
			<h1>Attendace</h1>
			<div class="user-profile">
				<div class="user-dropdown">
					<button class="dropbtn" id="userDropdown">
						<%= emp.getFname() + " " + emp.getLname() %>
						<i class="fas fa-caret-down"></i>
					</button>
					<div class="dropdown-content" id="userDropdownContent">
						<a href="changePassword.jsp">Change Password</a> <a
							href="logoutServlet">Logout</a>
					</div>
				</div>
			</div>
		</header>
		
		<div class="attendanceLinks">
			<a href="attendance.jsp">Attendance Records List</a> 
			<a href="attendanceRequest.jsp">Attendance Update Requests</a> 
		</div>

		<div class="dashboard-grid">
		
		
		<table class="leave-table">
						<thead>
							<tr>
								<th>Name</th>
                <th>Date</th>
                <th>Old CheckIn Time</th>
                <th>New CheckIn Time</th>
                <th>Old CheckOut Time</th>
                <th>New CheckOut Time</th>
                <th>Action</th>
							</tr>
						</thead>
						<tbody>
							
							<% 
            EmpDao er = new EmpDao(DBConnect.getConnection());
            List<Attendance> list2=null;
            
            if(role.equals("Manager"))
            		list2=er.ManagerAttendance(emp.getEmpId());
            else
            	list2=er.HRAttendance();

            for (Attendance e : list2) {
            %>
            <tr>
                <td><%= e.getName() %></td>
                <td><%= e.getDate()%></td>
                <td><%= e.getCheckin()%></td>
                <td><%= e.getNewcheckin()%></td>
                <td><%= e.getCheckout()%></td>
                <td><%= e.getNewcheckout()%></td>
                <td>
                <form action="AttendanceUpdate" method="get">
                       		<input type="hidden" name="id" value="<%=e.getAttendId() %>">	
                       		<input type="hidden" name="Date" value="<%=e.getDate() %>">
                       		<input type="hidden" name="CIT" value="<%=e.getNewcheckin() %>">
                       		<input type="hidden" name="COT" value="<%=e.getNewcheckout() %>">
                            <input type="submit" value="Approve">
                </form>
                </td>
                
            </tr>
            <% } %>
							
						</tbody>
					</table>
					


		</div>
	</div>
	<script type="text/javascript">
	// Get the current page name from the URL (assuming filenames match)
	var currentPage = window.location.pathname.split("/").pop();

	// Remove the ".jsp" extension if present
	currentPage = currentPage.replace(".jsp", "");

	// Get all the menu links
	var menuLinks = document.querySelectorAll(".sidebar-menu li a");

	// Loop through each link and add/remove active class
	for (var i = 0; i < menuLinks.length; i++) {
	  var link = menuLinks[i];
	  var linkHref = link.getAttribute("href");
	  
	  if (linkHref === currentPage || linkHref.endsWith("/" + currentPage)) {
	    link.parentNode.classList.add("active");
	  } else {
	    link.parentNode.classList.remove("active");
	  }
	}
	</script>
</body>
</html>