# User Flow (Coffee House App)

This document summarizes the end-to-end user journeys implemented by the app screens and named routes.

> Conventions:
> - Routes shown in **bold** (e.g., `**/login**`).
> - “Decision” describes conditional navigation (e.g., logged-in vs guest).

---

## 1) Entry / Splash Flow

### 1.1 App launch
1. App starts at **`/splash`** (`SplashScreen`)
2. Decision: **User authentication status**
   - If authenticated → proceed to **`/home`**
   - If not authenticated → proceed to **`/login`**

---

## 2) Guest Authentication Flows

### 2.1 Login
1. User opens **`/login`** (`LoginScreen`)
2. User enters credentials
3. Decision: login success/failure
   - Success → **`/home`**
   - Failure → stay on **`/login`** (show error)

### 2.2 Signup
1. User taps “Create account” → **`/signup`** (`SignupScreen`)
2. User fills registration details
3. Decision: signup success/failure
   - Success → typically **`/home`** (or prompt login)
   - Failure → stay on **`/signup`** (show error)

### 2.3 Forgot password
1. From **`/login`**, user selects “Forgot password”
2. Navigate to **`/forgotpassword`** (`ForgotPasswordScreen`)
3. User submits email
4. Success UI/confirmation (implementation-specific)
5. Navigate to **`/reset_password`** (`ResetPasswordScreen`)
6. User sets a new password
7. Decision: reset success/failure
   - Success → **`/login`**
   - Failure → stay on **`/reset_password`**

---

## 3) Customer Shopping Flow (Browse → Cart → Checkout)

### 3.1 Browse home
1. Authenticated user opens **`/home`** (`HomeScreen`)
2. User chooses a category or navigates to product listing
3. Navigate to product lists
   - Category list example: **`/all_products`** (`AllProductsScreen`)
   - Or specific list: **`/coffee_products`** (`CoffeeProductsScreen`)

### 3.2 View products
1. On **`/all_products`** or **`/coffee_products`**
2. User selects a product
3. Decision: UI behavior
   - If product details modal/sheet → user can continue without leaving list
   - If separate details screen exists (if any) → navigate accordingly

### 3.3 Add to cart
1. User taps “Add to cart” (from product list/details)
2. Cart state is updated
3. Decision: user proceeds or continues shopping
   - Continue shopping → return to products list
   - Proceed → **`/cart`** (`CartScreen`)

### 3.4 Review cart
1. User opens **`/cart`** (`CartScreen`)
2. User reviews items and totals
3. User proceeds to checkout
4. Navigate to **`/checkout`** (`CheckoutScreen`)

### 3.5 Checkout / Place order pre-step
1. On **`/checkout`** (`CheckoutScreen`)
2. User provides/chooses required info
   - Shipping address (may be **`/shipping_address`** screen or embedded)
3. User proceeds to payment
4. Navigate to **`/payment`** (`PaymentScreen`)

### 3.6 Payment
1. On **`/payment`** (`PaymentScreen`)
2. User confirms payment details
3. Decision: payment success/failure
   - Success → **`/order_confirmed`** (`OrderConfirmedScreen`)
   - Failure → remain on **`/payment`** (show error / retry)

---

## 4) Post-Order Flows

### 4.1 Order confirmed
1. On **`/order_confirmed`** (`OrderConfirmedScreen`)
2. User sees confirmation
3. User can choose:
   - Track order → **`/track_order`** (`TrackOrderScreen`)
   - Continue later (implicit navigation)

### 4.2 Track order
1. On **`/track_order`** (`TrackOrderScreen`)
2. User views status timeline/details
3. Navigate to order details (if implemented)
4. Decision: delivery completed?
   - If not completed → remain in tracking flow
   - If completed → **`/delivery_complete`** (`DeliveryCompleteScreen`)

### 4.3 Delivery complete
1. On **`/delivery_complete`** (`DeliveryCompleteScreen`)
2. User can return to shopping/home
   - Common target: **`/home`**

---

## 5) Profile Flows

### 5.1 View profile
1. From bottom nav/menu (implementation-specific), user opens **`/profile`** (`ProfileScreen`)

### 5.2 Edit profile
1. User taps “Edit profile”
2. Navigate to **`/edit_profile`** (`EditProfileScreen`, if routed/available)
3. User updates details
4. Decision: save success/failure
   - Success → return to **`/profile`**
   - Failure → stay on **`/edit_profile`**

---

## 6) Admin Flows

### 6.1 Admin login
1. Admin opens **`/admin_login`** (`AdminLoginScreen`)
2. Admin enters credentials
3. Decision: admin authentication success/failure
   - Success → **`/admin_dashboard`** (`AdminDashboardScreen`)
   - Failure → remain on **`/admin_login`**

### 6.2 Admin dashboard
1. On **`/admin_dashboard`**
2. Admin navigates to management sections (buttons/tiles)
   - Manage products → `AdminProductsScreen`
   - View reports → `AdminReportsScreen`
3. Admin can logout (shows confirmation dialog)

---

## 7) Key Decision Points Summary
- **Auth gate**
  - If user is unauthenticated and tries to access customer screens, route to **`/login`** (or show login prompt).
- **Payment result**
  - Payment success → **`/order_confirmed`**
  - Payment failure → stay on **`/payment`**
- **Order status progression**
  - **`/track_order`** may lead to **`/delivery_complete`** once delivery is completed.
- **Password reset**
  - Reset success → **`/login`**
  - Reset failure → stay on **`/reset_password`**


