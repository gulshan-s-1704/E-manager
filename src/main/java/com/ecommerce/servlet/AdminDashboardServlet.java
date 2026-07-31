package com.ecommerce.servlet;

import com.ecommerce.dao.AnalyticsDAO;
import com.ecommerce.dao.InventoryDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Admin dashboard home: revenue, order/customer counts, best sellers,
 * daily revenue trend, order-status breakdown and low-stock alerts.
 *   GET /admin/dashboard
 */
@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {

    private final AnalyticsDAO analyticsDAO = new AnalyticsDAO();
    private final InventoryDAO inventoryDAO = new InventoryDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || !Boolean.TRUE.equals(session.getAttribute("isAdmin"))) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }
        try {
            req.setAttribute("totalRevenue", analyticsDAO.getTotalRevenue());
            req.setAttribute("totalOrders", analyticsDAO.getTotalOrderCount());
            req.setAttribute("totalCustomers", analyticsDAO.getTotalCustomerCount());
            req.setAttribute("topProducts", analyticsDAO.getTopSellingProducts(5));
            req.setAttribute("dailyRevenue", analyticsDAO.getDailyRevenue(14));
            req.setAttribute("statusBreakdown", analyticsDAO.getOrderStatusBreakdown());
            req.setAttribute("lowStock", inventoryDAO.getLowStockProducts());
            req.getRequestDispatcher("/admin/dashboard.jsp").forward(req, resp);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
