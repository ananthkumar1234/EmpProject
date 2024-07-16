document.addEventListener('DOMContentLoaded', function() {
            const sidebar = document.getElementById('sidebar');
            const toggleBtn = document.getElementById('toggleSidebar');
            const chevronLeft = toggleBtn.querySelector('.fa-chevron-left');
            const chevronRight = toggleBtn.querySelector('.fa-chevron-right');
            const body = document.body;

            toggleBtn.addEventListener('click', function() {
                sidebar.classList.toggle('collapsed');
                body.classList.toggle('sidebar-collapsed');
                chevronLeft.classList.toggle('show');
                chevronRight.classList.toggle('show');
            });
        });
        
        document.addEventListener('DOMContentLoaded', function() {
    const dropbtn = document.querySelector('.dropbtn');
    const dropdownContent = document.querySelector('.dropdown-content');

    dropbtn.addEventListener('click', function() {
        dropdownContent.classList.toggle('show');
    });

    window.addEventListener('click', function(event) {
        if (!event.target.matches('.dropbtn')) {
            if (dropdownContent.classList.contains('show')) {
                dropdownContent.classList.remove('show');
            }
        }
    });
});

function changePassword() {
    // Implement your change password logic here
    alert('Change password functionality to be implemented');
}



// to highlight the active tabs(anchor tag links) 

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

