-- ====================================================================
-- E-Manager E-Commerce Platform - Seed Data Script
-- Safe, repeatable, and idempotent seed script for 30 realistic products
-- ====================================================================

-- 1. Ensure Standard Categories Exist
INSERT INTO categories (category_id, name, description) VALUES
(1, 'Electronics', 'Smart gadgets, audio devices, computer peripherals and tech gear'),
(2, 'Fashion', 'Premium apparel, modern streetwear, footwear and everyday style'),
(3, 'Home & Lifestyle', 'Home aesthetics, ergonomic furniture, desk setups and decor'),
(4, 'Accessories', 'Everyday carry, leather goods, travel essentials and utility gear'),
(5, 'Books & Media', 'Programming, tech guides, fiction and academic literature')
ON DUPLICATE KEY UPDATE 
    name = VALUES(name), 
    description = VALUES(description);

-- 2. Insert or Update 30 Realistic Products
-- Electronics (8 products)
INSERT INTO products (sku, name, description, price, category_id, image_url, active) VALUES
('ELEC-001', 'Wireless Over-Ear Headphones', 'High-fidelity Bluetooth 5.3 headphones featuring hybrid active noise cancellation, 40mm titanium dynamic drivers, and 45-hour ultra-long battery life with rapid USB-C charging.', 2999.00, 1, 'images/products/elec_headphones.jpg', TRUE),
('ELEC-002', 'Portable Bluetooth Speaker', 'Rugged IPX7 waterproof wireless speaker delivering punchy 360-degree stereo sound, deep bass radiators, integrated speakerphone, and up to 14 hours of continuous playtime.', 1799.00, 1, 'images/products/elec_speaker.jpg', TRUE),
('ELEC-003', 'Smart Fitness Watch', 'Sleek AMOLED fitness smartwatch with 24/7 heart rate and blood oxygen monitoring, 100+ workout modes, sleep analysis, and crystal-clear Bluetooth calling.', 3499.00, 1, 'images/products/elec_smartwatch.jpg', TRUE),
('ELEC-004', 'RGB Mechanical Gaming Keyboard', 'Compact tenkeyless mechanical keyboard equipped with hot-swappable tactile brown switches, customizable per-key RGB backlighting, and durable PBT doubleshot keycaps.', 4299.00, 1, 'images/products/elec_keyboard.jpg', TRUE),
('ELEC-005', 'Ergonomic Wireless Mouse', 'Contoured ergonomic multi-device mouse featuring dual Bluetooth and 2.4GHz connectivity, silent click switches, adjustable 4000 DPI sensor, and rechargeable battery.', 1299.00, 1, 'images/products/elec_mouse.jpg', TRUE),
('ELEC-006', '7-in-1 Multiport USB-C Hub', 'Premium aluminum USB-C hub featuring 4K@60Hz HDMI output, 100W Power Delivery pass-through charging, 3 high-speed USB 3.0 ports, and SD/TF micro card reader slots.', 2199.00, 1, 'images/products/elec_usbhub.jpg', TRUE),
('ELEC-007', '20000mAh Fast Power Bank', 'High-capacity ultra-compact portable charger with 22.5W Power Delivery and Quick Charge 3.0, dual USB-A and USB-C bidirectional ports, and an intuitive LED battery display.', 1899.00, 1, 'images/products/elec_powerbank.jpg', TRUE),
('ELEC-008', '1080p Full HD Pro Webcam', 'Wide-angle crystal-clear 1080p/60fps video streaming webcam with automatic low-light correction, dual noise-cancelling microphones, and integrated magnetic privacy shutter.', 2499.00, 1, 'images/products/elec_webcam.jpg', TRUE),

