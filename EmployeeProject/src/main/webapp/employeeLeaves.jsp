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

<link rel="stylesheet" href="index.css">
<link rel="stylesheet" href="show.css">
<script src="script.js"></script>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>

<style>
/* table css starts*/
.table-container {
	background-color: #ffffff;
	border-radius: 8px;
	box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
	padding: 20px;
	max-width: 1200px;
	margin: 0 auto;
	margin-top: 12%;
    margin-left:20px;
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
	
	
	
	document.addEventListener("DOMContentLoaded", function() {
	    var currentPage = window.location.pathname.split("/").pop();
	    
	    var leavePages = ["applyLeave.jsp","applyLeaveFor.jsp","assignLeave.jsp","employeeLeaves.jsp","holidays.jsp","leaveRequests.jsp","myLeaves.jsp"];
	    var timePages = ["attendance.jsp", "attendanceRequest.jsp"];
	    
	    if (leavePages.includes(currentPage)) {
	        document.querySelector(".activeLeave").classList.add("active");
	    } else if (timePages.includes(currentPage)) {
	        document.querySelector(".activeAttendance").classList.add("active");
	    }
	    else{
	            document.querySelector(".activeDashboard").classList.add("active");
	    }
	});
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
	Employees emp2 = (Employees)sess.getAttribute("employee");

	int mid = emp2.getEmpId();
	
	if ("HR".equals(role)) {
		employees = empDao.getEmployees();
	}
	if ("Manager".equals(role)) {
		employees = empDao.getReportees(mid);
	}
	%>


	<div class="sidebar" id="sidebar">
		<div class="logo">
			
		</div>
		<ul class="sidebar-menu">
        <li class="activeDashboard"><a href="dashboard.jsp" id="dashboard-link"><i class="fas fa-tachometer-alt"></i><span class="menu-text"> Dashboard</span></a></li>
        
		<%if(role.equals("HR") || role.equals("Manager")) { %>
        <li class="activePeople"><a href="employees.jsp" id="pim-link"><i class="fas fa-users"></i><span class="menu-text"> People</span></a></li>
        <%}%>        
        
        <li class="activeLeave"><a href="applyLeave.jsp" id="leave-link"><i class="fas fa-calendar-alt"></i><span class="menu-text"> Leave</span></a></li>
        <li class="activeAttendance"><a href="attendance.jsp" id="time-link"><i class="fas fa-clock"></i><span class="menu-text"> Time Logs</span></a></li>
        <li class="activeProfile"><a href="profile.jsp" id="myinfo-link"><i class="fas fa-id-badge"></i><span class="menu-text"> My Info</span></a></li>
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
				href="employeeLeaves.jsp">Employees Leaves </a>
			<%
			}
			if ("Manager".equals(role)) {
			%>
			<a href="employeeLeaves.jsp">Reportees Leaves</a>
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