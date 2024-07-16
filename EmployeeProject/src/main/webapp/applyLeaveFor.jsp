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

/*  form container starts  */
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
/form container ends/



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
            fetch(getAvailableLeaves?empid=${empId})
                .then(response => response.json())
                .then(data => {
                    // Update the available leaves display
                    document.getElementById("availableLeaves").innerText = ${data.availableLeaves};
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