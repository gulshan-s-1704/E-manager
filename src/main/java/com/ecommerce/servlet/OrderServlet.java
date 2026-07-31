package com.ecommerce.servlet;

import com.ecommerce.dao.OrderDAO;
import com.ecommerce.model.Customer;
import com.ecommerce.model.Order;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Customer-facing order history & tracking:
 *   GET /orders             -> list this customer's orders
 *   GET /orders?id=42       -> detailed order + tracking status
 */
@WebServlet("/orders")
public class OrderServlet extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        Customer customer = session != null ? (Customer) session.getAttribute("customer") : null;
        if (customer == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        try {
            String idParam = req.getParameter("id");
            if (idParam != null) {
                Order order = orderDAO.getOrderById(Integer.parseInt(idParam));
                if (order == null || (order.getCustomerId() != customer.getCustomerId() && !customer.isAdmin())) {
                    resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Not your order");
                    return;
                }
                req.setAttribute("order", order);
                req.getRequestDispatcher("/orderTracking.jsp").forward(req, resp);
            } else {
                req.setAttribute("orders", orderDAO.getOrdersByCustomer(customer.getCustomerId()));
                req.getRequestDispatcher("/myOrders.jsp").forward(req, resp);
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
