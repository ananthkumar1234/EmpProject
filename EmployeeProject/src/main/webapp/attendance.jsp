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
<link rel="stylesheet" href="index.css">
<link rel="stylesheet" href="show.css">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<script src="script.js" defer></script>
</head>
<style>

/*====================================table starts========================================*/
@media (max-width: 768px) {
  .leave-table {
    font-size: 14px;
  }
  
  .leave-table th,
  .leave-table td {
    padding: 2px 2px;
  }
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



</style>

<script >

window.onload = function() {
	toggleMonthDropdown(); // Initial check
<%Boolean f = (Boolean) request.getAttribute("flag");
if (f != null && f) {%>
document.getElementById("myPopup").style.display = "block";
<%}%>
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


function openPopup() {
	document.getElementById("myPopup").style.display = "block";
}

function openPopup2(AttenId, Date, CITime, COTime) {
	document.getElementById("attenId").value = AttenId;
	document.getElementById("date").value = Date;
	document.getElementById("cit").value = CITime;
	document.getElementById("cot").value = COTime;
	document.getElementById("myPopup2").style.display = "block";
}

function closePopup(popupId) {
	document.getElementById(popupId).style.display = "none";
}

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
        <li class="act"><a href="admin.jsp" id="admin-link"><i class="fas fa-user-cog"></i><span class="menu-text"> Admin</span></a></li>
        <li class="act"><a href="pim.jsp" id="pim-link"><i class="fas fa-users"></i><span class="menu-text"> PIM</span></a></li>
        <li class="activeLeave"><a href="applyLeave.jsp" id="leave-link"><i class="fas fa-calendar-alt"></i><span class="menu-text"> Leave</span></a></li>
        <li class="activeAttendance"><a href="attendance.jsp" id="time-link"><i class="fas fa-clock"></i><span class="menu-text"> Time Logs</span></a></li>
        <li class="act"><a href="recruitment.jsp" id="recruitment-link"><i class="fas fa-user-plus"></i><span class="menu-text"> Recruitment</span></a></li>
        <li class="act"><a href="myinfo.jsp" id="myinfo-link"><i class="fas fa-id-badge"></i><span class="menu-text"> My Info</span></a></li>
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
		Hello guru!
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
								<th>Date</th>
								<th>Check In Time</th>
								<th>Check Out Time</th>
								<th>Total Hours</th>
								<th>Remarks</th>
								<th>Request Update</th>
							</tr>
						</thead>
						<tbody>
							<%
							if (attendanceList == null) {
								attendanceList = empDao.getAttRecordById(emp.getEmpId());
							}
							for (Attendance attendance : attendanceList) {
								boolean highlightRow = (attendance.getCheckin() != null && attendance.getCheckout() == null)
								&& (LocalDate.now().isAfter(LocalDate.parse(attendance.getDate(), formatter)));
							%>
							<tr <%=highlightRow ? "style='background-color: #949494;'" : ""%>>
								<td><%=attendance.getDate()%></td>
								<td><%=attendance.getCheckin()%></td>
								<td><%=attendance.getCheckout()%></td>
								<td>
									<%
									if (attendance.getCheckin() != null && attendance.getCheckout() != null) {
										try {
											LocalTime st = LocalTime.parse(attendance.getCheckin());
											LocalTime et = LocalTime.parse(attendance.getCheckout());
											Duration difference = Duration.between(st, et);
											long hours = difference.toHours();
											long minutes = difference.toMinutes() % 60;
											out.print(hours + "h : " + minutes + "m");
										} catch (Exception ex) {
											out.print("Invalid time format");
										}
									} else if (attendance.getCheckin() != null && attendance.getCheckout() == null
											&& LocalDate.now().isAfter(LocalDate.parse(attendance.getDate(), formatter))) {
										out.print("Checkout is missing");
									} else {
										out.print("-");
									}
									%>
								</td>
								<td>
									<%
									if (attendance.getRemarks() == null)
										out.print("-");
									else
										out.print(attendance.getRemarks());
									%>
								</td>

								<td>
									<%
									if (attendance.isButtonClicked() == 0 && 
								    !("Weekend".equals(attendance.getRemarks()) || 
								      "Holiday".equals(attendance.getRemarks()) || 
								      "Leave".equals(attendance.getRemarks()))) {
									%>
									<button
										onclick="openPopup2('<%=attendance.getAttendId()%>', '<%=attendance.getDate()%>', '<%=attendance.getCheckin()%>', '<%=attendance.getCheckout()%>')">Request Update</button> 
										<% } else {
											 out.print("-");
										 }
										 %>

								</td>
							</tr>
							<%
							}
							%>
						</tbody>
					</table>
					
					
					<!-- Attendance Update Popup -->
					<div id="myPopup2" class="popup">
						<span class="close-btn" onclick="closePopup('myPopup2')">&times;</span>
						<h2>Update Attendance</h2>
						<form action="requestUpdate" method="get" class="PopupForm">
							<label for="attenId"></label> 
							<input type="hidden" id="attenId" name="attenId"> 
							<input type="hidden" name="empName" value="<%=empName%>"> 
							<label for="date">Date:</label> 
							<input type="text" id="date" name="date" readonly> 
							<label for="cit">Check In Time:</label> 
							<input type="text" id="cit" name="cit" placeholder="HH:MM:SS (24hr)"> 
							<label for="cot">Check Out Time:</label> 
							<input type="text" id="cot" name="cot" placeholder="HH:MM:SS (24hr)"> 
							<input type="submit" value="Request Update">
						</form>
					</div>

					<!-- General Notification Popup -->
					<div id="myPopup" class="popup">
						<span class="close-btn" onclick="closePopup('myPopup')">&times;</span>
						<h2>Warning!</h2>
						<form action="insertYES" method="post">
							<input type="hidden" name="eid" value="<%= emp.getEmpId()%>"> <input
								type="hidden" name="leaveid" id="leaveid">
							<div class="warning">
								<h5>Today it's not a working day (Holiday!)</h5>
							</div>
							<div class="msg">Are you sure you want to login?</div>
							<div>
								<input type="submit" value="Proceed to login" name="yes">
							</div>
						</form>
					</div>

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