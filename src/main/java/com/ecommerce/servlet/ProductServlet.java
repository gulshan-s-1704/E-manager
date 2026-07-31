package com.ecommerce.servlet;

import com.ecommerce.dao.CategoryDAO;
import com.ecommerce.dao.ProductDAO;
import com.ecommerce.model.Product;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 * Public-facing Product Catalog:
 *   /products                     -> list all active products
 *   /products?categoryId=2        -> filter by category
 *   /products?keyword=phone       -> search
 *   /products?action=view&id=5    -> single product detail page
 */
@WebServlet("/products")
public class ProductServlet extends HttpServlet {

    private final ProductDAO productDAO = new ProductDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            String action = req.getParameter("action");

            if ("view".equals(action)) {
                int id = Integer.parseInt(req.getParameter("id"));
                Product product = productDAO.getProductById(id);
                if (product == null) {
                    resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Product not found");
                    return;
                }
                req.setAttribute("product", product);
                req.getRequestDispatcher("/productDetail.jsp").forward(req, resp);
                return;
            }

            String keyword = req.getParameter("keyword");
            String categoryIdParam = req.getParameter("categoryId");

            List<Product> products;
            if (keyword != null && !keyword.trim().isEmpty()) {
                products = productDAO.searchProducts(keyword.trim());
            } else if (categoryIdParam != null && !categoryIdParam.isEmpty()) {
                products = productDAO.getProductsByCategory(Integer.parseInt(categoryIdParam));
            } else {
                products = productDAO.getAllProducts();
            }

            req.setAttribute("products", products);
            req.setAttribute("categories", categoryDAO.getAllCategories());
            req.setAttribute("keyword", keyword);
            req.setAttribute("selectedCategoryId", categoryIdParam);
            req.getRequestDispatcher("/products.jsp").forward(req, resp);

        } catch (Exception e) {
            throw new ServletException("Error loading products", e);
        }
    }
}
