package com.ecommerce.servlet;

import com.ecommerce.dao.CustomerDAO;
import com.ecommerce.model.Customer;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Handles customer authentication:
 *   POST /customer?action=register
 *   POST /customer?action=login
 *   GET  /customer?action=logout
 */
@WebServlet("/customer")
public class CustomerServlet extends HttpServlet {

    private final CustomerDAO customerDAO = new CustomerDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");
        try {
            if ("register".equals(action)) {
                handleRegister(req, resp);
            } else if ("login".equals(action)) {
                handleLogin(req, resp);
            } else {
                resp.sendRedirect(req.getContextPath() + "/index.jsp");
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String action = req.getParameter("action");
        if ("logout".equals(action)) {
            HttpSession session = req.getSession(false);
            if (session != null) session.invalidate();
            resp.sendRedirect(req.getContextPath() + "/index.jsp");
        } else {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
        }
    }

    private void handleRegister(HttpServletRequest req, HttpServletResponse resp)
            throws Exception {
        Customer c = new Customer();
        c.setFullName(req.getParameter("fullName"));
        c.setEmail(req.getParameter("email"));
        c.setPhone(req.getParameter("phone"));
        c.setAddress(req.getParameter("address"));
        String password = req.getParameter("password");

        int newId = customerDAO.register(c, password);
        if (newId == -1) {
            req.setAttribute("error", "An account with this email already exists.");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
            return;
        }
        resp.sendRedirect(req.getContextPath() + "/login.jsp?registered=true");
    }

    private void handleLogin(HttpServletRequest req, HttpServletResponse resp)
            throws Exception {
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        Customer c = customerDAO.login(email, password);

        if (c == null) {
            req.setAttribute("error", "Invalid email or password.");
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
            return;
        }

        HttpSession session = req.getSession(true);
        session.setAttribute("customer", c);
        session.setAttribute("isAdmin", c.isAdmin());
        session.setMaxInactiveInterval(30 * 60); // 30 minutes

        if (c.isAdmin()) {
            resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
        } else {
            resp.sendRedirect(req.getContextPath() + "/products");
        }
    }
}
