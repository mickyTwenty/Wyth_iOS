//
//  SeatUsConstants.swift
//  SeatUs
//
//  Created by Qazi Naveed on 10/13/17.
//  Copyright © 2017 Qazi Naveed. All rights reserved.
//

import Foundation
import UIKit

struct WebServicesConstant {
    
//    static let DomainUrl: String                        = "http://192.168.168.114/seatus/public/api/v1"
//    static let DomainUrl: String                        = "http://192.168.168.114/seatus-dev/public/api/v1"
//    static let DomainUrl: String                        = "http://52.26.111.25/api/v1"  //LIVE
//    static let HelpWebViewBaseURL                       = "http://52.26.111.25/help/"  // LIVE
    
    static let DomainUrl: String                        = "https://portal.gowyth.com/api/v1" //STAGING
    static let HelpWebViewBaseURL                       = "https://portal.gowyth.com/help/"  // STAGING
    static let AgreementUrl: String                     = "https://portal.gowyth.com/agreement" //STAGING
    
//    static let DomainUrl: String                        = "http://34.213.248.253/api/v1" //STAGING
//    static let HelpWebViewBaseURL                       = "http://34.213.248.253/help/"  // STAGING
//    static let AgreementUrl: String                     = "http://34.213.248.253/agreement" //STAGING
    static let ContactUsUrl: String                     = "https://gowyth.com/contact/"

    static let LoginService                             = "/login"
    static let ResetPasswordService                     = "/reset-password"
    static let RegistrationService                      = "/register"
    static let VerifyUserService                        = "/verify-account"
    static let FbLoginService                           = "/fb-login"
    static let LogoutService                            = "/logout"
    static let UpdateUserService                        = "/account/update"
    static let SyncUserFriendsService                   = "/account/sync-friends"
    static let FollowerFriendsService                   = "/account/list/followings"
    static let BindAccountWithFaceebookService          = "/account/facebook"
    static let UpgradeDriverService                     = "/account/upgrade/driver"
    static let AboutMeService                           = "/account/me"
    static let BootMeUp                                 = "/boot-me-up"
    static let CreateTrip                               = "/ride/create/public"
    static let PassengerCreateTrip                      = "/passenger/create/ride"
    static let GetRoutes                                = "/ride/driver/popularity"
    static let SearchTrip                               = "/ride/search"
    static let PastTrips                                = "/past/trips"
    static let UpcomingTrips                            = "/upcoming/trips"
    static let Offers                                   = "/offers"
    static let Passenger                                = "/passenger"
    static let Driver                                   = "/driver"
    static let Details                                  = "/ride/detail"
    static let BookNow                                  = "/book-now"
    static let MakeOffer                                = "/make/offer"
    static let AcceptOffer                              = "/accept/offer"
    static let OfferDetail                              = "/offer/detail"
    static let EliminateUser                            = "/ride/eliminate"
    static let SearchRequest                            = "/ride/requests"
    static let FixedPreRideTimeByDriver                 = "/driver/preschedule/ride/time"
    static let FixedRideTimeByDriver                    = "/driver/schedule/ride/time"
    static let FixedRideTimeForcefullyByDriver          = "/driver/schedule/ride/time/forcefully"

    static let EditSeatService                          = "/driver/ride/update-seats/"
    
    static let GetCreditCard                            = "/passenger/get/credit-card"
    static let AddCreditCard                            = "/passenger/add/credit-card"
    static let RemoveCreditCard                         = "/passenger/remove/credit-card"
    static let DefaultCreditCard                        = "/passenger/default/credit-card"
    static let PaymentHistory                           = "/payment/history"
    
    static let UpdateBankDetails                        = "/driver/bank-details/update"
    static let ReadBankDetails                          = "/driver/bank-details/read"
    static let GetNotifications                         = "/account/list/notifications"
    static let RateTripService                          = "/rate/trip/"
    static let MarkTripService                          = "/mark"
    
    static let DriverStartTrip                          = "/driver/start/trip"
    static let DriverResumeTrip                         = "/driver/resume/trip"
    static let DriverEndRide                            = "/driver/end/trip"
    static let PendingRatingsService                    = "/account/list/pending-ratings"
    static let TripCancelService                        = "/trip/cancel"
    
    static let ShareIteneraryService                    = "/share-itenerary"
    
    static let PassengerRateDriversTripService          = "/passenger/rate/drivers"
    static let DriverRatePassengersTripService          = "/driver/rate/passengers"
    static let NeedPaymentService                       = "/passenger/trip/payment"
    static let SchoolNamesService                       = "/list/schools"
    static let RejectOfferByPassenger                   = "/passenger/reject/offer"
    static let ResendVerificationCode                   = "/resend-verification-email"
    static let DeleteAccountService                     = "/account/delete"
    static let FriendProfileService                     = "/account/view/"
    
    static let PassengerSubscribeRide                   = "/passenger/subscribe/ride"
    static let SubscribedRoutes                         = "/driver/list/subscribed-routes"
    
