package com.emp.servlets;

import java.io.IOException;
import java.sql.Connection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.emp.dao.EmpDao;
import com.emp.entities.Employees;
import com.emp.entities.Leaves;
import com.emp.jdbc.DBConnect;

@WebServlet("/applyLeaveFor")
public class ApplyLeaveForServlet extends HttpServlet{

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		HttpSession ses = req.getSession();
		String role = (String)ses.getAttribute("role");
		int empid = Integer.parseInt(req.getParameter("employeeid"));

		String from_date = req.getParameter("fromDate");
		String to_date = req.getParameter("toDate");

		try {
			Connection con = DBConnect.getConnection();
			EmpDao empDao = new EmpDao(con);

			Leaves lev = new Leaves();
			lev.setEmployeeID(empid);
			lev.setFromDate(req.getParameter("fromDate"));
			lev.setToDate(req.getParameter("toDate"));
			lev.setLeaveType(req.getParameter("leaveType"));
			lev.setAppliedReason(req.getParameter("reason"));
			lev.setLeaveStatus("Approved");
			lev.setApprovedBy(((Employees)ses.getAttribute("employee")).getEmpId());

			int totalDays = empDao.validateLeaves(req.getParameter("fromDate"), req.getParameter("toDate"));

			if(empDao.getAvailableLeaves(empid) >= totalDays)
			{
				lev.setTotalDays(totalDays);
				boolean f = empDao.getLeave(empid,from_date,to_date);
				//			System.out.println("boolean value : "+f);
				if(f)
				{
					req.setAttribute("msg","AlreadyLeaveApplied");
					req.getRequestDispatcher("applyLeave.jsp").forward(req, resp);
				}else {
					int leaveid = empDao.applyLeaveFor(lev);
					if(leaveid > 0)
					{
						if(empDao.updateLeavestock(leaveid))
						{
							req.setAttribute("msg","Success");
							req.getRequestDispatcher("applyLeaveFor.jsp").forward(req, resp);
							//						resp.sendRedirect("applyLeave.jsp?message=Leave aaplied successfully!!!");
						}else
						{
							req.setAttribute("msg","Error");
							req.getRequestDispatcher("applyLeaveFor.jsp").forward(req, resp);
							//							resp.sendRedirect("applyLeave.jsp?message=Something went wrong!!!");
						}
					}else
					{
						req.setAttribute("msg","LeaveStockError");
						req.getRequestDispatcher("applyLeaveFor.jsp").forward(req, resp);
						//				resp.sendRedirect("applyLeave.jsp?message=Leave not applied !!!");
					}
				}
			}else
			{
				String selectedOption = req.getParameter("Options");
				int leaveid=0;
				if (selectedOption != null)
				{
					switch (selectedOption) {
					case "option1":
						// Handle Option 1
						lev.setTotalDays(totalDays);
						
						leaveid = empDao.applyLeaveFor(lev);
						if(leaveid > 0)
						{
							if(empDao.updateLeavestock2(leaveid,totalDays))
							{
								req.setAttribute("msg","Success");
								req.getRequestDispatcher("applyLeaveFor.jsp").forward(req, resp);
								//						resp.sendRedirect("applyLeave.jsp?message=Leave aaplied successfully!!!");
							}else
							{
								req.setAttribute("msg","Error");
								req.getRequestDispatcher("applyLeaveFor.jsp").forward(req, resp);
								//							resp.sendRedirect("applyLeave.jsp?message=Something went wrong!!!");
							}
						}else
						{
							req.setAttribute("msg","LeaveStockError");
							req.getRequestDispatcher("applyLeaveFor.jsp").forward(req, resp);
							//				resp.sendRedirect("applyLeave.jsp?message=Leave not applied !!!");
						}
						
						break;
					case "option2":
						// Handle Option 2
						lev.setTotalDays(totalDays);
						
						leaveid = empDao.applyLeaveFor(lev);
						if(leaveid > 0)
						{
							if(empDao.updateLeavestock2(leaveid,empDao.getAvailableLeaves(empid)))
							{
								req.setAttribute("msg","Success");
								req.getRequestDispatcher("applyLeaveFor.jsp").forward(req, resp);
								//						resp.sendRedirect("applyLeave.jsp?message=Leave aaplied successfully!!!");
							}else
							{
								req.setAttribute("msg","Error");
								req.getRequestDispatcher("applyLeaveFor.jsp").forward(req, resp);
								//							resp.sendRedirect("applyLeave.jsp?message=Something went wrong!!!");
							}
						}else
						{
							req.setAttribute("msg","LeaveStockError");
							req.getRequestDispatcher("applyLeaveFor.jsp").forward(req, resp);
							//				resp.sendRedirect("applyLeave.jsp?message=Leave not applied !!!");
						}
						
						break;
					default: break;
					}

					
				}
				else {
					req.setAttribute("msg","OutOfLeaves");
					req.getRequestDispatcher("applyLeaveFor.jsp").forward(req, resp);
					//			resp.sendRedirect("applyLeave.jsp?message=out of days!!!");
				}
			}





		}catch(Exception e)
		{
			e.printStackTrace();
		}	
	}

}
