package com.ecommerce.servlet;

import com.ecommerce.dao.OrderDAO;
import com.ecommerce.model.CartItem;
import com.ecommerce.model.Customer;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * Checkout / Order Processing:
 *   GET  /checkout       -> show shipping + payment form (pre-filled from profile)
 *   POST /checkout       -> place order (transactional), clear cart, show confirmation
 */
@WebServlet("/checkout")
@SuppressWarnings("unchecked")
public class CheckoutServlet extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        Customer customer = session != null ? (Customer) session.getAttribute("customer") : null;
        if (customer == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp?redirect=checkout");
            return;
        }

        Map<Integer, CartItem> cart = (Map<Integer, CartItem>) session.getAttribute("cart");
        if (cart == null || cart.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/cart");
            return;
        }

        req.setAttribute("cartItems", cart.values());
        req.setAttribute("customer", customer);
        req.getRequestDispatcher("/checkout.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        Customer customer = session != null ? (Customer) session.getAttribute("customer") : null;
        if (customer == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        Map<Integer, CartItem> cart = (Map<Integer, CartItem>) session.getAttribute("cart");
        if (cart == null || cart.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/cart");
            return;
        }

        String shippingAddress = req.getParameter("shippingAddress");
        String paymentMethod = req.getParameter("paymentMethod"); // CARD, UPI, COD, NET_BANKING

        try {
            List<CartItem> items = new ArrayList<>(cart.values());
            int orderId = orderDAO.placeOrder(customer.getCustomerId(), items, shippingAddress, paymentMethod);

            cart.clear(); // empty the cart after successful order

            req.setAttribute("orderId", orderId);
            req.getRequestDispatcher("/orderConfirmation.jsp").forward(req, resp);
        } catch (Exception e) {
            req.setAttribute("checkoutError", "Order could not be placed: " + e.getMessage());
            req.setAttribute("cartItems", cart.values());
            req.setAttribute("customer", customer);
            req.getRequestDispatcher("/checkout.jsp").forward(req, resp);
        }
    }
}