    static let ApplyPromo                               = "/passenger/apply-promo"
}

struct UserType {
    static let UserNormal = "normal"
    static let UserDriver = "driver"
}

struct ApiKeys {
    static let Google =     "AIzaSyDvJoRXJbNTXXiIFRE65NwbhhhtWsVND8I"
    static let MatrixApi =  "AIzaSyDb3cqERWy5XBcPRF_knqm6JAzUJB3nh68"
    static let Stripe     = "pk_live_JsROXvemcrUVJN91G7Zmm7X8" // LIVE
  //  static let Stripe     = "pk_test_3mNpJpdwD47TQyZcOOzLZfQr" // STAGING
    static let MixPanel   = "d0f09a7f5c1ba1e219ed3c30d2a5594a"
}

struct ControllerNames {
    static let LogoutController : String = "LogoutController"
}

struct MatrixApiServices {
    static let scheme = "https"
    static let originKey = "origins"
    static let destinationKey = "destinations"
    static let cleintIDKey = "key"
    
    static let originRouteKey = "origin"
    static let destinationRouteKey = "destination"
    static let alternateRouteKey = "alternatives"

    static let getDistanceApi = "maps.googleapis.com/maps/api/distancematrix/json"
    static let getRouteApi =    "maps.googleapis.com/maps/api/directions/json"

}

public enum HTTPMethods: String {
    case ptions = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
}

struct ValidationExpressions {
    static let EmailValidator                       = "[A-Z0-9a-z._%+-]{1,}+@[A-Za-z0-9.-]+\\.[A-Za-z]{1,4}"
    static let LengthValidator                      = "^.{4,100}$"
    static let PasswordLengthValidator              = "^.{6,100}$"
    static let ZeroLengthValidator                  = "^.{1,100}$"
//    static let NumberValidation                     = "[0-9]{3}[0-9]{3}[0-9]{4}"
    static let NumberValidation                  = "^.{14,30}$"
    static let SSNLengthValidator                   = "^.{9,9}$"
//    static let NumberValidation                     = "^(\\+\\d{1,2}\\s)?\\(?\\d{3}\\)?[\\s.-]\\d{3}[\\s.-]\\d{4}$"

}

struct ValidationMessages {
    static let EmailValidationMessage               = "Enter valid email"
    static let PasswordMismatchMessage              = "Passwords doesn't match"
    static let MinimumLengthMessage                 = "Must be at least 4 characters long"
    static let MinimumPasswordLengthMessage         = "Must be at least 6 characters long"
    static let SelectorMessage                      = "Please select before proceeding"
    static let SelectorMessageReturnDate            = "Please select return date before proceeding"
    static let NumberValidationMessage              = "Invalid number"
    static let NotEmptyValidationMessage            = "Cannot be left empty"
    static let RatingValidationMessage              = "All Passengers must be rated."
    static let ShareItenaryValidation               = "No recent shares."
    static let SSNLengthMessage                     = "SSN must be 9 characters long"

}

struct FileNames {
    static let SignUpPlist                          = "SignUpInfo"
    static let SignUpDetailsPlist                   = "SignUpInfoDetails"
    static let ReusableComponentsStoryBoard         = "SearchAndFindPicker"
    static let PassengerSideMenuPlist               = "SlideMenuPassenger"
    static let DriverSideMenuPlist                  = "SlideMenuDriver"
    static let DriverEditProfilePlist               = "DriverEditProfile"
    static let PassengerEditProfilePlist            = "PassengerEditProfile"
    static let PostTripPlist                        = "PostTrip"
    static let PostTripPassengerPlist               = "PostTripPassenger"
    static let FindRidePlist                        = "FindRide"
    static let PastTripsPlist                       = "PastTrips"
    static let UpcomingTripsPlist                   = "UpcomingTrips"
    static let OfferDetailsPlist                    = "OfferDetails"
    static let RideDetailsPlist                     = "RideDetails"
    static let SearchRidePlist                      = "SearchRide"
    static let BankInfoPlist                        = "BankInfo"
    static let InfoHtml                             = "info"
    static let AgreementDriverHTML                  = "agreement_driver"
    static let AgreementPassengerHTML               = "agreement_user"
}

struct FileTypes {
    static let Plist                                = "plist"
    static let Html                                 = "html"
}

struct PlistPlaceHolderConstant {
    static let FullNamePlaceHolder                  =  "Full Name"
    static let SchoolNamePlaceHolder                =  "College Name"

    static let EmailPlaceHolder                     =  "College Email"
    static let PhoneNumberPlaceHolder               =  "Phone Number"
    static let SchoolOrganizationPlaceHolder        =  "Student Org (optional)"
    
    static let StatePlaceHolder                     =  "State"
    static let CityPlaceHolder                      =  "City"
    static let ZipPlaceHolder                       =  "Zip"
    static let GraduationPlaceHolder                =  "Graduation Year"
    static let PasswordPlaceHolder                  =  "Password"
    
