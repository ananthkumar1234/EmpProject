<%@page import="org.apache.taglibs.standard.tag.common.xml.ForEachTag"%>
<%@page import="org.apache.jasper.tagplugins.jstl.core.ForEach"%>
<%@ page import="java.util.List"%>
<%@ page import="com.emp.entities.Attendance"%>
<%@ page import="com.emp.entities.Employees"%>
<%@ page import="com.emp.jdbc.DBConnect"%>
<%@ page import="java.sql.Connection" %>
<%@ page import="com.emp.dao.EmpDao"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Change Password</title>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="script.js" defer></script>
</head>
<style>
body {
    font-family: Arial, sans-serif;
    margin: 0;
    padding: 0;
    display: flex;
    transition: padding-left 0.3s ease;
    background-color:#f5f5f5;
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
	margin-left: 250px;
	transition: margin-left 0.3s ease;
}

.header {
    background: linear-gradient(to left,#FF9671 ,#FFC75F );
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
    border-radius: 5px;
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
    background: linear-gradient(to left,#FFC75F ,#FF9671 );
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
    box-shadow: 0px 8px 16px 0px rgba(0,0,0,0.2);
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

.form-container {
    background-color: #ffffff;
    padding: 30px;
    border-radius: 10px;
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
    width: 100%;
    max-width: 94%;
}

h2 {
    margin-top: 0;
    margin-bottom: 20px;
    color: #333;
}

.form-row {
    display: flex;
    justify-content: space-between;
    margin-bottom: 20px;
}

.form-group {
    flex: 0 0 48%;
}

label {
    display: block;
    margin-bottom: 5px;
    color: #666;
}

input {
    width: 100%;
    padding: 8px;
    border: 1px solid #ddd;
    border-radius: 4px;
    box-sizing: border-box;
}

.password-hint {
    font-size: 12px;
    color: #666;
    margin-bottom: 20px;
}

.form-actions {
    display: flex;
    justify-content: flex-end;
}

button {
    padding: 10px 20px;
    border: none;
    border-radius: 20px;
    cursor: pointer;
    font-size: 14px;
}

.btn-cancel {
    background-color: #f0f0f0;
    color: #333;
    margin-right: 10px;
}

.btn-save {
    background-color: #8bc34a;
    color: white;
}

@media (max-width: 600px) {
    .form-container {
        padding: 20px;
    }
    
    .form-row {
        flex-direction: column;
    }
    
    .form-group {
        flex: 0 0 100%;
        margin-bottom: 20px;
    }
}
a {
    text-decoration: none;
    color:black;
}

</style>
<body>
    <%
        Connection con = DBConnect.getConnection();
        EmpDao empDao = new EmpDao(con);
        
        HttpSession sess = request.getSession();
        Employees emp = (Employees)sess.getAttribute("employee");
        String uname = (String)sess.getAttribute("username");
    %>

    <div class="sidebar" id="sidebar">
        <div class="logo">
            <img src="logo.png" alt="Logo">
        </div>
        <ul class="sidebar-menu">
            <li><a href="dashboard.jsp"><i class="fas fa-tachometer-alt"></i><span class="menu-text"> Dashboard</span></a></li>
            <li><i class="fas fa-user-cog"></i><span class="menu-text"> Admin</span></li>
            <li><i class="fas fa-users"></i><span class="menu-text"> PIM</span></li>
            <li><a href="applyLeave.jsp"><i class="fas fa-calendar-alt"></i><span class="menu-text"> Leave</span></a></li>
            <li><i class="fas fa-clock"></i><span class="menu-text"> Time</span></li>
            <li><i class="fas fa-user-plus"></i><span class="menu-text"> Recruitment</span></li>
            <li><i class="fas fa-id-badge"></i><span class="menu-text"> My Info</span></li>
        </ul>
    </div>
    
    <button id="toggleSidebar" class="toggle-btn">
        <i class="fas fa-chevron-left show"></i>
        <i class="fas fa-chevron-right"></i>
    </button>
    
    <div class="main-content">
        <header class="header">
            <h1>Change Password</h1>
            <div class="user-profile">
                <div class="user-dropdown">
                    <button class="dropbtn" id="userDropdown">
                        <%= emp.getFname() + " " + emp.getLname() %>
                        <i class="fas fa-caret-down"></i>
                    </button>
                    <div class="dropdown-content" id="userDropdownContent">
                        <a href="changePassword.jsp">Change Password</a>
                        <a href="login.jsp">Logout</a>
                    </div>
                </div>
            </div>
        </header>
        
        <div class="dashboard-grid">
        
        <div class="form-container">
        <h2>Update Password</h2>
        <form action="changePassword" method="post">
            <div class="form-row">
                <div class="form-group">
                    <label for="username">Username</label>
                    <input type="text" id="username" name="username" value="<%= uname %>" readonly>
                </div>
                <div class="form-group">
                    <label for="current-password">Current Password*</label>
                    <input type="password" id="current-password" name="currentPassword" required>
                </div>
            </div>
            <div class="form-row">
                <div class="form-group">
                    <label for="new-password">Password*</label>
                    <input type="password" id="new-password" name="newPassword" required>
                </div>
                <div class="form-group">
                    <label for="confirm-password">Confirm Password*</label>
                    <input type="password" id="confirm-password" name="confirmPassword" required>
                </div>
            </div>
            <p class="password-hint">For a strong password, please use a hard to guess combination of text with upper and lower case characters, symbols and numbers</p>
            <div class="form-actions">
                <button type="button" onclick="redirectToDash()" class="btn-cancel">Cancel</button>
                <button type="submit" class="btn-save">Save</button>
            </div>
        </form>
    </div>
        
        
        </div>
    </div>
    
    <script type="text/javascript">
    
    function redirectToDash(){
    	window.location.href = "dashboard.jsp"; 
    }
    
    </script>
</body>
</html>