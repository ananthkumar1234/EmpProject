<%@page import="org.apache.taglibs.standard.tag.common.xml.ForEachTag"%>
<%@page import="org.apache.jasper.tagplugins.jstl.core.ForEach"%>
<%@ page import="java.util.List"%>
<%@ page import="com.emp.entities.Attendance"%>
<%@ page import="com.emp.entities.Employees"%>
<%@ page import="com.emp.entities.Leaves"%>
<%@ page import="com.emp.jdbc.DBConnect"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="com.emp.dao.EmpDao"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Leave</title>

<link rel="stylesheet" href="style.css">
<script src="script.js"></script>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>

<style>
body {
	font-family: Arial, sans-serif;
	margin: 0;
	padding: 0;
	display: flex;
	transition: padding-left 0.3s ease;
	background-color: #f5f5f5;
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
	background: linear-gradient(to left, #FF9671, #FFC75F);
	border: none;
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
	margin-left: 250px;
	transition: margin-left 0.3s ease;
}

.header {
	background: linear-gradient(to left, #FF9671, #FFC75F);
	color: white;
	padding: 10px 20px;
	display: flex;
	justify-content: space-between;
	align-items: center;
}

.dashboard-grid {
	display: grid;
	grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
	gap: 20px;
	margin-top: 20px;
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
	background: linear-gradient(to left, #FFC75F, #FF9671);
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

.chart-bar {
	width: 12%;
	background-color: #ff8c00;
	transition: height 0.3s ease;
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
	.leaveLinks {
		flex-direction: row;
		padding: 0;
		margin: 0;
	}
}

body.sidebar-collapsed {
	padding-left: 60px;
}

body.sidebar-collapsed .main-content {
	margin-left: 60px;
}

a {
	text-decoration: none;
	color: black;
}

.leaveLinks {
	display: flex;
	background-color: white;
	padding: 15px;
	margin-bottom: 20px;
	border-radius: 8px;
	box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
}

.leaveLinks a {
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

.leaveLinks a:hover, .leaveLinks a:focus {
	color: #ff8c00;
	background-color: #fff9f0;
	box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
	transform: translateY(-2px);
}

/* table css starts*/
.table-container {
	background-color: #ffffff;
	border-radius: 8px;
	box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
	padding: 20px;
	max-width: 1200px;
	margin: 0 auto;
}

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
	background-color: #c0c0c0;
	font-weight: bold;
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

.cancel-btn {
	background-color: #fff3e0;
	color: #ff9800;
	border: none;
	padding: 6px 12px;
	border-radius: 20px;
	cursor: pointer;
	font-weight: bold;
}

@media ( max-width : 768px) {
	.leave-table {
		font-size: 14px;
	}
	.leave-table th, .leave-table td {
		padding: 10px 8px;
	}
	.cancel-btn {
		padding: 4px 8px;
		font-size: 12px;
	}
}
/* table css ends*/

/*======================================warning message starts==========================================*/
.warning-message {
	position: fixed;
	top: -200px; /* Move completely out of view */
	left: 50%;
	transform: translateX(-50%);
	background-color: rgba(220, 53, 69, 0.8); /* More transparency */
	color: white;
	padding: 15px 30px;
	border-radius: 12px;
	box-shadow: 0 6px 16px rgba(0, 0, 0, 0.2);
	/* Slightly stronger shadow for more depth */
	text-align: center;
	transition: all 0.5s cubic-bezier(0.68, -0.55, 0.27, 1.55);
	z-index: 1000;
	max-width: 90%;
	backdrop-filter: blur(10px); /* Stronger blur effect */
	display: flex;
	align-items: center;
	justify-content: center;
}

.success-message {
	position: fixed;
	top: -200px; /* Move completely out of view */
	left: 50%;
	transform: translateX(-50%);
	background-color: rgba(220, 53, 69, 0.8); /* More transparency */
	color: white;
	padding: 15px 30px;
	border-radius: 12px;
	box-shadow: 0 6px 16px rgba(0, 0, 0, 0.2);
	/* Slightly stronger shadow for more depth */
	text-align: center;
	transition: all 0.5s cubic-bezier(0.68, -0.55, 0.27, 1.55);
	z-index: 1000;
	max-width: 90%;
	backdrop-filter: blur(10px); /* Stronger blur effect */
	display: flex;
	align-items: center;
	justify-content: center;
}

.warning-message p, .success-message p {
	font-weight: bold;
	margin: 8px 0;
	font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
	/* More modern font */
}

.warning-message p:first-child, .success-message p:first-child {
	font-weight: bold;
	font-size: 20px;
	text-transform: uppercase;
	letter-spacing: 1px;
}

.warning-message i, .success-message i {
	font-size: 24px;
	margin-right: 10px;
	vertical-align: middle;
}

.warning-message.show, .success-message.show {
	top: 30px;
	animation: shake 0.82s cubic-bezier(.36, .07, .19, .97) both;
}

/*warning message ends*/
.filter {
	align-items: center;
	margin: 10px;
	padding: 10px;
}

form {
	display: flex;
	width: 100%;
	justify-content: start;
	align-items: center;
}

form .form-container {
	display: 1;
	align-items: center;
	margin-right: 15px;
	gap: 10px;
}

.filter label {
	white-space: nowrap;
}

.filter input[type="text"], .filter select {
	width: 120px;
	padding: 8px;
	border: 1px solid #ddd;
	border-radius: 4px;
	box-sizing: border-box;
}

form .form-button {
	margin-left: 50%;
}

.apply-btn {
	background-color: #8bc34a;
	color: white;
	border: none;
	padding: 10px 20px;
	border-radius: 4px;
	cursor: pointer;
	font-size: 1em;
	white-space: nowrap;
}

.apply-btn:hover {
	background-color: #7cb342;
}
</style>

<script>
	function toggleMonthDropdown() {
		var yearInput = document.getElementById('year');
		var monthDropdown = document.getElementById('month');
		monthDropdown.disabled = yearInput.value.trim() === "";
	}
	window.onload = function() {
		toggleMonthDropdown(); // Initial check
	}
</script>

<body>

	<%
	Connection con = DBConnect.getConnection();
	EmpDao empDao = new EmpDao(con);

	HttpSession sess = request.getSession();
	Employees emp = (Employees) sess.getAttribute("employee");
	String role = (String) sess.getAttribute("role");

	List<Leaves> leaves = (List<Leaves>) request.getAttribute("filteredLeaves");
	
	String selectedEmpIdStr = request.getParameter("empid");
    int selectedEmpId = (selectedEmpIdStr != null && !selectedEmpIdStr.isEmpty()) ? Integer.parseInt(selectedEmpIdStr) : -1;

	//List<Leaves> leaves = null;
	List<Employees> employees = null;
	int mid = ((Employees) sess.getAttribute("employee")).getEmpId();

	if ("HR".equals(role)) {
		employees = empDao.getEmployees();
	}
	if ("Manager".equals(role)) {
		employees = empDao.getReportees(mid);
	}
	%>


	<div class="sidebar" id="sidebar">
		<div class="logo">
			<img src="logo.png" alt="Logo">
		</div>
		<ul class="sidebar-menu">
			<li><a href="dashboard.jsp"><i class="fas fa-tachometer-alt"></i><span
					class="menu-text"> Dashboard</span></a></li>
			<li><i class="fas fa-user-cog"></i><span class="menu-text">
					Admin</span></li>
			<li><i class="fas fa-users"></i><span class="menu-text">
					PIM</span></li>
			<li><a href="applyLeave.jsp"><i class="fas fa-calendar-alt"></i><span
					class="menu-text"> Leave</span></a></li>
			<li><i class="fas fa-clock"></i><span class="menu-text">
					Time</span></li>
			<li><i class="fas fa-user-plus"></i><span class="menu-text">
					Recruitment</span></li>
			<li><i class="fas fa-id-badge"></i><span class="menu-text">
					My Info</span></li>

		</ul>
	</div>

	<button id="toggleSidebar" class="toggle-btn">
		<i class="fas fa-chevron-left show"></i> <i
			class="fas fa-chevron-right"></i>
	</button>

	<div class="main-content">
		<header class="header">
			<h1>Leave / My Leaves</h1>
			<div class="user-profile">
				<div class="user-dropdown">
					<button class="dropbtn" id="userDropdown">
						<%=emp.getFname() + " " + emp.getLname()%>
						<i class="fas fa-caret-down"></i>
					</button>
					<div class="dropdown-content" id="userDropdownContent">
						<a href="changePassword.jsp">Change Password</a> <a
							href="logoutServlet">Logout</a>
					</div>
				</div>
			</div>
		</header>
		<div class="leaveLinks">
			<a href="applyLeave.jsp">Apply Leave</a> <a href="myLeaves.jsp">My
				Leaves</a> <a href="holidays.jsp">Holidays</a>
			<%
			if ("HR".equals(role) || "Manager".equals(role)) {
			%>
			<a href="applyLeaveFor.jsp">Apply Leave For</a>
			<a href="leaveRequests.jsp">Leave Requests</a>
			<%
			}
			if ("HR".equals(role)) {
			%>
			<a href="assignLeave.jsp">Assign Leaves</a> <a
				href="employeeLeaves.jsp">Employee Leave List</a>
			<%
			}
			if ("Manager".equals(role)) {
			%>
			<a href="employeeLeaves.jsp">Reportee Leave List</a>
			<%
			}
			%>


		</div>

		<div class="table-container">
			<h2>My Leaves</h2>

			<hr>

			<div class="filter">
				<form action="filterLeaveBy" method="post">
					<div class="form-container">
						<label for="employeeid">Employee Name*</label> 
						<select id="empid" name="empid" required>
							<option value="">Select Employee</option>
							<%
							for (Employees r : employees) {
							%>
							<option value="<%=r.getEmpId()%>"
								<%=(r.getEmpId() == selectedEmpId) ? "selected" : ""%>>
								<%=r.getFname() + " " + r.getLname()%>
							</option>
							<%
							}
							%>
						</select>
					</div>


					<div class="form-container">
						<label for="year">Year:</label> <input type="text" id="year"
							name="year" onkeyup="toggleMonthDropdown()"
							value="<%=request.getParameter("year") != null ? request.getParameter("year") : ""%>">
					</div>

					<div class="form-container">
						<label for="month">Month:</label> <select id="month" name="month">
							<option value=""
								<%="".equals(request.getParameter("month")) ? "selected" : ""%>>Select
								Month</option>
							<option value="01"
								<%="01".equals(request.getParameter("month")) ? "selected" : ""%>>January</option>
							<option value="02"
								<%="02".equals(request.getParameter("month")) ? "selected" : ""%>>February</option>
							<option value="03"
								<%="03".equals(request.getParameter("month")) ? "selected" : ""%>>March</option>
							<option value="04"
								<%="04".equals(request.getParameter("month")) ? "selected" : ""%>>April</option>
							<option value="05"
								<%="05".equals(request.getParameter("month")) ? "selected" : ""%>>May</option>
							<option value="06"
								<%="06".equals(request.getParameter("month")) ? "selected" : ""%>>June</option>
							<option value="07"
								<%="07".equals(request.getParameter("month")) ? "selected" : ""%>>July</option>
							<option value="08"
								<%="08".equals(request.getParameter("month")) ? "selected" : ""%>>August</option>
							<option value="09"
								<%="09".equals(request.getParameter("month")) ? "selected" : ""%>>September</option>
							<option value="10"
								<%="10".equals(request.getParameter("month")) ? "selected" : ""%>>October</option>
							<option value="11"
								<%="11".equals(request.getParameter("month")) ? "selected" : ""%>>November</option>
							<option value="12"
								<%="12".equals(request.getParameter("month")) ? "selected" : ""%>>December</option>
						</select>
					</div>

					<div class="form-container">
						<button type="submit" class="apply-btn">Filter</button>
					</div>
				</form>
			</div>


			<table class="leave-table">
				<thead>
					<tr>
						<th>From Date</th>
						<th>To Date</th>
						<th>Total Days</th>
						<th>Leave Type</th>
						<th>Status</th>
						<th>Actions</th>
					</tr>
				</thead>
				<tbody>
					<%
					if (leaves == null) {
						leaves = empDao.getEmployeeLeaves(emp.getEmpId());
					}

					for (Leaves lev : leaves) {
					%>
					<tr>
						<td><%=lev.getFromDate()%></td>
						<td><%=lev.getToDate()%></td>
						<td><%=lev.getTotalDays()%></td>
						<td><%=lev.getLeaveType()%></td>
						<td><%=lev.getLeaveStatus()%></td>
						<td>
							<%
							if ("Pending".equals(lev.getLeaveStatus())) {
							%> <a
							href="cancel?id=<%=lev.getLeaveId()%>" class="cancel-btn">Cancel</a>
							<%
							}
							%>
						</td>
					</tr>
					<%
					}
					%>
				</tbody>
			</table>

		</div>
	</div>

</body>
</html>