    static let DobPlaceHolder                       =  "Date of Birth"
    static let genderPlaceHolder                    =  "Gender"
    
    static let DocumentPlaceHolder                  = "Documnets"
    static let VehiclePlaceHolder                   = "Vehicle Type"
    static let LicencePlaceHolder                   = "Driving License"

    static let PostTripOrigin                       = "Origin"
    static let PostTripDestination                  = "Destination"
    static let PostTripDate                         = "Date"
    static let PostTripTimeOfDay                    = "Time of Day"
    static let PostTripReturnDate                   = "Return Date"
    static let PlaceHolderForMap                    = "Select from Map"
    static let PlaceHolderDate                      = "MM/DD/YEAR"
    static let PostTripEstimates                    = "Estimate"
    static let PostTripBookNow                      = "Book Now"
    static let PostTripSeats                        = "Select Seats"
    static let PostTripRoundTrip                    = "Round Trip"
    
    static let FindRidesEstimates                   = "Ride Estimate"
    static let FindRidesRating                      = "Rating"
    
    static let PlaceHoldeFirstName                  = "First Name"
    static let PlaceHoldeLastName                   = "Last Name"
    static let PostTripDistance                     = "Distance"
    
    static let PostTripType                         = "Trip Type"
    
    static let PostTripName                         = "Trip Name"
    static let PostTripId                           = "Trip ID"
    static let PostTripSeatsLabel                   = "Seats"
    
    static let GroupChatCell                        = "GroupChatCell"
    static let ShareItenariCell                     = "ShareItinaryCell"
    static let ViewMapCell                          = "ViewMapCell"
    static let SeatsTitle                           = "Seats"
    
    static let NeedToPayment                        = "Need to Payment"
    static let RideStatus                           = "Ride Status"
    static let VehicleIDPlaceHolder                 = "License Plate No."
    
    static let MakePlaceHolder                 = "Make"
    static let ModelPlaceHolder                 = "Model"
    static let YearPlaceHolder                 = "Year"
    
    static let CompanyPlaceHolder                 = "Company Name"
    static let SourceHearingMessage = "How did you hear about us ?"
    static let EffectivePlaceHolder                 = "Effective Date"
    static let ExpiryPlaceHolder                 = "Expiry Date"
    static let TotalBagsPlaceHoilder                 = "Total Bags"
    
    static let PickUpHeading                        = "Pick-up"
    static let DropOffHeading                       = "Drop-off"
    
    static let SSNPlaceHolder                 = "SSN"
    
    static let PostTripPaymentOption                   = "Payment Option"
}


struct AssetsName {
    
    static let SinUpScreenLoginButtonImageName     = "login_btn_signup"
    static let SinUpScreenBackButtonImageName      = "back_btn_login"
    static let SinUpScreenSignUpButtonImageName    = "signup_btn"
    static let ValidationErrorImageName            = "error_info_icon"
    static let ForgotPasswordBgName                = "forgot_password_popup_bg"
    static let ValidateNumberBgName                = "popup_bg2"
    static let ForgotPasswordTitleImage            = "email_icon"
    static let ValidateNumberTitleImage            = "validation_num_bg"
    static let MenuButtonImage                     = "menu_icon"
    static let SideMenuBackButton                  = "back_arrow_icon"
    static let LogOutBgName                        = "back_arrow_icon"
    static let EditProfileTxtFiledBgImageName      = "edit-pro-field_line"
    static let EditProfileTxtDropDownImageName     = "edit-pro-dropdown_arrow"
    static let ActiveStarImage                     = "active_rating_star"
    static let HalfActiveStarImage                 = "half_active_greay_rating_star"
    static let InActiveStarImage                   = "inactive_grey_rating_star"
    static let ProfilePlaceHolderImage             = "profile_placeholder_default"
    static let PostRideButtonImageName             = "post_ride_btn"
    static let DriverSeatIcon                      = "driver_icon_p"
    
    static let CircleImageAvailable                = "edit-pro-friends_listing_counter"
    static let BGImageAvailable                    = "badge_bg"
    
    static let CircleImageFilled                    = "check_circle"
    static let BGImageFilled                        = "oval_shap"
    static let SeatFilledDetailsBG                  = "passenger_detail_bg"
    static let SeatReservedDetailsBG                = "driver_detail_bg"
    
    static let SeatCrossImageForReserved            = "filled_reserved_cross"
    static let SeatCrossImageForFilled              = "available_icon"
    static let SeatCrossImageForAvailable           = "cross_grey_icon"
    static let AllDayImage                          = "all_day_btn"
    static let defaultProfileName                   = "default.jpg"
    static let NoDriverImage                        = "no_driver"
    static let AddCardImage                         = "add_cart_icon"
    static let AnnotaionDropOff                     = "dropoff_marker"
    static let AnnotaionPickUp                      = "pickup_marker"
    static let AnnotaionDriver                      = "car_marker"
    
