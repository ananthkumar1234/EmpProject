<%@page import="org.apache.taglibs.standard.tag.common.xml.ForEachTag"%>
<%@page import="org.apache.jasper.tagplugins.jstl.core.ForEach"%>
<%@ page import="java.util.List"%>
<%@ page import="com.emp.entities.Attendance"%>
<%@ page import="com.emp.entities.Holidays"%>
<%@ page import="com.emp.entities.Employees"%>
<%@ page import="com.emp.jdbc.DBConnect"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="com.emp.dao.EmpDao"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>People</title>

<link rel="stylesheet" href="index.css">
<link rel="stylesheet" href="show.css">
<script src="script.js"></script>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

<link rel="stylesheet"
	href="https://npmcdn.com/flatpickr/dist/flatpickr.min.css">
<script src="https://npmcdn.com/flatpickr/dist/flatpickr.min.js"></script>
</head>
<style>
body.sidebar-collapsed .peopleLinks {
    left: 3%;
}
.peopleLinks {
	display: flex;
	background-color: white;
	padding: 1% 2%;
	box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
	margin-top:4.2%;
	position: fixed;
    top: 10px;
    right: 0;
    left: 15%;
    transition: left 0.3s ease;
    z-index: 999;
    flex-direction:row;
    justify-content:start;
}

.peopleLinks a {
	color: #6c757d;
	text-decoration: none;
	padding: 1% 1%;
	font-size:85%;
	transition: all 0.3s ease;
	
	margin-left:3%;
	border-radius: 10px;
	background-color: #f5f5f5;
	box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
}

.peopleLinks a:hover, .peopleLinks a:focus {
	color: #ff8c00;
	background-color: #fff9f0;
	box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
	transform: translateY(-2px);
}
</style>

<body>

	<div id="error-message" class="error-message">
		<span><i class="fas fa-exclamation-triangle"></i></span>
		<p>Something Went Wrong!</p>
	</div>

	<div id="success-message" class="success-message">
		<span><i class="fas fa-check-circle"></i></span>
		<p>Leave Applied Successfully...</p>
	</div>

	<%
        Connection con = DBConnect.getConnection();
        EmpDao empDao = new EmpDao(con);
        
        List<Holidays> holidays = empDao.getHolidays();
        
        HttpSession sess = request.getSession();
        Employees emp = (Employees)sess.getAttribute("employee");
        String role = (String)sess.getAttribute("role");
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
			<h1>People / Add Employee</h1>
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
		<div class="peopleLinks">
			<% if(role.equals("Manager")) { %>
			<a href="employees.jsp">Reportees</a>
			<%}else{%>
			<a href="employees.jsp">Employees</a>
			<a href="addEmployee.jsp">Add Employee</a>
			<%} %>
		</div>

	</div>
	
	<script>
	
	document.addEventListener("DOMContentLoaded", function() {
	    var currentPage = window.location.pathname.split("/").pop();
	    
	    var leavePages = ["applyLeave.jsp","applyLeaveFor.jsp","assignLeave.jsp","employeeLeaves.jsp","holidays.jsp","leaveRequests.jsp","myLeaves.jsp"];
	    var timePages = ["attendance.jsp", "attendanceRequest.jsp"];
		var peoplePages = ["employees.jsp","addEmployee.jsp"];
		var profilePage = ["profile.jsp"];
	    
	    if (leavePages.includes(currentPage)) {
	        document.querySelector(".activeLeave").classList.add("active");
	    } else if (timePages.includes(currentPage)) {
	        document.querySelector(".activeAttendance").classList.add("active");
	    } else if (peoplePages.includes(currentPage)) {
		    document.querySelector(".activePeople").classList.add("active");
		} else if (profilePage.includes(currentPage)) {
		    document.querySelector(".activeProfile").classList.add("active");
		}
	    else{
			document.querySelector(".activeDashboard").classList.add("active");
	    }
	});
	
	</script>

</body>
</html>