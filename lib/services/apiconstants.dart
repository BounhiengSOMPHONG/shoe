class ApiConstants {
  // static const String baseUrl = 'http://100.75.106.34:3000';
  static const String baseUrl = 'http://192.168.43.235:3000';
  //auth
  static const String loginEndpoint = '/api/auth/login';
  static const String registerEndpoint = '/api/auth/register';

  // User profile endpoints
  static const String getUserProfileEndpoint = '/api/auth/profile';
  static const String updateUserProfileEndpoint = '/api/auth/profile';
  static const String deleteUserProfileEndpoint = '/api/auth/profile';
  static const String changePasswordEndpoint = '/api/auth/change-password';

  //category
  static const String categoriesEndpoint = '/api/categories/';

  // Search endpoint
  static const String searchProductsEndpoint = '/api/searchproducts';

  // Product types and brands endpoints
  static const String productTypesEndpoint = '/api/product-types';
  static const String brandsEndpoint = '/api/brands';

  // Wishlist endpoints - แก้ไขให้ตรงกับ backend
  static const String showWishlistEndpoint = '/api/showWishlist';
  static const String addToWishlistEndpoint = '/api/insertWishlist';
  static const String removeFromWishlistEndpoint = '/api/deleteWishlist/';

  // Address endpoints
  static const String showAddressEndpoint = '/api/address';
  static const String insertAddressEndpoint = '/api/insertaddress';
  static const String editAddressEndpoint = '/api/editaddress'; // + /:id
  static const String deleteAddressEndpoint =
      '/api/address'; // + /:id (DELETE method)

  //Checkout endpoints
  static const String checkoutEndpoint = '/api/checkout';

  // Orders endpoints
  static const String ordersEndpoint = '/api/orders';
  static const String orderDetailEndpoint = '/api/order'; // + /:orderId
  static const String repayOrderEndpoint = '/api/order'; // + /:orderId/repay
  static const String cancelOrderEndpoint = '/api/order'; // + /:orderId/cancel
  static const String orderTimelineEndpoint =
      '/api/order'; // + /:orderId/timeline

  // Review endpoints
  static const String reviewsEndpoint = '/api/reviews'; // GET /:productId, POST /
  static const String reviewSummaryEndpoint = '/api/reviews'; // GET /:productId/summary
  static const String userReviewEndpoint = '/api/reviews'; // GET /:productId/user, DELETE /:productId

  // Product popular and latest endpoints
  static const String popularProductsEndpoint = '/api/products/popular';
  static const String latestProductsEndpoint = '/api/products/latest';


  // Add other endpoints as needed
}