    static let LeaveRideImage                       = "leave_ride"
    static let CancelRideImage                      = "cancel_ride"

    static let DriverIconImage                      = "driver_icon"
    
    static let AnyTimeImage                         = "any_time_btn-new-ui"
    static let PostRidePopUpImageName               = "post_ride_popup_btn"
    static let PostRideNowImageName                 = "post_ride_now_btn"
    
    static let SearchRiderButtonImageName           = "search_rider_btn"
    static let SearchDriverButtonImageName          = "search_driver_btn"
    
}

struct ApplicationConstants {
    static let ApplicationName                              = "WYTH"
    static let AnimationDuration                             = 0.3
    static let AnimationDurationSideMenu                     = 0.3
    static let CountryIdUS                                   = "231"
    static let DateFormatClient                              = "MM/dd/yyyy"
    static let DateTimeFormat                                = "MM/dd/yyyy HH:mm"
    static let DateTimeFormat_12                             = "MM/dd/yyyy hh:mm a"
    static let DateFormatServer                              = "yyyy-MM-dd"
    static let DateTimeServerFormat                          = "yyyy-MM-dd HH:mm:ss"
    static let TimeFormat_12                                 = "hh:mm a"
    static let TimeFormat                                    = "HH:mm"
    static let YearFormat                                    = "yyyy"
    static let ForgotDialogCenterY: CGFloat                  =  -50.0
    static let ForgotDialogOriginY: CGFloat                  =  -1000.0
    static let ProfileImageCompression                       = 0.5 as CGFloat
    static let DocImageCompression                          = 0.8 as CGFloat
//    static let UserEmail                                     = "normal@appmaisters.com"
//    static let UserPassword                                  = "abc123"
    static let UserEmail                                     = "passenger2@me.com"
    static let UserPassword                                  = "123456"
    static let UserToken                                     = "1111111111" as AnyObject
    static let DeviceType                                    = "ios" as AnyObject
    static let NavigationControllerID                        = "NavigationController"
    static let OptionsLblAnimationType                       = 0.5
    static let ListingTypeUserDriver                         = "DRIVER MENU"
    static let ListingTypeUserPassenger                      = "PASSENGER MENU"
    static let UserAgreementMessage                          = "Please Accept User Agreement"
    static let ContactSyncAlertTitle                         = "Sync Contacts"
    static let ContactSyncAlertMessage                       = "Would you like to add your friends who are using " + ApplicationName + " ?"
    static let AccountDeleteTitle                            = "Delete Account"

    static let AccountDeleteMessage                          = "Are you sure you want to delete your account ?"
    static let LeavRideMessage                               = "Are you sure you want to Leave Ride?"
    static let LeavRideTitleMessage                          = "Leave Ride"

    static let CancelRideMessage                             = "Are you sure you want to Cancel Ride?"
    static let CancelRideTitleMessage                        = "Cancel Ride"
    
    static let CreateAnotherRideTitleMessage                 = "Scheduling Multiple Trips?"
    static let CreateAnotherRideMessage                      = "\nTrip Created Successfully.\n\nWould you like to create another trip with the same preferences?"
    
    static let StandardMessage = "If you select the standard payment option then you should expect to receive payment within 5 business days after the trip is completed. No additional processing fees will be charged for this payment option."
    static let ExpidiatedMessage = "If you select the expedited payment option then you should expect to receive a payment within 2 business days after the trip is completed. Please note an additional processing fee of 5% will be charged to your trip earnings when selecting this payment option."

    static let UserObject                                    = "UserObject"
    static let UserImageChangNotification                    = "UserImageChangNotification"
    static let DriverUpdatedNotification                     = "DriverUpdatedNotification"
    static let SyncedFriendNotification                      = "SyncedFriendNotification"
    static let UserProfileImageKey                           = "profile_picture" as AnyObject
    static let ExceedDocsLimit                               = "You can not add more than five documents"
    static let RatePerMileLower                              = 0.25 as Double
    static let RatePerMileUpper                              = 0.50 as Double
    static let MilesConversion                               = 0.000621371 as Double
    static let PendingText                                   = "Pending" as String
    static let RejectedText                                  = "Rejected" as String
    static let AcceptedText                                  = "Accepted" as String
    static let DataLossMessage                               = "This action will cause you to lose all the data.  Would you like to still proceed?" as String
    static let OrangeColor :UIColor = UIColor(red: 253.0/255.0, green: 135.0/255.0, blue: 0.0/255.0, alpha: 1.0)
    static let GreenColor :UIColor = UIColor(red: 85.0/255.0, green: 175.0/255.0, blue: 69.0/255.0, alpha: 1.0)
    static let GreenColorBright :UIColor = UIColor(red: 85.0/255.0, green: 175.0/255.0, blue: 69.0/255.0, alpha: 0.6)


