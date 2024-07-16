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
<title>Leave</title>

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

.flatpickr-day.holiday {
	background-color: red !important;
	color: red !important;
}

.flatpickr-day.disabled {
	background-color: red !important;
	color: red !important;
	opacity: 0.7;
}
</style>



<script>
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

	<div id="error-message" class="error-message">
		<span><i class="fas fa-exclamation-triangle"></i></span>
		<p>Something Went Wrong!</p>
	</div>

	<div id="success-message" class="success-message">
		<span><i class="fas fa-check-circle"></i></span>
		<p>Leave Applied Successfully...</p>
	</div>

	<div id="leaveStockError-message" class="leaveStockError-message">
		<i class="fas fa-times-circle"></i>
		<p>Holiday Deleted Successfully..!!!</p>
	</div>

	<div id="outOfLeaves-message" class="outOfLeaves-message">
		<i class="fas fa-times-circle"></i>
		<p>Check Balance Leaves...!!!</p>
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
			<h1>Leave / Apply Leave</h1>
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
			<h2>Apply Leave</h2>
			<hr>
			<form class="leave-form" action="applyLeave" method="post">
				<div class="form-left">
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
						<p><%= empDao.getAvailableLeaves(emp.getEmpId()) %></p>
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