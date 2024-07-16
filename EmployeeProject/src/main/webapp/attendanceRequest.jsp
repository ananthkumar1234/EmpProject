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
<title>Attendance</title>

<link rel="stylesheet" href="index.css">
<link rel="stylesheet" href="show.css">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<script src="script.js" defer></script>
</head>
<style>

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

</style>

<script >


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
		
		<div class="attendLinks">
			<a href="attendance.jsp">Attendance Records List</a> 
			<%if("HR".equals(role) || "Manager".equals(role)){ %>
			<a href="attendanceRequest.jsp">Attendance Update Requests</a> 
			<%} %> 
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