    static let PreferencesArrayKey                           = "preferences"
    static let Token                                         = "_token"
    static let InviteExpireMessageOnFreindsScreen            = "Your Previous Invites have Expired."
    static let InviteExpireMessageOnCreateTripeScreen        = "Your Previous Invites have Expired, do you want to proceed with the request ?"
    static let InvitePendingMessage                          = "You currently have pending invites of another category, do you want to cancel previous invites and proceed ?"
    
    static let InviteNotAcceptedMessage                      = "You have pending Friend Invites, please either cancel their invites or wait for their status to be updated"
    static let InvitePendingMessageTitle                     = "Previous Pending Invites"

    static let ForefullyStartRideMessage                     = "There are still some seats available. If you choose to proceed with the trip then the remaining seats will be cancelled"
    
    static let NoCreditCardMessage                           = "You will need to add a Credit card in order to proceed with making an offer. Would you like to add a Credit card now?"
    static let InviteExpireMessageTitleOnCreateTripeScreen   = "Invites Expired"
    static let InviteExpireMessageNotifScreen                = "Invites Expired"
    static let SeatAvailableStatus                           = "Available"
    static let SeatRequiredStatus                            = "Required"
    static let SeatFilledStatus                              = "Filled"
    static let MakeOfferTitle                                = "Make Offer"
    static let ViewOfferTitle                                = "View Offer"
    static let StartRideTitle                                = "Start Ride"
    static let StartRoundTripTitle                           = "Start Return Trip"
    static let ResumeRide                                    = "Continue to Ride"
    static let MarkPickupTitle                               = "Mark Pickup"
    static let MarkDropOffTitle                              = "Mark Dropoff"
    static let EndRideTitle                                  = "End Ride"
    static let TrackRide                                     = "Track Ride"
    static let RideSeatsDetailTitle                          = "SEAT DETAILS"
    static let GroupChatTitle                                = "GROUP CHAT"
    static let RideDetailsTitle                              = "RIDE DETAILS"
    static let CancelReservationAlertTitle                   = "Cancel Reservation"
    static let CancelReservationAlertMessage                 = "Do you want to cancel reservation for"
    static let OfferDetailsScreenTitle                       = "OFFERS"
    static let TrackingControllerTitle                       = "Tracking"
    static let strokeWidth                                   = 4.0
    static let RouteNotFoundMessage                          = "No Routes Found"
    static let FriendsCellView                               = "FriendsCellView"
    static let PlaceHolderText                               = "Write here..."
    static let DriverSeatsErrorMessage                       = "The Driver you invited does not have enough seats for all the invited Passengers"
    static let InformationScreenName                         = "INFORMATIONS"
    static let PassengerRatingScreenName                     = "PASSENGER RATING"
    static let PastDateMessage                               = "Please select current or a date in advance"
    static let DOBMessage                                    = "Please select current or a date in past"
    static let InvalidRouteMessage                           = "Please select a valid route"


    
    static let RateAlertTitle                                = "Pending Ratings"
    static let RateAlertMessage                              = "You currently have a pending rating. Would you like to complete it now?"
    
    static let NeedToPaymentTitle                            = "Need To Payment"
    
    static let RideCanceledTitle                             = "Cancelled"
    static let RideLeftTitle                                 = "Left"
    
    static let PassengerThemeColor :UIColor = UIColor(red: 85.0/255.0, green: 175.0/255.0, blue: 69.0/255.0, alpha: 1.0)
    
    static let DriverThemeColor :UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1.0)
    
    static let CollegeNameConstant                          = "College Name"
    static let TripTypeRound                                = "Round Trip"
    static let TripTypeSingle                               = "Single Trip"
    static let SameAddressMessage                           = "Origin and Destination must be different"
    static let SelectRoundTripDate                          = "Select Date"

    static let CreateTripTitle                              = "CREATE RIDE"
    static let CreateTripPostRideTitle                      = "POST RIDE"

    static let SearchRideTitle                              = "SEARACH RIDE"
    static let InvitePeoplePopup                            = "InvitePeoplePopUp"
    static let iTunesUrl                                    = "https://itunes.apple.com/us/app/wyth/id1428331609?ls=1&mt=8"
    static let ThresholdOnFixedRideTime                     = 0.0
    static let MyPaymentScreenTitle                         = "MY PAYMENTS"

    static let DriverDetailsNotSubmittedMessage             = "Your profile is incomplete, do you wish to complete your profile?"
    static let MinimumOfferAmountMessage                    = "Minimum offer amount is $5."
    
}

struct ValidationCustomization {
    static let PopUpColorBg :UIColor = UIColor(red: 238.0/255.0, green: 69.0/255.0, blue: 37.0/255.0, alpha: 1.0)
    static let ErrorImage   :UIImage = UIImage(named: AssetsName.ValidationErrorImageName)!
    static let ErrorFont : UIFont  = UIFont(name: "Helvetica", size: 10)!
}

struct DefaultSizes{
    static let imageSize = CGSize(width: 400, height: 400)
}


