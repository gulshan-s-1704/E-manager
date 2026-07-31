package com.ecommerce.servlet;

import com.ecommerce.dao.ProductDAO;
import com.ecommerce.model.CartItem;
import com.ecommerce.model.Product;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.LinkedHashMap;
import java.util.Map;

/**
 * Shopping Cart System - stored in the HttpSession as a Map<productId, CartItem>.
 *   GET  /cart                          -> view cart
 *   POST /cart (action=add)             -> add product (checks live stock)
 *   POST /cart (action=update)          -> change quantity
 *   POST /cart (action=remove)          -> remove line item
 *   POST /cart (action=clear)           -> empty cart
 */
@WebServlet("/cart")
@SuppressWarnings("unchecked")
public class CartServlet extends HttpServlet {

    private final ProductDAO productDAO = new ProductDAO();

    private Map<Integer, CartItem> getCart(HttpSession session) {
        Map<Integer, CartItem> cart = (Map<Integer, CartItem>) session.getAttribute("cart");
        if (cart == null) {
            cart = new LinkedHashMap<>();
            session.setAttribute("cart", cart);
        }
        return cart;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(true);
        req.setAttribute("cartItems", getCart(session).values());
        req.getRequestDispatcher("/cart.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(true);
        Map<Integer, CartItem> cart = getCart(session);
        String action = req.getParameter("action");

        try {
            switch (action) {
                case "add": {
                    int productId = Integer.parseInt(req.getParameter("productId"));
                    int qty = Integer.parseInt(req.getParameter("quantity"));
                    Product product = productDAO.getProductById(productId);

                    if (product == null || product.getStockQuantity() < qty) {
                        req.setAttribute("cartError", "Sorry, insufficient stock for " +
                                (product != null ? product.getName() : "this product") + ".");
                    } else if (cart.containsKey(productId)) {
                        CartItem existing = cart.get(productId);
                        int newQty = existing.getQuantity() + qty;
                        if (newQty > product.getStockQuantity()) {
                            req.setAttribute("cartError", "Cannot add more than available stock.");
                        } else {
                            existing.setQuantity(newQty);
                        }
                    } else {
                        cart.put(productId, new CartItem(productId, product.getName(),
                                product.getPrice(), qty, product.getImageUrl()));
                    }
                    break;
                }
                case "update": {
                    int productId = Integer.parseInt(req.getParameter("productId"));
                    int qty = Integer.parseInt(req.getParameter("quantity"));
                    if (cart.containsKey(productId)) {
                        if (qty <= 0) {
                            cart.remove(productId);
                        } else {
                            cart.get(productId).setQuantity(qty);
                        }
                    }
                    break;
                }
                case "remove": {
                    int productId = Integer.parseInt(req.getParameter("productId"));
                    cart.remove(productId);
                    break;
                }
                case "clear": {
                    cart.clear();
                    break;
                }
                default:
                    break;
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }

        resp.sendRedirect(req.getContextPath() + "/cart");
    }
}
