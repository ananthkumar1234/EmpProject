<%@page import="org.apache.taglibs.standard.tag.common.xml.ForEachTag"%>
<%@page import="org.apache.jasper.tagplugins.jstl.core.ForEach"%>
<%@ page import="java.util.*"%>
<%@ page import="com.emp.entities.Attendance"%>
<%@ page import="com.emp.entities.Employees"%>
<%@ page import="com.emp.entities.Holidays"%>
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
	
	<link rel="stylesheet"
	href="https://npmcdn.com/flatpickr/dist/flatpickr.min.css">
<script src="https://npmcdn.com/flatpickr/dist/flatpickr.min.js"></script>
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
	background: linear-gradient(to left,#FF9671 ,#FFC75F );
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
	background: linear-gradient(to left, #FF9671, #FFC75F);;
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
}

@media screen and (max-width: 600px) {
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

/*  form container starts  */
.leave-form-container {
	background-color: #ffffff;
	border-radius: 8px;
	box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
	padding: 20px;
	max-width: 100%;
	margin: 0 auto;
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

select, input[type="date"], input[type="text"], textarea {
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
/*form container ends*/

/*----------------------- messages starts------------------------------------------------*/
.error-message, .outOfLeaves-message, .leaveStockError-message  {
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
	background-color: rgba(144, 238, 144, 0.8); /* More transparency */
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

.error-message p, .success-message p, .outOfLeaves-message p, .leaveStockError-message p {
	font-weight: bold;
	margin: 8px 0;
	font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
	/* More modern font */
}

.error-message p:first-child, .success-message p:first-child,
	.outOfLeaves-message p:first-child, .leaveStockError-message p:first-child {
	font-weight: bold;
	font-size: 20px;
	text-transform: uppercase;
	letter-spacing: 1px;
}

.error-message i, .success-message i, .outOfLeaves-message i, .leaveStockError-message i {
	font-size: 24px;
	margin-right: 10px;
	vertical-align: middle;
}

.error-message.show, .success-message.show, .outOfLeaves-message.show, .leaveStockError-message.show {
	top: 30px;
	animation: shake 0.82s cubic-bezier(.36, .07, .19, .97) both;
}

/*================================= messages ===============================================ends*/




</style>



<script>
        function updateEmpIdAndFetchLeaves() {
            const empId = document.getElementById("employeeid").value;

            if (empId) {
                // Update the empid variable
                document.getElementById("empid").value = empId;

                // Fetch available leaves based on the empid
                fetchAvailableLeaves(empId);
            }
        }

        function fetchAvailableLeaves(empId) {
            // Assuming you have a servlet or endpoint that returns available leaves
            fetch(`getAvailableLeaves?empid=${empId}`)
                .then(response => response.json())
                .then(data => {
                    // Update the available leaves display
                    document.getElementById("availableLeaves").innerText = `${data.availableLeaves}`;
                })
                .catch(error => console.error('Error fetching available leaves:', error));
        }
        
        
        
        document.addEventListener("DOMContentLoaded", function() {
            flatpickr("#fromDate", {
            });
            flatpickr("#toDate", {
            });
        });
        
        
     // Displaying messages for different scenarios
        function showErrorMessage() {
        	const warningMessage = document.getElementById('error-message');
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
        		
        		
        	function showLeaveStockErrorMessage() {
        		const warningMessage = document.getElementById('leaveStockError-message');
        		warningMessage.classList.add('show');

        		setTimeout(() => {
        		    warningMessage.classList.remove('show');
        		}, 4000);
        		}
        	
        	
        	function showOutOfLeavesMessage() {
        		const warningMessage = document.getElementById('outOfLeaves-message');
        		warningMessage.classList.add('show');

        		setTimeout(() => {
        		    warningMessage.classList.remove('show');
        		}, 4000);
        		}


        	// Check for servlet error
        	window.onload = function() {
        	<% if (request.getAttribute("msg")!=null && request.getAttribute("msg").equals("Error")) { %> showErrorMessage();
        	<% } 
        	else if (request.getAttribute("msg")!=null && request.getAttribute("msg").equals("Success")){%> showSuccessMessage();
        	<%}
        	else if (request.getAttribute("msg")!=null && request.getAttribute("msg").equals("LeaveStockError")){%> showLeaveStockErrorMessage();
        	<%}
        	else if (request.getAttribute("msg")!=null && request.getAttribute("msg").equals("OutOfLeaves")){%> showOutOfLeavesMessage();
        	<%}%>}
        
        
    </script>


<body>


<div id="error-message" class="error-message">
		<span><i class="fas fa-exclamation-triangle"></i></span>
		<p>Something Went Wrong...!!!</p>
	</div>

	<div id="success-message" class="success-message">
		<span><i class="fas fa-check-circle"></i></span>
		<p>Leave Applied Successfully...</p>
	</div>

	<div id="leaveStockError-message" class="leaveStockError-message">
		<i class="fas fa-exclamation-triangle"></i>
		<p>Some internal problem...!!!</p>
	</div>

	<div id="outOfLeaves-message" class="outOfLeaves-message">
		<i class="fas fa-times-circle"></i>
		<p>Check Balance Leaves...!!!</p>
	</div>



	<%
        Connection con = DBConnect.getConnection();
        EmpDao empDao = new EmpDao(con);
        
        int empid = 0;
        
        List<Employees> employees=new ArrayList<>();
        
        List<Holidays> holidays = empDao.getHolidays();
        HttpSession sess = request.getSession();
        Employees emp = (Employees)sess.getAttribute("employee");
        String role = (String)sess.getAttribute("role");
        int mid= ((Employees)sess.getAttribute("employee")).getEmpId();
        
        if("HR".equals(role))
        {
        	employees = empDao.getEmployees();
        }
        if("Manager".equals(role))
        {
        	employees = empDao.getReportees(mid);
        }
    %>
    
    <input type="hidden" id="empid" name="empid" value="">

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
			<h1>Leave / Apply Leave For</h1>
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
			<h2>Apply Leave For</h2>
			<hr>
			<form class="leave-form" action="applyLeaveFor" method="post">
				<div class="form-left">
					<div class="form-group">
						<label for="employeeid">Employee Name*</label> <select id="employeeid" name="employeeid" required onchange="updateEmpIdAndFetchLeaves()">
                            <option value="">Select Employee</option>
                            <% for (Employees r : employees) { %>
                            <option value="<%= r.getEmpId() %>"><%= r.getFname() + " " + r.getLname() %></option>
                            <% } %>
                        </select>
					</div>
					<div class="form-row">




						<div class="form-group">
							<label for="fromDate">From Date*</label> <input type="text"
								id="fromDate" name="fromDate" required>
						</div>
						<div class="form-group">
							<label for="toDate">To Date*</label> <input type="text"
								id="toDate" name="toDate" required>
						</div>
					</div>
					<div class="form-group">
						<label for="leaveType">Leave Type*</label> <select id="leaveType"
							name="leaveType" required>
							<option value="">-- Select --</option>
							<option value="casual">Casual Leave</option>
							<option value="sick">Sick Leave</option>
							<!-- Add more options as needed -->
						</select>
					</div>
					<div class="form-group">
						<label for="comments">Reason</label>
						<textarea id="comments" name="reason" rows="4"></textarea>
					</div>
				</div>
				<div class="form-right">
                    <div class="leave-balance">
                        <label>Leave Balance</label>
                        <p id="availableLeaves"> </p>
                    </div>
                </div>
				<div class="form-footer">
					<p class="required-note">* Required</p>
					<button type="submit" class="apply-btn">Apply</button>
				</div>
			</form>
		</div>
		
	</div>
	
	<script>
document.addEventListener("DOMContentLoaded", function() {
    // Ensure holidays are converted to a proper JavaScript array
    const holidays = <%= holidays.stream()
                                   .map(Holidays::getDate)
                                   .map(date -> "\"" + date.toString() + "\"")
                                   .collect(java.util.stream.Collectors.toList()) %>;

    console.log("Holidays: ", holidays); // Debugging line

    // Convert the holiday strings to Date objects
    const disableDates = holidays.map(dateStr => new Date(dateStr));

    console.log("Disable Dates: ", disableDates); // Debugging line

    const disableWeekendsAndHolidays = function(date) {
        // Disable weekends
        if (date.getDay() === 0 || date.getDay() === 6) {
            return true;
        }
        // Disable holidays
        return disableDates.some(disabledDate => {
            return date.toDateString() === disabledDate.toDateString();
        });
    };

    const highlightHolidays = function(selectedDates, dateStr, instance) {
        instance.calendarContainer.querySelectorAll(".flatpickr-day").forEach(dayElem => {
            const date = new Date(dayElem.dateObj);
            if (disableDates.some(disabledDate => date.toDateString() === disabledDate.toDateString())) {
                dayElem.classList.add("holiday");
            }
        });
    };

    flatpickr("#fromDate", {
        disable: [disableWeekendsAndHolidays],
        onDayCreate: highlightHolidays
    });

    flatpickr("#toDate", {
        disable: [disableWeekendsAndHolidays],
        onDayCreate: highlightHolidays
    });
});
</script>

</body>
</html>