-- Fashion (7 products)
('FASH-001', 'Premium Cotton Crew T-Shirt', 'Tailored regular-fit classic crewneck t-shirt crafted from 100% combed ring-spun organic cotton for supreme softness, breathable all-day comfort, and shape retention.', 699.00, 2, 'images/products/fash_tshirt.jpg', TRUE),
('FASH-002', 'Heavyweight Pullover Fleece Hoodie', 'Cozy 380 GSM cotton-poly blend fleece hoodie featuring a double-lined drawstring hood, roomy kangaroo pouch pocket, and durable ribbed spandex cuffs and hem.', 1499.00, 2, 'images/products/fash_hoodie.jpg', TRUE),
('FASH-003', 'Urban Breathable Lifestyle Sneakers', 'Lightweight everyday athletic sneakers engineered with responsive EVA cushioning midsoles, breathable knitted mesh uppers, and high-traction rubber outsoles.', 2799.00, 2, 'images/products/fash_sneakers.jpg', TRUE),
('FASH-004', 'Water-Resistant Commuter Backpack', 'Sleek 24L urban laptop backpack crafted from weatherproof 900D nylon with a dedicated padded 15.6-inch laptop compartment, luggage strap, and hidden anti-theft pocket.', 1899.00, 2, 'images/products/fash_backpack.jpg', TRUE),
('FASH-005', 'Vintage Classic Denim Trucker Jacket', 'Timeless rugged denim trucker jacket constructed with heavy-duty 100% cotton denim, button-flap chest pockets, adjustable waist tabs, and vintage indigo wash finish.', 2299.00, 2, 'images/products/fash_denim.jpg', TRUE),
('FASH-006', 'Stretch Slim-Fit Chino Trousers', 'Versatile modern slim-cut chino trousers woven with premium stretch cotton twill, tailored flat-front styling, and secure welt back pockets suitable for office or weekend wear.', 1399.00, 2, 'images/products/fash_chinos.jpg', TRUE),
('FASH-007', 'Classic Pique Knit Polo Shirt', 'Refined short-sleeve polo shirt featuring a classic 2-button placket, ribbed knit collar with contrast tipping, and airy honeycomb pique cotton knit construction.', 899.00, 2, 'images/products/fash_polo.jpg', TRUE),

-- Home & Lifestyle (8 products)
('HOME-001', 'Dimmable LED Minimalist Desk Lamp', 'Contemporary architectural desk lamp featuring touch-sensitive slider dimming, 5 adjustable color temperatures, memory function, flexible gooseneck, and USB device charging port.', 1599.00, 3, 'images/products/home_lamp.jpg', TRUE),
('HOME-002', 'Insulated Stainless Steel Water Bottle', 'Double-wall vacuum-insulated 750ml thermal flask manufactured from food-grade 18/8 stainless steel, keeping cold beverages chilled for 24h and hot drinks warm for 12h.', 799.00, 3, 'images/products/home_bottle.jpg', TRUE),
('HOME-003', 'Artisan Handcrafted Ceramic Coffee Mug', 'Charming 350ml stoneware ceramic coffee mug with artisanal reactive glaze finish, heat-retaining thick walls, and comfortable ergonomic thumb-rest handle.', 449.00, 3, 'images/products/home_mug.jpg', TRUE),
('HOME-004', 'All-in-One Metal Mesh Desk Organizer', 'Multi-tiered desktop organizer caddy with 6 functional sorting compartments and a pull-out slide drawer for organizing pens, notebooks, sticky pads, and stationery.', 699.00, 3, 'images/products/home_organizer.jpg', TRUE),
('HOME-005', 'Aromatherapy Scented Soy Candle Set', 'Set of 3 hand-poured 100% natural soy wax candles infused with therapeutic pure essential oils (French Lavender, Warm Vanilla, and Baltic Amber) providing 45 hours clean burn.', 899.00, 3, 'images/products/home_candle.jpg', TRUE),
('HOME-006', 'Memory Foam Ergonomic Seat Cushion', 'Orthopedic high-density memory foam seat cushion with U-shaped coccyx cut-out designed to relieve tailbone pressure, improve sitting posture, and provide chair comfort.', 1499.00, 3, 'images/products/home_cushion.jpg', TRUE),
('HOME-007', 'Rapid-Boil Glass Electric Kettle', 'High-capacity 1.8L borosilicate glass electric water kettle with 1500W rapid heating element, soft blue LED lighting indicator, auto shut-off, and boil-dry safety protection.', 1699.00, 3, 'images/products/home_kettle.jpg', TRUE),
('HOME-008', 'Indoor Geometric Ceramic Plant Pot', 'Elegant white matte geometric ceramic succulent planter with bottom drainage hole and matching natural bamboo drip tray saucer, ideal for indoor desks and windowsills.', 599.00, 3, 'images/products/home_planter.jpg', TRUE),

