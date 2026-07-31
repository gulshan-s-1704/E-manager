package com.ecommerce.servlet;

import com.ecommerce.dao.OrderDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Admin Order Tracking Dashboard:
 *   GET  /admin/orders                       -> list every order in the system
 *   GET  /admin/orders?id=42                  -> view single order details
 *   POST /admin/orders (action=updateStatus)  -> move order through PENDING -> CONFIRMED -> SHIPPED -> DELIVERED
 */
@WebServlet("/admin/orders")
public class AdminOrderServlet extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAO();

    private boolean isAdmin(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        return session != null && Boolean.TRUE.equals(session.getAttribute("isAdmin"));
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        if (!isAdmin(req)) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }
        try {
            String idParam = req.getParameter("id");
            if (idParam != null) {
                req.setAttribute("order", orderDAO.getOrderById(Integer.parseInt(idParam)));
                req.getRequestDispatcher("/admin/orderDetail.jsp").forward(req, resp);
            } else {
                req.setAttribute("orders", orderDAO.getAllOrders());
                req.getRequestDispatcher("/admin/orders.jsp").forward(req, resp);
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        if (!isAdmin(req)) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }
        try {
            int orderId = Integer.parseInt(req.getParameter("orderId"));
            String newStatus = req.getParameter("status");
            orderDAO.updateStatus(orderId, newStatus);
            resp.sendRedirect(req.getContextPath() + "/admin/orders?id=" + orderId);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
