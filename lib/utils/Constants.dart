
const mDomainUrl = 'https://bookthera.herokuapp.com/';
const mBaseUrl='https://bookthera.herokuapp.com/';
// const mBaseUrl='http://localhost:8000/';
const app_name = "Bookthera";
const socketUrl= "wss://bookthera.herokuapp.com/api/v1/ws";
// const socketUrl= "ws://localhost:8000/api/v1/ws";

/// Network timeout message
const timeOutMsg =
    "Looks like you have an unstable network at the moment, please try again when network stabilizes";
const wentWrongMsg='Something went wrong, please try again later';
const isLoggedIn = 'isLoggedIn';
const TOKEN = 'TOKEN';
const EXPIRATION_TOKEN_TIME = 'EXPIRATION_TOKEN_TIME';
const NOTIFICATION_JSON = 'NOTIFICATION_JSON';
const PHONE = 'PHONE';
const USERNAME = 'USERNAME';
const FIRST_NAME = 'FIRST_NAME';
const LAST_NAME = 'LAST_NAME';
const USER_ID = 'USER_ID';
const USER_EMAIL = 'USER_EMAIL';
const USER_PROFILE = 'USER_PROFILE';
const USER_ROLE = 'USER_ROLE';
const AVATAR = 'AVATAR';
const PASSWORD = 'PASSWORD';
const is_remember='is_remember';
const isGoogleSignin='isGoogleSignin';
const defaultDateFormat = 'EEE MMM dd, yyyy';
const chatDateTimeFormat = 'hh:mm a';
const SECOND_MILLIS = 1000;
const MINUTE_MILLIS = 60 * SECOND_MILLIS;
const HOUR_MILLIS = 60 * MINUTE_MILLIS;
const stripePublicKey = 'pk_test_51KByHxHQNZGr8l6UYjOw3asVXPfTLIgh8QJNtDy7CXWg64cTGkpjhnwmwCAKyPjaHbKZDJPN8zJnVa4RGxExzaW800OUshbrxy';
const stripeSecretKey = 'sk_test_51KByHxHQNZGr8l6UwkEWaWzccMac6JZaDF8YVc2oZ2jkyXerMoEqn2ot5jqSfinoRvNcY2DF14yfg4W01mmVJ10000bvOCSB7W';
 
const agoraAppId = '9c3053c586514d319f2ce2519f252960';

const playstoreUrl = "https://play.google.com/store/apps/details?id=com.asiayeshit.bookthera";
const appstoreUrl = "https://apps.apple.com/app/bookthera/id1667152149 ";
const placehorder='https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR-M0nVMzpCwEDhb-uCQe5T4GNTC5W97z-VWg&usqp=CAU';
const providerMediaPlaceholder = 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRjt-ewgNomB7qqJH9Hn5VxQsnOgH_rRb2u9Q&usqp=CAU';