-- Accessories (7 products)
('ACC-001', 'Shockproof Hybrid Phone Case', 'Slim military-grade drop-tested clear phone case with shock-absorbing TPU bumper corners, raised camera bezels, anti-yellowing acrylic back, and responsive buttons.', 499.00, 4, 'images/products/acc_phonecase.jpg', TRUE),
('ACC-002', 'Foldable Aluminum Laptop Riser Stand', 'Sturdy aviation-grade aluminum alloy laptop stand with 6 adjustable ergonomic height angles, anti-slip silicone cushions, and open hollow frame for optimal heat ventilation.', 1299.00, 4, 'images/products/acc_laptopstand.jpg', TRUE),
('ACC-003', 'Polarized UV400 Classic Sunglasses', 'Timeless unisex aviator sunglasses engineered with 9-layer polarized TAC lenses for 100% UVA/UVB protection, anti-glare clarity, and lightweight corrosion-resistant metal frame.', 1199.00, 4, 'images/products/acc_sunglasses.jpg', TRUE),
('ACC-004', 'Top-Grain Genuine Leather Wallet', 'Handcrafted bi-fold wallet made from premium full-grain oil-waxed genuine leather featuring 8 card slots, dual currency compartments, ID window, and certified RFID blocking shield.', 999.00, 4, 'images/products/acc_wallet.jpg', TRUE),
('ACC-005', 'Braided Nylon 60W USB-C Fast Cable', 'Ultra-durable 6.6ft/2m nylon-braided USB-C to USB-C charging and sync cable supporting 60W 3A Power Delivery, 480Mbps data transfer, and 20,000+ bend lifespan.', 399.00, 4, 'images/products/acc_cable.jpg', TRUE),
('ACC-006', 'Magnetic Milanese Loop Watch Band', 'Breathable woven stainless steel mesh Milanese replacement watch band with strong infinitely adjustable magnetic clasp, compatible with standard 20mm/22mm quick-release lugs.', 799.00, 4, 'images/products/acc_watchband.jpg', TRUE),
('ACC-007', 'Slim RFID Pop-Up Aluminum Cardholder', 'Minimalist pocket cardholder constructed with aircraft-grade aluminum, patented quick-access card ejection switch holding up to 6 cards, integrated cash clip, and RFID shield.', 599.00, 4, 'images/products/acc_cardholder.jpg', TRUE)

ON DUPLICATE KEY UPDATE
    name = VALUES(name),
    description = VALUES(description),
    price = VALUES(price),
    category_id = VALUES(category_id),
    image_url = VALUES(image_url),
    active = TRUE;

-- 3. Populate Inventory for Each Product Safely
INSERT INTO inventory (product_id, quantity, reorder_level)
SELECT p.product_id, 
       CASE 
           WHEN p.sku LIKE 'ELEC%' THEN 35
           WHEN p.sku LIKE 'FASH%' THEN 50
           WHEN p.sku LIKE 'HOME%' THEN 30
           WHEN p.sku LIKE 'ACC%' THEN 45
           ELSE 25
       END AS quantity,
       10 AS reorder_level
FROM products p
ON DUPLICATE KEY UPDATE
    quantity = VALUES(quantity),
    reorder_level = VALUES(reorder_level);

-- 4. Ensure Default Admin User Has Correct SHA-256 Hash for 'admin123'
UPDATE customers 
SET password_hash = '240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9'
WHERE email = 'admin@shop.com' AND (password_hash = 'SHA256HASH_PLACEHOLDER' OR password_hash IS NULL);
