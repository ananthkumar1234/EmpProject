<%@page import="org.apache.taglibs.standard.tag.common.xml.ForEachTag"%>
<%@page import="org.apache.jasper.tagplugins.jstl.core.ForEach"%>
<%@ page import="java.util.List"%>
<%@ page import="com.emp.entities.Attendance"%>
<%@ page import="com.emp.entities.Holidays"%>
<%@ page import="com.emp.entities.Employees"%>
<%@ page import="com.emp.entities.Roles"%>
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
.sidebar-menu li.active {
    background: linear-gradient(to left,#FF9671 ,#FFC75F );
    border-radius:0 50px 50px 0;
    width:70%;
}

/*  table css =======================================*/

.table-container {
  background-color: #ffffff;
  border-radius: 8px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
  padding: 20px;
  max-width: 100%;
  margin-top:2%;
  margin-left:20px;
  
  transition: width 0.3s ease, margin-left 0.3s ease;
}

.filter-container {
  background-color: #ffffff;
  border-radius: 8px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
  padding: 20px;
  max-width: 100%;
  
  margin-top: 12%;

  margin-left:20px;
  
  transition: width 0.3s ease, margin-left 0.3s ease;
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

.form-container label {
	white-space: nowrap;
}

.form-container input[type="text"],select {
	width: 40%;
	padding: 8px;
	border: 1px solid #ddd;
	border-radius: 4px;
	box-sizing: border-box;
}

.formButton{
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

.edit-btn i {
  font-size:25px;
  color: #ffcc80;
  cursor: pointer;
  font-weight: bold;
  border:1px solid white;
  border-radius:10px;
  padding:5px;
}
.delete-btn i{
 font-size:27px;
  color: #ff8a65;
  cursor: pointer;
  font-weight: bold;
  border:1px solid white;
  border-radius:10px;
  padding:5px;
}
.edit-btn i:hover, .delete-btn i:hover
{
background-color:white;
}

</style>

<body>

	<%
        Connection con = DBConnect.getConnection();
        EmpDao empDao = new EmpDao(con);
        
        HttpSession sess = request.getSession();
        Employees emp = (Employees)sess.getAttribute("employee");
        String role = (String)sess.getAttribute("role");
        
        List<Employees> employees =(List<Employees>)request.getAttribute("empList");
        List<Roles> JobTitle=empDao.getRoles();
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
			<h1>People / Employees</h1>
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
		
		<div class="filter-container">
		<form action="EmployeeFilter" method="post">
					<div class="form-container">
						<label for="JobTitle">Role</label> 
						 <select id="JobTitle" name="JobTitle">
                            <option value="">Select Job Title</option>
        <% 
        String selectedRoleId = request.getParameter("JobTitle");
        for (Roles r : JobTitle) { 
            String roleId = String.valueOf(r.getRoleId());
            String selected = roleId.equals(selectedRoleId) ? "selected" : "";
        %>
        <option value="<%= roleId %>" <%= selected %>><%= r.getRoleName() %></option>
        <% } %>
                        </select>
                        <input type="text" id="name" name="name" placeholder="Search by name" value="<%= request.getParameter("name") != null ? request.getParameter("name") : "" %>">
					</div>


					<div class="formButton">
						<button type="submit" class="apply-btn">Filter</button>
					</div>
				</form>
		</div>
		
		<div class="table-container">
		
		 <table class="leave-table">
    <thead>
        <tr>
            <th>Full Name</th>
            <th>Actions</th>

        </tr>
    </thead>
    <tbody>
        <%if(employees==null){ 
        
        if(role.equals("Manager")){
        employees = empDao.getReportees(emp.getEmpId());
        }else
        {
        	employees = empDao.getAllEmployees();
        }
        }
        for (Employees emp2 : employees) { %>
            <tr>
                <td><%= emp2.getFname() %> <%= emp2.getLname() %></td>
                <td>
                
				<a href="editEmployee?id=<%= emp2.getEmpId() %>" class="edit-btn"><i class="fa fa-pencil" aria-hidden="true"></i></a>
                <a href="deleteEmployee?id=<%= emp2.getEmpId() %>" class="delete-btn"><i class="fa fa-trash" aria-hidden="true"></i></a>
                
                </td>

            </tr>
        <% } %>
    </tbody>
</table>
		
		</div>
		

	</div>
	
	<script>
	
	//to highlight the active tabs(anchor tag links) 

	document.addEventListener("DOMContentLoaded", function() {
		    var currentPage = window.location.pathname.split("/").pop();
		    var targetPage = "employees.jsp";
		    
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
			}else if (currentPage === "EmployeeFilter") {
			    targetPage = "employees.jsp";
			    document.querySelector(".activePeople").classList.add("active");
			}
		    else{
				document.querySelector(".activeDashboard").classList.add("active");
		    }
		});
	
	</script>

</body>
</html>