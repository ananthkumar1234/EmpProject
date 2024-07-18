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

/* Main form*/
.formContainer {
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

.formContainer {
    display: flex;
    background-color: #ffffff;
    border-radius: 8px;
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
    margin-top: 12%;
    margin-left: 20px;
    margin-bottom: 10px;
    transition: width 0.3s ease, margin-left 0.3s ease;
}

.formMenu {
    width: 200px;
    padding: 20px;
    border-right: 1px solid #e0e0e0;
}

.formMenu ul {
    list-style-type: none;
    padding: 0;
    margin: 0;
}

.formMenu li {
    padding: 10px 15px;
    cursor: pointer;
    transition: background-color 0.3s;
    border-radius: 5px;
}

.formMenu li:hover {
    background-color: #f5f5f5;
}

.formMenu li.active {
    background-color: #e6f7ff;
    color: #1890ff;
}

.formMain {
    flex-grow: 1;
    padding: 20px;
}

.content {
    display: none;
}

.form-row {
            display: flex;
            margin-bottom: 3%;
        }
        .form-group {
            flex: 1;
            margin-right: 5%;
        }
        .form-group:last-child {
            margin-right: 0;
        }
        label {
            display: block;
            margin-bottom: 2%;
            color: #666;
        }
        input[type="text"], input[type="email"],input[type="Date"],input[type="password"], select {
            width: 100%;
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 10px;
            box-sizing: border-box;
            background-color:#f0f0f0;
        }
   
  .form-row.checkbox-row {
    align-items: center;
}

.checkbox-label {
    display: flex;
    align-items: center;
    cursor: pointer;
}

.checkbox-label input[type="checkbox"] {
    margin-right: 8px;
    width: 18px;
    height: 18px;
}

.checkbox-label span {
    font-size: 16px;
    line-height: 18px;
}
		input:disabled {
  background-color: #f0f0f0;
  cursor: not-allowed;
}

</style>

<body>

	<%
        Connection con = DBConnect.getConnection();
        EmpDao empDao = new EmpDao(con);
        
        List<Holidays> holidays = empDao.getHolidays();
        List<Roles> JobTitle=empDao.getRoles();
        
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
		
		<div class="formContainer">
		
    <div class="formMenu">
    <h2>Add Employee</h2>
        <ul>
            <li onclick="showDiv('PD')">Personal Details</li>
            <li onclick="showDiv('CD')">Contact Details</li>
            <li onclick="showDiv('J')">Employment Details</li>
            <li onclick="showDiv('UC')">User Credentials</li>
            <li onclick="showDiv('RT')">Report-to</li>
        </ul>
    </div>
    
    <div class="formMain">
        <div class="content PD">
            <!-- Personal Details content -->
            <h2>Personal Details</h2>
            <hr>
            
            <div class="form-row">
                <div class="form-group">
                    <label for="FirstName">First Name</label>
                    <input type="text" id="FirstName" name="FirstName">
                </div>
                <div class="form-group">
                    <label for="LastName">Last Name</label>
                    <input type="text" id="LastName" name="LastName">
                </div>
            </div>
            
            
            
            <div class="form-row">
                <div class="form-group">
                    <label for="DateOfBirth">Date Of Birth</label>
                    <input type="Date" id="DateOfBirth" name="DateOfBirth">
                </div>
                <div class="form-group">
                    <label for="Gender">Gender</label>
                    <select id="Gender" name="Gender">
                    <option value="">Select Gender</option>
                    <option value="Married">Male</option>
                    <option value="Single">Female</option>
                    <option value="Other">Other</option>
                    </select>
                </div>
            </div>
            
            <div class="form-row">
                <div class="form-group">
                    <label for="Nationality">Nationality</label>
					<input type="text" id="Nationality" name="Nationality">
				
                </div>
                <div class="form-group">
                    <label for="MaritalStatus">Marital Status</label>
                    <select id="MaritalStatus" name="MaritalStatus">
                    <option value="">Select Marital Status</option>
                    <option value="Married">Married</option>
                    <option value="Single">Single</option>
                    </select>
                </div>
            </div>
            
            
            
        </div>
        <div class="content CD">
            <!-- Contact Details content -->
            <h2>Contact Details</h2>
            <hr>
            <h3>Permanent Address</h3>
            <div class="form-row">
                <div class="form-group">
                    <label for="PermanentStreet1">Address Line 1</label>
                    <input type="text" id="PermanentStreet1" name="PermanentStreet1">
                </div>
                <div class="form-group">
                    <label for="PermanentStreet2">Address Line 2</label>
                    <input type="text" id="PermanentStreet2" name="PermanentStreet2">
                </div>
                <div class="form-group">
                    <label for="PermanentCity">City</label>
                    <input type="text" id="PermanentCity" name="PermanentCity">
                </div>
            </div>
            
            <div class="form-row">
                <div class="form-group">
                    <label for="PermanentState">State</label>
                    <input type="text" id="PermanentState" name="PermanentState">
                </div>
                <div class="form-group">
                    <label for="PermanentPostalCode">Postal Code</label>
                    <input type="text" id="PermanentPostalCode" name="PermanentPostalCode">
                </div>
                <div class="form-group">
                    <label for="PermanentCity">Country</label>
                    <input type="text" id="PermanentCountry" name="PermanentCountry">
                </div>
            </div>
            
            <h3>Temporary Address</h3>
<div class="form-row checkbox-row">
    <label for="sameAsPermanent" class="checkbox-label">
    <span>Same as Permanent Address</span>
        <input type="checkbox" id="sameAsPermanent" name="sameAsPermanent">
        
    </label>
</div>
            
  
            <div class="form-row">
            	
                <div class="form-group">
                    <label for="TemporaryStreet1">Address Line 1</label>
                    <input type="text" id="TemporaryStreet1" name="TemporaryStreet1">
                </div>
                <div class="form-group">
                    <label for="TemporaryStreet2">Address Line 2</label>
                    <input type="text" id="TemporaryStreet2" name="TemporaryStreet2">
                </div>
                <div class="form-group">
                    <label for="TemporaryCity">City</label>
                    <input type="text" id="TemporaryCity" name="TemporaryCity">
                </div>
            </div>
            
            <div class="form-row">
                <div class="form-group">
                    <label for="TemporaryState">State</label>
                    <input type="text" id="TemporaryState" name="TemporaryState">
                </div>
                <div class="form-group">
                    <label for="TemporaryPostalCode">Postal Code</label>
                    <input type="text" id="TemporaryPostalCode" name="TemporaryPostalCode">
                </div>
                <div class="form-group">
                    <label for="TemporaryCity">Country</label>
                    <input type="text" id="TemporaryCountry" name="TemporaryCountry">
                </div>
            </div>
            
            <hr>
            
            <h3>Contact Number</h3>
            <div class="form-row">
                <div class="form-group">
                    <label for="Mobile">Mobile</label>
                    <input type="text" id="Mobile" name="Mobile">
                </div>
                <div class="form-group">
                    <label for="Home">Home</label>
                    <input type="text" id="Home" name="Home">
                </div>
            </div>
            
            <h3>Emergency Contact</h3>
            <div class="form-row">
                <div class="form-group">
                    <label for="EmergencyName">Emergency Contact Name</label>
                    <input type="text" id="EmergencyName" name="EmergencyName">
                </div>
                <div class="form-group">
                    <label for="Relation">Relation</label>
                    <input type="text" id="Relation" name="Relation">
                </div>
                <div class="form-group">
                    <label for="EmergencyMobile">Mobile</label>
                    <input type="text" id="emergencyMobile" name="EmergencyMobile">
                </div>
            </div>
            
            <hr> 
            
            <h3>Email</h3>
            <div class="form-row">
                <div class="form-group">
                    <label for="PersonalEmail">Personal Email</label>
                    <input type="email" id="PersonalEmail" name="PersonalEmail">
                </div>
                <div class="form-group">
                    <label for="WorkEmail">Work Email</label>
                    <input type="email" id="WorkEmail" name="WorkEmail">
                </div>
            </div>
            
        </div>
        <div class="content J">
            <!-- Job content -->
            <h2>Employment Detail</h2>
            <hr>
            <div class="form-row">
                <div class="form-group">
                    <label for="JoinedDate">Joined Date</label>
                    <input type="Date" id="JoinedDate" name="JoinedDate">
                </div>
                <div class="form-group">     
                    <label for="JobTitle">Job Title</label> 
                    <select id="JobTitle" name="JobTitle">
                            <option value="">Select Job Title</option>
                            <% for (Roles r : JobTitle) { %>
                            <option value="<%= r.getRoleId() %>"><%= r.getRoleName() %></option>
                            <% } %>
                        </select>
                        
                </div>
            </div>
            <div class="form-group">
            <label for="Location">Location</label>
            <input type="text" id="Location" name="Location">
            </div>
        </div>
        
        <div class="content UC">
            
            <h2>User Credentials</h2>
            <hr>
            <div class="form-row">
                <div class="form-group">
                    <label for="Username">Username</label>
                    <input type="text" id="Username" name="Username">
                </div>
            </div>
            <div class="form-row">
            
            <div class="form-group">
                    <label for="Password">Password</label>
                    <input type="password" id="Password" name="Password">
                </div>
                <div class="form-group">
                    <label for="ConfirmPassword">Confirm Password</label>
                    <input type="password" id="ConfirmPassword" name="ConfirmPassword">
                </div>
            </div>
                            
        </div>
        
        <div class="content RT">
            <!-- Report-to content -->
            <h2>Report To</h2>
            <hr>
        </div>
    </div>
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
	
	
	function showDiv(divClass) {
	      const allDivs = document.querySelectorAll('.content');
	      allDivs.forEach(div => div.style.display = 'none');
	      
	      const selectedDiv = document.querySelector(`.${divClass}`);
	      if (selectedDiv) {
	        selectedDiv.style.display = 'block';
	      }
	    }

	    // Initial state: Show AAA content
	    document.addEventListener('DOMContentLoaded', () => {
	      showDiv('PD');
	    });

	    
	    document.addEventListener('DOMContentLoaded', function() {
	    	  const sameAsPermanentCheckbox = document.getElementById('sameAsPermanent');
	    	  const permanentFields = ['Street1', 'Street2', 'City', 'State', 'PostalCode', 'Country'];

	    	  sameAsPermanentCheckbox.addEventListener('change', function() {
	    	    permanentFields.forEach(field => {
	    	      const permanentField = document.getElementById('Permanent' + field);
	    	      const temporaryField = document.getElementById('Temporary' + field);
	    	      
	    	      if (this.checked) {
	    	        temporaryField.value = permanentField.value;
	    	        temporaryField.disabled = true;
	    	      } else {
	    	        temporaryField.value = '';
	    	        temporaryField.disabled = false;
	    	      }
	    	    });
	    	  });
	    	}); 	
	    
	    
	</script>

</body>
</html>