struct FireBaseConstant {
    static let usersCollection              = "users"
    static let offersCollection             = "groups"
    static let chatCollection               = "chat"
    static let LocationCollection           = "locations"
    static let invitedMembersCollection     = "invited_members"
    static let invitedMemberTimeStamp       = "last_req_edited"
    static let chatMessageTimeStamp         = "timestamp"
    static let tripSearchData               = "trip_search_data"
    static let searchDataDate               = "date"
    static let searchDataDestinationGeo     = "destination_geo"
    static let searchDataDestinationText    = "destination_text"
    static let searchDataInvited            = "invited_by"
    static let searchDataOriginGeo          = "origin_geo"
    static let searchDataOriginText         = "origin_text"
    static let searchDataTimezone           = "time_range"
    static let searchDataTime               = "start_time"
    static let searchDataSeatsTotal         = "seats_total"
    static let searchDataSeatsAvailable     = "seats_available"
    static let inviteType                   = "invite_type"
    static let userID                       = "inviter_id"
    static let inviterName                  = "inviter_name"
    static let notificationChaneliOS        = "/topics/ios1"
    static let notificationChanelUser       = "/topics/user_"
    static let invitedReqTimeOut = 30.0 as Double
    static let senderPassenger              = "passenger"
    static let senderDriver                 = "driver"
    static let unreadChatCount              = "unread_chats"
    static let unreadNotificationCount      = "unread_notifications"
    static let driverNode                   = "invited_driver"
    static let driverStatus                 = "status"
    static let driverID                     = "user_id"
    static let Coordinates                  = "coordinates"
    static let isRoundTrip                  = "is_round_trip"
}

struct CoreDataConstants{
    
    static let TripInfoBookNow                  = "bookNow"
    static let TripInfoDate                     = "date"
    static let TripInfoDestination              = "destination"
    static let TripInfoDestinationCoordinates   = "destinationCoordinates"
    static let TripInfoEstimate                 = "estimate"
    static let TripInfoOrigin                   = "origin"
    static let TripInfoOriginCoordinates        = "originCoordinates"
    static let TripInfoSeats                    = "seats"
    static let TripInfoTimeOfDay                = "timeOfDay"
    
    static let FriendsFetchLimit                = 3
    static let FriendsSearchCount               = "search_count"
    static let TripInfoRoundTrip                = "roundTrip"
    static let TripName                         = "trip_name"
    static let Gender                           = "gender"
    static let TripReturnDate                   = "returnDate"

}


enum PopScreen:Int {
        case ForgotPassword = 0
        case NumberValidation = 1
        case UpgradeUserTpDriver = 2
    }

enum FriendInvitedState:Int{
    case Pending = 0
    case Accepted = 1
    case Rejected = -1
}

struct ForgotPasswordPopup {
    static let ForgotPassBG : UIImage = UIImage(named:AssetsName.ForgotPasswordBgName )!
    static let ForgotPassTxtFieldTitleImage : UIImage = UIImage(named:AssetsName.ForgotPasswordTitleImage )!
    static let ForgotPassContentText :String = "Enter your email address below and we'll send you instructions on how to change your password!"
    static let ForgotPassTxtFieldPlaceHolder :String = "Email (enter your registred email)"
}

struct ValidationPopup {
    static let ValidateNumberBG : UIImage = UIImage(named:AssetsName.ValidateNumberBgName )!
    static let ValidateNumberContentText :String = "Enter your validation code here which you received by email."
    static let ValidateNumberTxtFieldPlaceHolder :String = "(enter validation code)"
    static let ValidateNumberTxtFieldTitleImage : UIImage = UIImage(named:AssetsName.ValidateNumberTitleImage )!
}

enum TransitionState {
    case IsOnLoginScreen
    case GoingToSignUpScreen
    case GoingBackToLoginScreen
    case GoingToSignUpDetailScreen
    case GoingBackToSignupScreen
    case ShowNumberVerifivationScreen
    case ComingFromFBSignUp
}

enum ValidationType:Int {
    case DefaultValidation                 = 0
    case EmailValidation                   = 1
    case ConfirmPasswordValidation         = 2
    case ZipValidation                     = 3
    case SelectorTypeValidation            = 4
    case NumberValidation                  = 5
    case NotEmptyValidation                = 6
    case SelectorTypeSchoolValidation      = 7
    case PasswordValidation                = 8
    case SSNValidation                     = 9
    case NoValidation                      = 99

}

enum ResponseAction:Int{
    case ShowMesasgeAtRunTime                = 0
    case DoNotShowMesasgeAtRunTime           = 1
    case ShowMesasgeOnAlert                  = 2
}

enum OfferDetailsCellState:Int{
    case isComingFromOffers                = 0
    case isComingFromPastTrips             = 1
    case isComingFromUpcomingTrips         = 2
}

enum AddingFreinds:Int{
    case isComingForDriverPassengerBoth    = 0
    case isComingForDriverOnly             = 1
}


enum InvitedFriendTimeStatus:Int{
    
