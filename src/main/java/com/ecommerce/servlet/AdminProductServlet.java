package com.ecommerce.servlet;

import com.ecommerce.dao.CategoryDAO;
import com.ecommerce.dao.InventoryDAO;
import com.ecommerce.dao.ProductDAO;
import com.ecommerce.model.Product;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;

/**
 * Admin-only Product & Inventory management (CRUD + restock).
 *   GET  /admin/products                 -> list + form
 *   GET  /admin/products?action=edit&id=  -> edit form
 *   POST /admin/products (action=add)     -> create product
 *   POST /admin/products (action=update)  -> update product
 *   POST /admin/products (action=delete)  -> deactivate product
 *   POST /admin/products (action=restock) -> add stock
 */
@WebServlet("/admin/products")
public class AdminProductServlet extends HttpServlet {

    private final ProductDAO productDAO = new ProductDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();
    private final InventoryDAO inventoryDAO = new InventoryDAO();

    private boolean isAdmin(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        return session != null && session.getAttribute("customer") != null
                && (Boolean.TRUE.equals(session.getAttribute("isAdmin")));
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        if (!isAdmin(req)) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }
        try {
            String action = req.getParameter("action");
            if ("edit".equals(action)) {
                int id = Integer.parseInt(req.getParameter("id"));
                req.setAttribute("product", productDAO.getProductById(id));
            }
            req.setAttribute("products", productDAO.getAllProducts());
            req.setAttribute("categories", categoryDAO.getAllCategories());
            req.setAttribute("lowStock", inventoryDAO.getLowStockProducts());
            req.getRequestDispatcher("/admin/products.jsp").forward(req, resp);
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
            String action = req.getParameter("action");
            switch (action) {
                case "add": {
                    Product p = new Product();
                    p.setSku(req.getParameter("sku"));
                    p.setName(req.getParameter("name"));
                    p.setDescription(req.getParameter("description"));
                    p.setPrice(new BigDecimal(req.getParameter("price")));
                    p.setCategoryId(Integer.parseInt(req.getParameter("categoryId")));
                    p.setImageUrl(req.getParameter("imageUrl"));
                    int initialStock = Integer.parseInt(req.getParameter("initialStock"));
                    productDAO.addProduct(p, initialStock);
                    break;
                }
                case "update": {
                    Product p = new Product();
                    p.setProductId(Integer.parseInt(req.getParameter("productId")));
                    p.setName(req.getParameter("name"));
                    p.setDescription(req.getParameter("description"));
                    p.setPrice(new BigDecimal(req.getParameter("price")));
                    p.setCategoryId(Integer.parseInt(req.getParameter("categoryId")));
                    p.setImageUrl(req.getParameter("imageUrl"));
                    productDAO.updateProduct(p);
                    break;
                }
                case "delete": {
                    int id = Integer.parseInt(req.getParameter("productId"));
                    productDAO.deactivateProduct(id);
                    break;
                }
                case "restock": {
                    int id = Integer.parseInt(req.getParameter("productId"));
                    int qty = Integer.parseInt(req.getParameter("quantity"));
                    inventoryDAO.restock(id, qty);
                    break;
                }
                default:
                    break;
            }
            resp.sendRedirect(req.getContextPath() + "/admin/products");
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
