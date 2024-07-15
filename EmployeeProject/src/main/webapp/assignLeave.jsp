<%@page import="org.apache.taglibs.standard.tag.common.xml.ForEachTag"%>
<%@page import="org.apache.jasper.tagplugins.jstl.core.ForEach"%>
<%@ page import="java.util.List"%>
<%@ page import="com.emp.entities.Attendance"%>
<%@ page import="com.emp.entities.Holidays"%>
<%@ page import="com.emp.entities.Employees"%>
<%@ page import="com.emp.jdbc.DBConnect"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="com.emp.dao.EmpDao"%>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
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
	z-index: 1001;
	box-shadow: 2px 0 5px rgba(0, 0, 0, 0.1);
	border-radius: 0 20px 20px 0;
}

.sidebar.collapsed {
	width: 60px;
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
    background: linear-gradient(to left,#FF9671 ,#FFC75F );
    border-radius:0 50px 50px 0;
    width:70%;
}
.sidebar-menu li.active a {
    color: white;
}
.sidebar-menu li.active i {
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
    z-index: 1000;

}

body.sidebar-collapsed {
	padding-left: 60px;
}

body.sidebar-collapsed .main-content {
    margin-left: 60px;
}

body.sidebar-collapsed .header {
    left: 40px;
}

body.sidebar-collapsed .leaveLinks {
    left: 60px;
}

body.sidebar-collapsed .leave-form-container {
    left: 60px;
}

.user-profile {
	position: relative;
}

.user-profile:hover {
    transform: scale(1.05);
    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
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
	.leaveLinks{
	flex-direction:column;
	align-item:stretch;
	}


}

a {
    text-decoration: none;
    color:black;
}

h1
{
margin:30px;
}

.logo {
	padding: 20px;
	border-bottom: 1px solid #e0e0e0;
}

.logo img {
	max-width: 100%;
	height: auto;
}

.show {
	display: block !important;
}


/*  After header leavelinks starts*/
.leaveLinks {
	display: flex;
	background-color: white;
	padding: 10px 20px;
	margin-bottom: 20px;
	box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
	margin-top:5.2%;
	position: fixed;
    top: 0;
    right: 0;
    left: 230px;
    transition: left 0.3s ease;
    z-index: 999;
}

.leaveLinks a {
	color: #6c757d;
	text-decoration: none;
	padding: 10px 15px;
	font-size: 14px;
	transition: all 0.3s ease;
	margin: 0 5px;
	margin-left:30px;
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

/*  After header leavelinks ends*/


/*form-container css starts*/


.leave-form-container {
  background-color: #ffffff;
  border-radius: 8px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
  padding: 20px;
  max-width: 100%;
  
  margin-top: 12%;

  margin-left:20px;
  margin-bottom:10px;
  transition: width 0.3s ease, margin-left 0.3s ease;
}

h2 {
  color: #333;
  margin-bottom: 20px;
}

.leave-form {
  display: flex;
  flex-wrap: wrap;
}

.form-left {
  flex: 1;
  min-width: 300px;
  padding-right: 20px;
}

.form-right {
  width: 200px;
  padding-left: 20px;
  border-left: 1px solid #ddd;
}

.form-row {
  display: flex;
  justify-content: space-between;
  margin-bottom: 15px;
}

.form-group {
  flex: 1;
  margin-right: 15px;
  margin-bottom: 15px;
}

.form-group:last-child {
  margin-right: 0;
}

label {
  display: block;
  margin-bottom: 5px;
  color: #666;
}

select, input[type="date"],input[type="text"], textarea {
  width: 100%;
  padding: 8px;
  border: 1px solid #ddd;
  border-radius: 4px;
  box-sizing: border-box;
}

.leave-balance {
  text-align: left;
}

.leave-balance p {
  font-weight: bold;
  color: #333;
  margin: 0;
  font-size: 1.2em;
}

textarea {
  resize: vertical;
}

.form-footer {
  width: 100%;
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-top: 20px;
}

.required-note {
  color: #666;
  font-size: 0.9em;
  margin: 0;
}

.apply-btn {
  background-color: #8bc34a;
  color: white;
  border: none;
  padding: 10px 20px;
  border-radius: 4px;
  cursor: pointer;
  font-size: 1em;
}

.apply-btn:hover {
  background-color: #7cb342;
}

/*form container css ends*/

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
  border-spacing: 0 10px;
  
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

.cancel-btn {
  background-color: #fff3e0;
  color: #ff9800;
  border: none;
  padding: 6px 12px;
  border-radius: 20px;
  cursor: pointer;
  font-weight: bold;
}



@media (max-width: 768px) {
  .leave-table {
    font-size: 14px;
  }
  
  .leave-table th,
  .leave-table td {
    padding: 10px 8px;
  }
  
  .cancel-btn {
    padding: 4px 8px;
    font-size: 12px;
  }}

/* table css ends*/

.strikethrough {
        text-decoration: line-through;
        color: black;
    }
    
 /*warning message starts*/
 
  .warning-message {
            position: fixed;
            top: -200px; /* Move completely out of view */
            left: 50%;
            transform: translateX(-50%);
            background-color: rgba(220, 53, 69, 0.8);  /* More transparency */
            color: white;
            padding: 15px 30px;
            border-radius: 12px;
            box-shadow: 0 6px 16px rgba(0, 0, 0, 0.2); /* Slightly stronger shadow for more depth */
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
            background-color: rgba(144, 238, 144, 0.8); /* More transparency */
            color: white;
            padding: 15px 30px;
            border-radius: 12px;
            box-shadow: 0 6px 16px rgba(0, 0, 0, 0.2); /* Slightly stronger shadow for more depth */
            text-align: center;
            transition: all 0.5s cubic-bezier(0.68, -0.55, 0.27, 1.55);
            z-index: 1000;
            max-width: 90%;
            backdrop-filter: blur(10px); /* Stronger blur effect */
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        
        .warning-message p,.success-message p{
          font-weight: bold;
            margin: 8px 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; /* More modern font */
        }

        .warning-message p:first-child, .success-message p:first-child{
            font-weight: bold;
            font-size: 20px;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .warning-message i, .success-message i{
            font-size: 24px;
            margin-right: 10px;
            vertical-align: middle;
        }

        .warning-message.show, .success-message.show{
            top: 30px;
            animation: shake 0.82s cubic-bezier(.36,.07,.19,.97) both;
        }
        
 /*warning message ends*/
 

</style>


<link rel="stylesheet"
	href="https://npmcdn.com/flatpickr/dist/flatpickr.min.css">
<script src="https://npmcdn.com/flatpickr/dist/flatpickr.min.js"></script>

<script>

document.addEventListener("DOMContentLoaded", function() {
    var currentPage = window.location.pathname.split("/").pop();
    
    var leavePages = ["applyLeave.jsp","applyLeaveFor.jsp","assignLeave.jsp","employeeLeaves.jsp","holidays.jsp","leaveRequests.jsp","myLeaves.jsp"];
    var timePages = ["attendancelist.jsp", "empattendance.jsp", "time.jsp"];
    
    if (leavePages.includes(currentPage)) {
        document.querySelector(".activeLeave").classList.add("active");
    } else if (timePages.includes(currentPage)) {
        document.querySelector(".time-group").classList.add("active");
    }
    else{
            document.querySelector(".activeDashboard").classList.add("active");
    }
});


document.addEventListener("DOMContentLoaded", function() {
    flatpickr("#date", {
    });
});

function showWarningMessage() {
	const warningMessage = document.getElementById('warning-message');
	warningMessage.classList.add('show');

	setTimeout(() => {
	    warningMessage.classList.remove('show');
	}, 4000);
	}


function showSuccessMessage() {
	const warningMessage = document.getElementById('success-message');
	warningMessage.classList.add('show');

	setTimeout(() => {
	    warningMessage.classList.remove('show');
	}, 4000);
	}

// Check for login error
window.onload = function() {
<% if (request.getAttribute("msg")!=null && request.getAttribute("msg").equals("Error")) { %>
    showWarningMessage();
<% } 
else if (request.getAttribute("msg")!=null && request.getAttribute("msg").equals("Success")){%> showSuccessMessage();

<%}%>}

</script>

<body>

<div id="warning-message" class="warning-message">
        <span><i class="fas fa-exclamation-triangle"></i></span>
        <p>Something Went Wrong!</p>
</div>


<div id="success-message" class="success-message">
        <i class="fas fa-check-circle"></i>
        <p>Leaves assigned to active Employees...</p>
</div>

	<%
        Connection con = DBConnect.getConnection();
        EmpDao empDao = new EmpDao(con);
        
        List<Holidays> holidays = empDao.getAllHolidays();
        
        HttpSession sess = request.getSession();
        Employees emp = (Employees)sess.getAttribute("employee");
        String role = (String)sess.getAttribute("role");
    %>

	<div class="sidebar" id="sidebar">
		<div class="logo">
			
		</div>
		<ul class="sidebar-menu">
        <li class="activeDashboard"><a href="dashboard.jsp" id="dashboard-link"><i class="fas fa-tachometer-alt"></i><span class="menu-text"> Dashboard</span></a></li>
        <li class="act"><a href="admin.jsp" id="admin-link"><i class="fas fa-user-cog"></i><span class="menu-text"> Admin</span></a></li>
        <li class="act"><a href="pim.jsp" id="pim-link"><i class="fas fa-users"></i><span class="menu-text"> PIM</span></a></li>
        <li class="activeLeave"><a href="applyLeave.jsp" id="leave-link"><i class="fas fa-calendar-alt"></i><span class="menu-text"> Leave</span></a></li>
        <li class="activeAttendance"><a href="time.jsp" id="time-link"><i class="fas fa-clock"></i><span class="menu-text"> Time</span></a></li>
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
			<h1>Leave / Assign Leave</h1>
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
		
		<div class="leaveLinks">
			<a href="applyLeave.jsp">Apply Leave</a> 
			<a href="myLeaves.jsp">My Leaves</a> 
			<a href="holidays.jsp">Holidays</a>
			<%if("HR".equals(role) || "Manager".equals(role)){ %>
			<a href="applyLeaveFor.jsp">Apply Leave For</a>
			<a href="leaveRequests.jsp">Leave Requests</a>
			<%} if("HR".equals(role)) {%>
			<a href="assignLeave.jsp">Assign Leaves</a>
			<a href="employeeLeaves.jsp">Employee Leave List</a>
			<%}  if("Manager".equals(role)) {%>
			<a href="employeeLeaves.jsp">Reportee Leave List</a>
			<%}%>
			 

		</div>
		
		
		<div class="leave-form-container">
				<h2>Assign Leaves</h2>
				<hr>
				<form class="leave-form" action="assignLeave" method="post">
					<div class="form-left">
						<div class="form-row">
							<div class="form-group">
								<label for="nod">No of Days*</label> <input type="text"
									id="nod" name="nod" required>
							</div>
							<div class="form-group">
							<p></p>
						<button type="submit" class="apply-btn">Assign Leave</button>
					</div>
						</div>
					</div>
					
				</form>
			</div>	
			
		</div>



</body>
</html>