    case InvitExpires       = 0
    case InviteNotExist     = 1
    case InviteNotExpire    = 2
    case InviteExistForDifferentType = 3
    case InviteNotExpireButDriverPending    = 4
    case InviteNotExpireAndDriverAccepted    = 5


}

enum DropDownOptions:String{
    case SelectState =          "selectState"
    case SelectCity  =          "selectCity"
    case SelectGraduationYear = "selectGraduationYear"
    case SelectDOB  =           "selectDOB"
    case SelectCarModelYear  =  "selectCarModelYear"
    case SelectEffectiveDate  = "selectEffectiveDate"
    case SelectExpiryDate  =    "selectExpiryDate"
    case SelectGender =         "selectGender"
    case SelectModel =          "selectModel"
    case SelectMake =           "selectMake"
    case SelectHearingSource    = "selectHearingSource"

    case SelectVehicleType =    "selectVehicleType"
    case SelectOrigin =         "selectOrigin"
    case SelectDestination =    "selectDestination"
    case SelectDate =           "selectDate"
    case SelectRating =         "selectRating"
    case SelectSchool =         "selectSchool"
    case WriteTripName =        "writeTripName"
    
    case SelectPayment =        "selectPayment"
}

enum ImageType: String {
    case png
    case jpeg
}

struct ErrorTypes{
    static let InvalidCredErrorCode : String = "validation_error"
    static let InactiveAccountErrorCode : String = "inactive_account"
    static let VerifyEmailErrorCode : String = "action_verify_email"
    static let InvalidCredEmailErrorCode : String = ""
    static let ExceptionErrorCode : String = "exception"
    static let InvalidCCErrorCode : String = "invalid_credit_card"
    static let AddBankAccount : String = "add_bank_account"
}

struct UserDefaultsKeys {
    static let PreferenceKey    : String = "PreferenceKey"
    static let SchoolKey        : String = "schools"
    static let VehicleTypeKey   : String = "vehicle_type"
    static let VehicleMakeKey   : String = "make"
    static let RefrenceSource   : String = "reference_source"

}

struct PushNotificationCategory{
    static let FriendInvitationPush     = "trip_invitation"
    static let OfferAcceptedByDriver    = "offer_accepted_driver"
    static let NewTripOffer             = "trip_offer"
    static let DriverInvitation         = "driver_invitation"
    static let ChatNotification         = "chat_message"
    static let OfferContradicted        = "offer_contradicted"
    static let PassengersConfirmed      = "passengers_confirmed"
    static let OfferAcceptedPassenger   = "offer_accepted_passenger"
    static let OfferRejectedPassenger   = "offer_rejected_passenger"
    static let TripCancelled            = "trip_canceled"
    static let MarkDropOFF              = "marked_dropoff"
    static let PassengerRemoved         = "passenger_removed"
    static let MarkPickup               = "marked_pickup"
    static let UpdateReturningRideTime  = "update_returning_ride_time"
    static let TripStartedPAssenger     = "trip_started_passenger"
    static let PickkUpTimeUpdated       = "pickup_time_updated"
    static let PaymentFailed            = "payment_processing_failed"
    static let NewTripSuggestion        = "new_trip_suggestion"
    static let PassengerLeft            = "passenger_left"
    //handleBackgroundPushNotifications
    /*
     offer_contradicted  na 
     passengers_confirmed  Rd /// verfied
     offer_accepted_passenger na /// verfied
     offer_rejected_passenger na ///
     offer_accepted_driver firebaseverification & poppup // offer_accepted_driver [getTimestamp and if >1 day than do not show popup] //handled
     trip_canceled rd
     marked_dropoff rd /// verfied
     passenger_removed rd
     marked_pickup rd /// verfied
     update_returning_ride_time rd /// verfied
     trip_started_passenger rd /// verfied
     pickup_time_updated rd /// verfied
     payment_processing_failed rd
     trip_offer offer detail
     chat_message chat detail
     trip_invitation firebaseverification & poppup //handled
     driver_invitation firebaseverification & poppup //handled
     */
}

struct RideStaus{
    /*
     PENDING   = When ride doesn't have driver associated
     ACTIVE    = When ride has driver associated and coming in search result
     FILLED    = When all passengers of ride has been confirmed, driver can select departure time if set to this status
     CONFIRMED = Ready-to-fly situation. When all passengers of ride has been confirmed, driver has selected departure time
     STARTED   = When driver has marked ride as started
     ENDED     = When driver has marked ride as ended
     CANCELED  = When ride is canceled, not decided yet how this status gonna be set
     FAILED    = When ride failed to start, not decided yet how this status gonna be set
     */
    
    static let PENDING              = "pending"
    static let ACTIVE               = "active"
    static let FILLED               = "filled"
    static let CONFIRMED            = "confirmed"
    static let STARTED              = "started"
    static let ENDED                = "ended"
    static let EXPIRED              = "expired"
    static let CANCELED             = "canceled"
    static let FAILED               = "failed"
    static let GOING_COMPLETED      = "goingCompleted"
    static let RETURN_CONFIRMED      = "returnConfirmed"

    
}

