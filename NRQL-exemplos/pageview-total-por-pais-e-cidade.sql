SELECT count(*) FROM PageView WHERE appName = 'FoodMe-Browser' FACET countryCode,city SINCE 1 week ago