struct InviteCategory{
   static let DriverCreate  = "driver_create"
   static let DriverSearch  = "driver_search"
   static let UserCreate    = "user_create"
   static let UserSearch    = "user_search"
}

struct AddFriendsViewControllerType {
    static let Invited = "InvitedFriendCell"
    static let Itinerary = "ItineraryDetailsCell"
}

struct WarningMessage {
    static let PleaseSelectText :String = "Please select "
    static let BeforeProceedingText :String = " before proceeding."
}

struct MyTripsConstant {
    static let Offers = 0
    static let Past = 1
    static let Upcoming = 2
    static let DriverHeading = "Driver Name:"
    static let PassengerHeading = "Passenger Name:"
    static let NoOfBagsHeading = "No of bags:"
}
struct WarningMessages {
    static let CameraWarning                    = "You have disallowed camera access.  Please navigate to phone settings and allow WYTH app access to the camera."
    static let LocationWarning                    = "You have disallowed location access.  Please navigate to phone settings and allow WYTH app access to the location."

}

struct MakeOfferConstant {
    static let NoOfSeatsHeading = "No. of Seats"
    static let NoOfBagsHeading = "No. of Bags"
    static let MinimumSeatsLimit = 1
    static let MinimumBagsLimit = 0
    static let DriverId = "driver_id"
    static let PassengerId = "passenger_id"
    static let Bags = "bags"
    static let Seats = "seats_total"
}

struct PaymentConstant {
    static let AddCardHeading               = "Add Card"
    static let OriginHeading                = "Origin"
    static let DestinationHeading           = "Destination"
    static let DateHeading                  = "Date"
    static let CardHeading                  = "Card"
    static let AmountHeading                = "Amount"
    static let TransactionFee               = "Transaction Fee"
    static let TransactionFeeLocal          = "Short Trip Transaction Fee"
    static let NameOfBankHeading            = "Bank Name"
    static let AccountNameHeading           = "Name on Account"
    static let AccountNumberHeading         = "Account Number"
    static let BankRoutingHeading           = "Routing Number"
    static let CheckingAccountHeading       = "Checking Account"
    static let SwiftCodeHeading             = "Swift Code"
    static let BankAddressHeading           = "Bank Address"
    static let PaymentHeading               = "Payment"
    static let PaymentInfoHeading           = "Payment Info"
    static let PaymentHistoryHeading        = "Payment History"
    static let BankInfoHeading              = "Bank Info"
    static let DetailCellHeading              = "Select Payment Type"
    static let Earning                          = "Earning"

    static let PersonalIdNumberHeading      = "Personal Id Number"
    static let SSNLast4Heading              = "SSN (Last 4 digits)"
    static let AddressHeading               = "Address"
    static let StateHeading                 = "State"
    static let CityHeading                  = "City"
    static let PostalCodeHeading            = "Postal Code"
    static let BirthDateHeading             = "Date Of Birth"

}

struct WebViewLinks {
    
    static let MenuHelp               = "menu"
    static let FindRideHelp               = "find-ride"
    static let CreateRideHelp              = "create-ride"
    static let MyPaymentHelp                = "my-payments"
    static let MessagingHelp                = "messaging"
    static let MyTripHelp = "my-trips"


}

enum MarkTripsConstant: Int {
    case PickUp         = 0
    case DropOff        = 1
    var value: String {
        switch self {
        case .PickUp: return "/pickup"
        case .DropOff: return "/dropoff"
        }
    }
}

enum SearchTripConstant: String {
    case time = "time"
    case gender = "gender"
    var value: String {
        switch self {
        case .time: return "time"
        case .gender: return "gender"
        }
    }
}

enum BootMeUpKeys: String {
    case PreferenceKey = "preferences"
    case VehicleTypeKey = "vehicle_type"
    case MinEstimateKey = "min_estimate"
    case MaxEstimateKey = "max_estimate"
    case MakeKey = "make"
    case RefrenceSourceKey  = "reference_source"
    case TransactionFee  = "transaction_fee"
    case TransactionFeeLocal  = "transaction_fee_local"

    var value: String {
        switch self {
        case .PreferenceKey: return "preferences"
        case .VehicleTypeKey: return "vehicle_type"
        case .MinEstimateKey: return "min_estimate"
        case .MaxEstimateKey: return "max_estimate"
        case .MakeKey: return "make"
        case .RefrenceSourceKey: return "reference_source"
        case .TransactionFee: return "transaction_fee"
        case .TransactionFeeLocal: return "transaction_fee_local"
        }
    }
}

struct CreateTripEntityConstant {
    static let sectionOneEntity               = "sectionOneEntity"
    static let sectionTwoEntity               = "sectionTwoEntity"
    static let sectionThreeEntity             = "sectionThreeEntity"
}
