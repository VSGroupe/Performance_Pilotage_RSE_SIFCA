import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen_l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr')
  ];

  /// No description provided for @appTilte.
  ///
  /// In en, this message translates to:
  /// **'CSR performance'**
  String get appTilte;

  /// No description provided for @accesDenied.
  ///
  /// In en, this message translates to:
  /// **'Access denied'**
  String get accesDenied;

  /// No description provided for @accesRefusedToSpace.
  ///
  /// In en, this message translates to:
  /// **'You do not have access to this space.'**
  String get accesRefusedToSpace;

  /// No description provided for @generalHome.
  ///
  /// In en, this message translates to:
  /// **'General Home'**
  String get generalHome;

  /// No description provided for @greeting.
  ///
  /// In en, this message translates to:
  /// **'Welcome to '**
  String get greeting;

  /// No description provided for @managementFrameTitle.
  ///
  /// In en, this message translates to:
  /// **'Management'**
  String get managementFrameTitle;

  /// No description provided for @auditFrameTitle.
  ///
  /// In en, this message translates to:
  /// **'Evaluation'**
  String get auditFrameTitle;

  /// No description provided for @controlFrameTitle.
  ///
  /// In en, this message translates to:
  /// **'Steering'**
  String get controlFrameTitle;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logOut;

  /// No description provided for @logOutMessageTitle.
  ///
  /// In en, this message translates to:
  /// **'Do you want to quit the application?'**
  String get logOutMessageTitle;

  /// No description provided for @logOutMessage.
  ///
  /// In en, this message translates to:
  /// **'Click Yes to log out'**
  String get logOutMessage;

  /// No description provided for @logOutQuestion.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout'**
  String get logOutQuestion;

  /// No description provided for @logOutWarning.
  ///
  /// In en, this message translates to:
  /// **'You will be disconnected'**
  String get logOutWarning;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About Perf RSE'**
  String get about;

  /// No description provided for @aboutTitleShowDialog.
  ///
  /// In en, this message translates to:
  /// **'Performance RSE'**
  String get aboutTitleShowDialog;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @online.
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get online;

  /// No description provided for @offline.
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get offline;

  /// No description provided for @pilotageHearder.
  ///
  /// In en, this message translates to:
  /// **'SUSTAINABLE DEVELOPMENT STEERING'**
  String get pilotageHearder;

  /// No description provided for @groupConsolidation.
  ///
  /// In en, this message translates to:
  /// **'Group Consolidation'**
  String get groupConsolidation;

  /// No description provided for @oilseeds.
  ///
  /// In en, this message translates to:
  /// **'Oilseeds'**
  String get oilseeds;

  /// No description provided for @naturalRubber.
  ///
  /// In en, this message translates to:
  /// **'Natural rubber'**
  String get naturalRubber;

  /// No description provided for @sugar.
  ///
  /// In en, this message translates to:
  /// **'Sugar'**
  String get sugar;

  /// No description provided for @consolidationSectors.
  ///
  /// In en, this message translates to:
  /// **'Consolidation Sectors'**
  String get consolidationSectors;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading ...'**
  String get loading;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @strategicAxes.
  ///
  /// In en, this message translates to:
  /// **'Strategic Axes'**
  String get strategicAxes;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No Data'**
  String get noData;

  /// No description provided for @outOf.
  ///
  /// In en, this message translates to:
  /// **'out of'**
  String get outOf;

  /// No description provided for @indicators.
  ///
  /// In en, this message translates to:
  /// **'indicators'**
  String get indicators;

  /// No description provided for @actionNotEnabled.
  ///
  /// In en, this message translates to:
  /// **'You are not entitled to this action'**
  String get actionNotEnabled;

  /// No description provided for @listOfContributors.
  ///
  /// In en, this message translates to:
  /// **'List of contributors'**
  String get listOfContributors;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @noContributorMessage.
  ///
  /// In en, this message translates to:
  /// **'No contributor associated with this entity'**
  String get noContributorMessage;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @entity.
  ///
  /// In en, this message translates to:
  /// **'Entity'**
  String get entity;

  /// No description provided for @process.
  ///
  /// In en, this message translates to:
  /// **'Process'**
  String get process;

  /// No description provided for @previous.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @subsidiaryEntities.
  ///
  /// In en, this message translates to:
  /// **'Subsidiary/Entity'**
  String get subsidiaryEntities;

  /// No description provided for @collectionProgress.
  ///
  /// In en, this message translates to:
  /// **'Collection progress'**
  String get collectionProgress;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @axe3.
  ///
  /// In en, this message translates to:
  /// **'Community and societal innovation'**
  String get axe3;

  /// No description provided for @axe4.
  ///
  /// In en, this message translates to:
  /// **'Preservation of the environment'**
  String get axe4;

  /// No description provided for @issue7.
  ///
  /// In en, this message translates to:
  /// **'Social inclusion and community development'**
  String get issue7;

  /// No description provided for @axe1.
  ///
  /// In en, this message translates to:
  /// **'Governance and ethics'**
  String get axe1;

  /// No description provided for @axe0.
  ///
  /// In en, this message translates to:
  /// **'GENERAL'**
  String get axe0;

  /// No description provided for @issue1.
  ///
  /// In en, this message translates to:
  /// **'SD governance and strategy & SD steering issues'**
  String get issue1;

  /// No description provided for @issue1a.
  ///
  /// In en, this message translates to:
  /// **'SD governance and strategy'**
  String get issue1a;

  /// No description provided for @issue1b.
  ///
  /// In en, this message translates to:
  /// **'SD Steering'**
  String get issue1b;

  /// No description provided for @issue2.
  ///
  /// In en, this message translates to:
  /// **'Business ethics and responsible purchasing'**
  String get issue2;

  /// No description provided for @issue3.
  ///
  /// In en, this message translates to:
  /// **'Integrating the SD expectations of customers and consumers'**
  String get issue3;

  /// No description provided for @axe2.
  ///
  /// In en, this message translates to:
  /// **'Employment and working conditions'**
  String get axe2;

  /// No description provided for @issue4.
  ///
  /// In en, this message translates to:
  /// **'Equal treatment'**
  String get issue4;

  /// No description provided for @issue6.
  ///
  /// In en, this message translates to:
  /// **'Improving the quality of life'**
  String get issue6;

  /// No description provided for @issue5.
  ///
  /// In en, this message translates to:
  /// **'Working conditions'**
  String get issue5;

  /// No description provided for @issue10a.
  ///
  /// In en, this message translates to:
  /// **'Improvement of living conditions'**
  String get issue10a;

  /// No description provided for @issue8.
  ///
  /// In en, this message translates to:
  /// **'Climate change and deforestation'**
  String get issue8;

  /// No description provided for @issue9.
  ///
  /// In en, this message translates to:
  /// **'Water management and treatment'**
  String get issue9;

  /// No description provided for @issue10b.
  ///
  /// In en, this message translates to:
  /// **'Resource management and waste'**
  String get issue10b;

  /// No description provided for @show.
  ///
  /// In en, this message translates to:
  /// **'Display'**
  String get show;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @privacy.
  ///
  /// In en, this message translates to:
  /// **'Confidentiality'**
  String get privacy;

  /// No description provided for @termsConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms of use'**
  String get termsConditions;

  /// No description provided for @year.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get year;

  /// No description provided for @month.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get month;

  /// No description provided for @collectionProgressMessage.
  ///
  /// In en, this message translates to:
  /// **'Collection progress is equal to '**
  String get collectionProgressMessage;

  /// No description provided for @thisMonth.
  ///
  /// In en, this message translates to:
  /// **'this month. '**
  String get thisMonth;

  /// No description provided for @reported.
  ///
  /// In en, this message translates to:
  /// **'reported'**
  String get reported;

  /// No description provided for @edition.
  ///
  /// In en, this message translates to:
  /// **'Edition'**
  String get edition;

  /// No description provided for @overview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get overview;

  /// No description provided for @reference.
  ///
  /// In en, this message translates to:
  /// **'Ref'**
  String get reference;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Indicators'**
  String get title;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @deviation.
  ///
  /// In en, this message translates to:
  /// **'Deviation'**
  String get deviation;

  /// No description provided for @onOff.
  ///
  /// In en, this message translates to:
  /// **'Active/Inactive'**
  String get onOff;

  /// No description provided for @globalView.
  ///
  /// In en, this message translates to:
  /// **'Global view'**
  String get globalView;

  /// No description provided for @overallPerformance.
  ///
  /// In en, this message translates to:
  /// **'Overall performance'**
  String get overallPerformance;

  /// No description provided for @governance.
  ///
  /// In en, this message translates to:
  /// **'Governance'**
  String get governance;

  /// No description provided for @employment.
  ///
  /// In en, this message translates to:
  /// **'Employment'**
  String get employment;

  /// No description provided for @community.
  ///
  /// In en, this message translates to:
  /// **'Society'**
  String get community;

  /// No description provided for @environment.
  ///
  /// In en, this message translates to:
  /// **'Environment'**
  String get environment;

  /// No description provided for @axePerformanceGraphTitle.
  ///
  /// In en, this message translates to:
  /// **'PERFORMANCE BY STRATEGIC AXIS'**
  String get axePerformanceGraphTitle;

  /// No description provided for @performanceIn.
  ///
  /// In en, this message translates to:
  /// **'Performance in %'**
  String get performanceIn;

  /// No description provided for @issuePerformanceGraphTitleA.
  ///
  /// In en, this message translates to:
  /// **'PERFORMANCE BY PRIORITY ISSUE'**
  String get issuePerformanceGraphTitleA;

  /// No description provided for @issuePerformanceGraphTitleB.
  ///
  /// In en, this message translates to:
  /// **'Priority issues'**
  String get issuePerformanceGraphTitleB;

  /// No description provided for @filter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// No description provided for @print.
  ///
  /// In en, this message translates to:
  /// **'Print'**
  String get print;

  /// No description provided for @dataTacking.
  ///
  /// In en, this message translates to:
  /// **'Data tracking'**
  String get dataTacking;

  /// No description provided for @dataTrackingGraphTitleA.
  ///
  /// In en, this message translates to:
  /// **'Monthly data tracking'**
  String get dataTrackingGraphTitleA;

  /// No description provided for @dataTrackingGraphTitleB.
  ///
  /// In en, this message translates to:
  /// **'Number of occurrences'**
  String get dataTrackingGraphTitleB;

  /// No description provided for @emptyField.
  ///
  /// In en, this message translates to:
  /// **'Empty fields'**
  String get emptyField;

  /// No description provided for @input.
  ///
  /// In en, this message translates to:
  /// **'Input'**
  String get input;

  /// No description provided for @validatedData.
  ///
  /// In en, this message translates to:
  /// **'Validated data'**
  String get validatedData;

  /// No description provided for @collectedData.
  ///
  /// In en, this message translates to:
  /// **'Collected data'**
  String get collectedData;

  /// No description provided for @collectedValidated.
  ///
  /// In en, this message translates to:
  /// **'collected and validated'**
  String get collectedValidated;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @personalInformations.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInformations;

  /// No description provided for @accountInformation.
  ///
  /// In en, this message translates to:
  /// **'Account information'**
  String get accountInformation;

  /// No description provided for @editPassword.
  ///
  /// In en, this message translates to:
  /// **'Change my password'**
  String get editPassword;

  /// No description provided for @loadingProfileUpdating.
  ///
  /// In en, this message translates to:
  /// **'Update profile ...'**
  String get loadingProfileUpdating;

  /// No description provided for @succesUpdatingMessage.
  ///
  /// In en, this message translates to:
  /// **'Successful update'**
  String get succesUpdatingMessage;

  /// No description provided for @failUpdatingMessage.
  ///
  /// In en, this message translates to:
  /// **'Failure, A problem has occurred.'**
  String get failUpdatingMessage;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @user.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get user;

  /// No description provided for @titleUser.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get titleUser;

  /// No description provided for @forename.
  ///
  /// In en, this message translates to:
  /// **'First name'**
  String get forename;

  /// No description provided for @contacts.
  ///
  /// In en, this message translates to:
  /// **'Contacts'**
  String get contacts;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Telephone number'**
  String get phoneNumber;

  /// No description provided for @country.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get country;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// No description provided for @subsidiaries.
  ///
  /// In en, this message translates to:
  /// **'Subsidiaries'**
  String get subsidiaries;

  /// No description provided for @subsidiarie.
  ///
  /// In en, this message translates to:
  /// **'Subsidiarie'**
  String get subsidiarie;

  /// No description provided for @entities.
  ///
  /// In en, this message translates to:
  /// **'Entities'**
  String get entities;

  /// No description provided for @adress.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get adress;

  /// No description provided for @loadingUpdating.
  ///
  /// In en, this message translates to:
  /// **'Update ...'**
  String get loadingUpdating;

  /// No description provided for @userEmail.
  ///
  /// In en, this message translates to:
  /// **'Email user'**
  String get userEmail;

  /// No description provided for @accessType.
  ///
  /// In en, this message translates to:
  /// **'Type of access'**
  String get accessType;

  /// No description provided for @yourProcess.
  ///
  /// In en, this message translates to:
  /// **'Your processes'**
  String get yourProcess;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @failIncorrectPasswordMessage.
  ///
  /// In en, this message translates to:
  /// **'Failure, your current password is incorrect'**
  String get failIncorrectPasswordMessage;

  /// No description provided for @currentPassword.
  ///
  /// In en, this message translates to:
  /// **'Current password'**
  String get currentPassword;

  /// No description provided for @passwordValidatorMessage.
  ///
  /// In en, this message translates to:
  /// **'Your password must not contain spaces'**
  String get passwordValidatorMessage;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get newPassword;

  /// No description provided for @passwordChecking.
  ///
  /// In en, this message translates to:
  /// **'Password checking'**
  String get passwordChecking;

  /// No description provided for @samePasswordMessage.
  ///
  /// In en, this message translates to:
  /// **'Passwords are not identical'**
  String get samePasswordMessage;

  /// No description provided for @newUserFormTitle.
  ///
  /// In en, this message translates to:
  /// **'New User'**
  String get newUserFormTitle;

  /// No description provided for @checkNameValue.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get checkNameValue;

  /// No description provided for @nameField.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get nameField;

  /// No description provided for @checkForenameValue.
  ///
  /// In en, this message translates to:
  /// **'Please enter your first name'**
  String get checkForenameValue;

  /// No description provided for @forenameField.
  ///
  /// In en, this message translates to:
  /// **'Please enter your first names'**
  String get forenameField;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Validate'**
  String get confirm;

  /// No description provided for @incorrectLoginDetailsMessage.
  ///
  /// In en, this message translates to:
  /// **'Your login details are incorrect'**
  String get incorrectLoginDetailsMessage;

  /// No description provided for @fail.
  ///
  /// In en, this message translates to:
  /// **'Failure'**
  String get fail;

  /// No description provided for @slogan.
  ///
  /// In en, this message translates to:
  /// **'manage your sustainable development strategy with ease'**
  String get slogan;

  /// No description provided for @conexionMessage.
  ///
  /// In en, this message translates to:
  /// **'Connect to your account'**
  String get conexionMessage;

  /// No description provided for @checkEmailValueMessage.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get checkEmailValueMessage;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @passwordCheckMessage.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid password'**
  String get passwordCheckMessage;

  /// No description provided for @logIn.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get logIn;

  /// No description provided for @passwordForgetten.
  ///
  /// In en, this message translates to:
  /// **'I\'ve forgotten my password'**
  String get passwordForgetten;

  /// No description provided for @agricole.
  ///
  /// In en, this message translates to:
  /// **'Agricultural'**
  String get agricole;

  /// No description provided for @developpementDurable.
  ///
  /// In en, this message translates to:
  /// **'SD'**
  String get developpementDurable;

  /// No description provided for @finances.
  ///
  /// In en, this message translates to:
  /// **'Finance'**
  String get finances;

  /// No description provided for @achats.
  ///
  /// In en, this message translates to:
  /// **'Purchases'**
  String get achats;

  /// No description provided for @juridique.
  ///
  /// In en, this message translates to:
  /// **'Legal'**
  String get juridique;

  /// No description provided for @ressourcesHumaines.
  ///
  /// In en, this message translates to:
  /// **'HR'**
  String get ressourcesHumaines;

  /// No description provided for @medecin.
  ///
  /// In en, this message translates to:
  /// **'Doctor'**
  String get medecin;

  /// No description provided for @infrastructures.
  ///
  /// In en, this message translates to:
  /// **'Infrastructure'**
  String get infrastructures;

  /// No description provided for @ressourcesHumainesJuridique.
  ///
  /// In en, this message translates to:
  /// **'HR / Legal'**
  String get ressourcesHumainesJuridique;

  /// No description provided for @gestionStocksLogistique.
  ///
  /// In en, this message translates to:
  /// **'SM / Logistics'**
  String get gestionStocksLogistique;

  /// No description provided for @emissions.
  ///
  /// In en, this message translates to:
  /// **'Emissions'**
  String get emissions;

  /// No description provided for @usine.
  ///
  /// In en, this message translates to:
  /// **'Factory'**
  String get usine;

  /// No description provided for @locked.
  ///
  /// In en, this message translates to:
  /// **'locked'**
  String get locked;

  /// No description provided for @trueV.
  ///
  /// In en, this message translates to:
  /// **'True'**
  String get trueV;

  /// No description provided for @falseV.
  ///
  /// In en, this message translates to:
  /// **'False'**
  String get falseV;

  /// No description provided for @failValidationMessageA.
  ///
  /// In en, this message translates to:
  /// **'This information is not yet available.'**
  String get failValidationMessageA;

  /// No description provided for @succesValidationMessage.
  ///
  /// In en, this message translates to:
  /// **'The data has been successfully validated.'**
  String get succesValidationMessage;

  /// No description provided for @failValidationMessageB.
  ///
  /// In en, this message translates to:
  /// **'The data has not been validated'**
  String get failValidationMessageB;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Succes'**
  String get success;

  /// No description provided for @canceledValidationMessage.
  ///
  /// In en, this message translates to:
  /// **'Validation successfully cancelled'**
  String get canceledValidationMessage;

  /// No description provided for @failCanceledValidationMessage.
  ///
  /// In en, this message translates to:
  /// **'Validation not cancelled'**
  String get failCanceledValidationMessage;

  /// No description provided for @updateIndicatorValueMessage.
  ///
  /// In en, this message translates to:
  /// **'Update the indicator data'**
  String get updateIndicatorValueMessage;

  /// No description provided for @enterIndicatorValueMessage.
  ///
  /// In en, this message translates to:
  /// **'Enter the indicator data'**
  String get enterIndicatorValueMessage;

  /// No description provided for @successDeletedDataMessage.
  ///
  /// In en, this message translates to:
  /// **'The data has been deleted successfully'**
  String get successDeletedDataMessage;

  /// No description provided for @failDeletedDataMessage.
  ///
  /// In en, this message translates to:
  /// **'The data was not deleted.'**
  String get failDeletedDataMessage;

  /// No description provided for @countdownMessageTitle.
  ///
  /// In en, this message translates to:
  /// **'Your data will be deleted at the end of the countdown.'**
  String get countdownMessageTitle;

  /// No description provided for @deletionIn.
  ///
  /// In en, this message translates to:
  /// **'Deletion in'**
  String get deletionIn;

  /// No description provided for @seconds.
  ///
  /// In en, this message translates to:
  /// **'seconds...'**
  String get seconds;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @editionFailed.
  ///
  /// In en, this message translates to:
  /// **'Edition failed'**
  String get editionFailed;

  /// No description provided for @deletionFailed.
  ///
  /// In en, this message translates to:
  /// **'Deletion failed'**
  String get deletionFailed;

  /// No description provided for @dataEntryError.
  ///
  /// In en, this message translates to:
  /// **'Entry error'**
  String get dataEntryError;

  /// No description provided for @negativeData.
  ///
  /// In en, this message translates to:
  /// **'The value cannot be negative'**
  String get negativeData;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @failUpdatingData.
  ///
  /// In en, this message translates to:
  /// **'Data has not been updated.'**
  String get failUpdatingData;

  /// No description provided for @successUpdatingData.
  ///
  /// In en, this message translates to:
  /// **'The data has been modified successfully.'**
  String get successUpdatingData;

  /// No description provided for @actionCompleted.
  ///
  /// In en, this message translates to:
  /// **'Action completed'**
  String get actionCompleted;

  /// No description provided for @actionNotCompleted.
  ///
  /// In en, this message translates to:
  /// **'Processing not completed'**
  String get actionNotCompleted;

  /// No description provided for @indicator.
  ///
  /// In en, this message translates to:
  /// **'indicator'**
  String get indicator;

  /// No description provided for @deactivate.
  ///
  /// In en, this message translates to:
  /// **'Deactivate'**
  String get deactivate;

  /// No description provided for @activate.
  ///
  /// In en, this message translates to:
  /// **'Activate'**
  String get activate;

  /// No description provided for @unit.
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get unit;

  /// No description provided for @formulas.
  ///
  /// In en, this message translates to:
  /// **'Formulas'**
  String get formulas;

  /// No description provided for @uncheckAll.
  ///
  /// In en, this message translates to:
  /// **'Select All'**
  String get uncheckAll;

  /// No description provided for @governanceSustainableDevelopmentStrategy.
  ///
  /// In en, this message translates to:
  /// **'GOVERNANCE & SUSTAINABLE DEVELOPMENT STRATEGY'**
  String get governanceSustainableDevelopmentStrategy;

  /// No description provided for @rse.
  ///
  /// In en, this message translates to:
  /// **'CSR'**
  String get rse;

  /// No description provided for @newVersionAvailable.
  ///
  /// In en, this message translates to:
  /// **'A new version of the application is available'**
  String get newVersionAvailable;

  /// No description provided for @newVersionNote.
  ///
  /// In en, this message translates to:
  /// **'To access the latest improvements to the application, we invite you to refresh the page by clicking on the update icon. This update brings improved features and performance, ensuring an optimal user experience'**
  String get newVersionNote;

  /// No description provided for @goToHome.
  ///
  /// In en, this message translates to:
  /// **'Go to home page'**
  String get goToHome;

  /// No description provided for @abrLange.
  ///
  /// In en, this message translates to:
  /// **'EN'**
  String get abrLange;

  /// No description provided for @goToHomeRse.
  ///
  /// In en, this message translates to:
  /// **'Return to the main Perf RSE homepage'**
  String get goToHomeRse;

  /// No description provided for @spaceNotExist.
  ///
  /// In en, this message translates to:
  /// **'This space does not exist'**
  String get spaceNotExist;

  /// No description provided for @dataCreated.
  ///
  /// In en, this message translates to:
  /// **'The data has been created. Return to the previous space'**
  String get dataCreated;

  /// No description provided for @dataNotCreated.
  ///
  /// In en, this message translates to:
  /// **'The data has been created. Return to the previous space'**
  String get dataNotCreated;

  /// No description provided for @addContributeur.
  ///
  /// In en, this message translates to:
  /// **'Add a contributor'**
  String get addContributeur;

  /// No description provided for @userSelectMessage.
  ///
  /// In en, this message translates to:
  /// **'Select the entities to assign to the user'**
  String get userSelectMessage;

  /// No description provided for @espacePilotage.
  ///
  /// In en, this message translates to:
  /// **'Control page'**
  String get espacePilotage;

  /// No description provided for @accesType.
  ///
  /// In en, this message translates to:
  /// **'The type of access'**
  String get accesType;

  /// No description provided for @userSelectProcessMessage.
  ///
  /// In en, this message translates to:
  /// **'Select the processes to assign to the user'**
  String get userSelectProcessMessage;

  /// No description provided for @allfieldContributorMessage.
  ///
  /// In en, this message translates to:
  /// **'Complete all fields carefully before submitting'**
  String get allfieldContributorMessage;

  /// No description provided for @recherche.
  ///
  /// In en, this message translates to:
  /// **'Research'**
  String get recherche;

  /// No description provided for @soumettre.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get soumettre;

  /// No description provided for @accountHasCreated.
  ///
  /// In en, this message translates to:
  /// **'The account {account} has been created'**
  String accountHasCreated(Object account);

  /// No description provided for @access.
  ///
  /// In en, this message translates to:
  /// **'Access'**
  String get access;

  /// No description provided for @filiere.
  ///
  /// In en, this message translates to:
  /// **'Sector'**
  String get filiere;

  /// No description provided for @fonction.
  ///
  /// In en, this message translates to:
  /// **'Position'**
  String get fonction;

  /// No description provided for @reflesh.
  ///
  /// In en, this message translates to:
  /// **'Reflesh'**
  String get reflesh;

  /// No description provided for @bloked.
  ///
  /// In en, this message translates to:
  /// **'Is blocked'**
  String get bloked;

  /// No description provided for @number.
  ///
  /// In en, this message translates to:
  /// **'Number'**
  String get number;

  /// No description provided for @definition.
  ///
  /// In en, this message translates to:
  /// **'Definition'**
  String get definition;

  /// No description provided for @indicatorMessageDyn.
  ///
  /// In en, this message translates to:
  /// **'Indicator  {ref} -- field'**
  String indicatorMessageDyn(Object ref);

  /// No description provided for @contributeurs.
  ///
  /// In en, this message translates to:
  /// **'Contributors'**
  String get contributeurs;

  /// No description provided for @adminPanelText.
  ///
  /// In en, this message translates to:
  /// **'Admin Panel'**
  String get adminPanelText;

  /// No description provided for @activityLog.
  ///
  /// In en, this message translates to:
  /// **'Activity log'**
  String get activityLog;

  /// No description provided for @unauthorizedAction.
  ///
  /// In en, this message translates to:
  /// **'Unauthorized action'**
  String get unauthorizedAction;

  /// No description provided for @noContributorAvailableMessage.
  ///
  /// In en, this message translates to:
  /// **'No contributors available'**
  String get noContributorAvailableMessage;

  /// No description provided for @govenanceandethics.
  ///
  /// In en, this message translates to:
  /// **'GOVERNANCE AND ETHICS'**
  String get govenanceandethics;

  /// No description provided for @indicatorOn.
  ///
  /// In en, this message translates to:
  /// **'on {nombreTotal} indicators'**
  String indicatorOn(Object nombreTotal);

  /// No description provided for @energyConsumptionRate.
  ///
  /// In en, this message translates to:
  /// **'Energy Consumption Rate'**
  String get energyConsumptionRate;

  /// No description provided for @keyNumber.
  ///
  /// In en, this message translates to:
  /// **'Key number'**
  String get keyNumber;

  /// No description provided for @performanceIndicators.
  ///
  /// In en, this message translates to:
  /// **'Performance on your indicators'**
  String get performanceIndicators;

  /// No description provided for @updating.
  ///
  /// In en, this message translates to:
  /// **'Update in progress'**
  String get updating;

  /// No description provided for @role.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get role;

  /// No description provided for @passwordMustNotContainSpace.
  ///
  /// In en, this message translates to:
  /// **'Password must not contain spaces'**
  String get passwordMustNotContainSpace;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Password confirmation'**
  String get confirmPassword;

  /// No description provided for @passwordNoMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordNoMatch;

  /// No description provided for @customerSupport.
  ///
  /// In en, this message translates to:
  /// **'Customer Support'**
  String get customerSupport;

  /// No description provided for @openNewTicket.
  ///
  /// In en, this message translates to:
  /// **'New ticket'**
  String get openNewTicket;

  /// No description provided for @subject.
  ///
  /// In en, this message translates to:
  /// **'Subject'**
  String get subject;

  /// No description provided for @yourRequest.
  ///
  /// In en, this message translates to:
  /// **'Your request'**
  String get yourRequest;

  /// No description provided for @file.
  ///
  /// In en, this message translates to:
  /// **'File'**
  String get file;

  /// No description provided for @attachDocument.
  ///
  /// In en, this message translates to:
  /// **'Attach a document'**
  String get attachDocument;

  /// No description provided for @sendingProgress.
  ///
  /// In en, this message translates to:
  /// **'Sending'**
  String get sendingProgress;

  /// No description provided for @sendingSucessMessage.
  ///
  /// In en, this message translates to:
  /// **'Your request has been sent successfully'**
  String get sendingSucessMessage;

  /// No description provided for @downloadFile.
  ///
  /// In en, this message translates to:
  /// **'Click here to download a file'**
  String get downloadFile;

  /// No description provided for @fileSizeExceeds.
  ///
  /// In en, this message translates to:
  /// **'File size exceeds 500 KB limit'**
  String get fileSizeExceeds;

  /// No description provided for @errorHasOccurred.
  ///
  /// In en, this message translates to:
  /// **'An error has occurred'**
  String get errorHasOccurred;

  /// No description provided for @socialInclusionCommunity.
  ///
  /// In en, this message translates to:
  /// **'Social inclusion and community development'**
  String get socialInclusionCommunity;

  /// No description provided for @ucheckAll.
  ///
  /// In en, this message translates to:
  /// **'Uncheck all'**
  String get ucheckAll;

  /// No description provided for @checkedForShowIndicator.
  ///
  /// In en, this message translates to:
  /// **'Check the checkbox to only see the indicated indicators.\nUncheck to return to the previous state'**
  String get checkedForShowIndicator;

  /// No description provided for @indicatedIndicators.
  ///
  /// In en, this message translates to:
  /// **'See the indicated indicators'**
  String get indicatedIndicators;

  /// No description provided for @referenceIndicators.
  ///
  /// In en, this message translates to:
  /// **'Enter the reference of the indicators sought'**
  String get referenceIndicators;

  /// No description provided for @displayingDataMonth.
  ///
  /// In en, this message translates to:
  /// **'Affichage des données jusqu\'au mois de'**
  String get displayingDataMonth;

  /// No description provided for @dataNotYet.
  ///
  /// In en, this message translates to:
  /// **'The data is not yet entered'**
  String get dataNotYet;

  /// No description provided for @deleteIndicatorData.
  ///
  /// In en, this message translates to:
  /// **'Delete indicator data'**
  String get deleteIndicatorData;

  /// No description provided for @enterTargetOf.
  ///
  /// In en, this message translates to:
  /// **'Enter the target of the indicator'**
  String get enterTargetOf;

  /// No description provided for @erroneousCalculation.
  ///
  /// In en, this message translates to:
  /// **'Error, data not allowed: erroneous calculation'**
  String get erroneousCalculation;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @logs.
  ///
  /// In en, this message translates to:
  /// **'Logs'**
  String get logs;

  /// No description provided for @support.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get support;

  /// No description provided for @homeControl.
  ///
  /// In en, this message translates to:
  /// **'Control home'**
  String get homeControl;

  /// No description provided for @yourSpace.
  ///
  /// In en, this message translates to:
  /// **'Your space'**
  String get yourSpace;

  /// No description provided for @keyFigures.
  ///
  /// In en, this message translates to:
  /// **'Key figures'**
  String get keyFigures;

  /// No description provided for @csrPerformanceIndicators.
  ///
  /// In en, this message translates to:
  /// **'CSR Performance Indicators'**
  String get csrPerformanceIndicators;

  /// No description provided for @numero.
  ///
  /// In en, this message translates to:
  /// **'N°'**
  String get numero;

  /// No description provided for @updatingSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'The update was completed successfully'**
  String get updatingSuccessMessage;

  /// No description provided for @updatingFailMessage.
  ///
  /// In en, this message translates to:
  /// **'Update failed'**
  String get updatingFailMessage;

  /// No description provided for @communitiesSocietalInovation.
  ///
  /// In en, this message translates to:
  /// **'COMMUNITIES AND SOCIETAL INNOVATION'**
  String get communitiesSocietalInovation;

  /// No description provided for @general.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get general;

  /// No description provided for @typeacccesList.
  ///
  /// In en, this message translates to:
  /// **'{typeacess, select ,  admin{Admin} validator{Validator} editor{Editor} spectator{Spectator} other{Blocked}}'**
  String typeacccesList(String typeacess);

  /// No description provided for @filterprocessList.
  ///
  /// In en, this message translates to:
  /// **'{filterprocess, select ,  agricultural{Agricultural} finance{Finance} sd{SD} legal{Legal}  purchases{Purchases}  hr{HR} logistics{Logistics management} broadcasts{Broadcasts} factory{Factory} doctor{Médecin} infrastructure{Infrastructures} hrlegal{HR / Legal} other{Inconnu}}'**
  String filterprocessList(String filterprocess);

  /// No description provided for @monthLong.
  ///
  /// In en, this message translates to:
  /// **'{mois, select ,  january{January} february{February} march{March} april{April} may{May}  june{June} july{July} august{August} september{September} october{October} november{November} december{December} other{Inconnu}}'**
  String monthLong(String mois);

  /// No description provided for @checkTheCheckboxMessage.
  ///
  /// In en, this message translates to:
  /// **'Check the checkbox to only see the indicated indicators. Uncheck to return to the previous state.'**
  String get checkTheCheckboxMessage;

  /// No description provided for @seepActionMessage.
  ///
  /// In en, this message translates to:
  /// **'You did not sleep at this action'**
  String get seepActionMessage;

  /// No description provided for @recipient.
  ///
  /// In en, this message translates to:
  /// **'Recipient'**
  String get recipient;

  /// No description provided for @succesSendMessage.
  ///
  /// In en, this message translates to:
  /// **'Your request has been sent successfully.'**
  String get succesSendMessage;

  /// No description provided for @occurredErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'An error has occurred.'**
  String get occurredErrorMessage;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @technicalSupport.
  ///
  /// In en, this message translates to:
  /// **'Technical support'**
  String get technicalSupport;

  /// No description provided for @sendTo.
  ///
  /// In en, this message translates to:
  /// **'Send to'**
  String get sendTo;

  /// No description provided for @monthlyDataTrackingFor.
  ///
  /// In en, this message translates to:
  /// **'Monthly data tracking for'**
  String get monthlyDataTrackingFor;

  /// No description provided for @collected.
  ///
  /// In en, this message translates to:
  /// **'Collected'**
  String get collected;

  /// No description provided for @passwordSuccessfullyUpdatedMessage.
  ///
  /// In en, this message translates to:
  /// **'Your password has been successfully updated'**
  String get passwordSuccessfullyUpdatedMessage;

  /// No description provided for @passwordIncorrectMessage.
  ///
  /// In en, this message translates to:
  /// **'Password is incorrect'**
  String get passwordIncorrectMessage;

  /// No description provided for @profileUpdateProgress.
  ///
  /// In en, this message translates to:
  /// **'Profile update in progress'**
  String get profileUpdateProgress;

  /// No description provided for @userTilte.
  ///
  /// In en, this message translates to:
  /// **'User title'**
  String get userTilte;

  /// No description provided for @noDataAvailable.
  ///
  /// In en, this message translates to:
  /// **'No data available.'**
  String get noDataAvailable;

  /// No description provided for @on.
  ///
  /// In en, this message translates to:
  /// **'On'**
  String get on;

  /// No description provided for @noContributorsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No contributors available.'**
  String get noContributorsAvailable;

  /// No description provided for @hour.
  ///
  /// In en, this message translates to:
  /// **'Hour'**
  String get hour;

  /// No description provided for @approximateLocation.
  ///
  /// In en, this message translates to:
  /// **'Approximate location'**
  String get approximateLocation;

  /// No description provided for @completeAllFields.
  ///
  /// In en, this message translates to:
  /// **'Complete all fields carefully before submitting'**
  String get completeAllFields;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @field.
  ///
  /// In en, this message translates to:
  /// **'Field'**
  String get field;

  /// No description provided for @typeoperation.
  ///
  /// In en, this message translates to:
  /// **'{operation, select ,  calculed{Calculed} primary{Primary} test{Test} other{__}}'**
  String typeoperation(String operation);

  /// No description provided for @typecalcul.
  ///
  /// In en, this message translates to:
  /// **'{calcul, select ,  average{Average} sum{Sum} lastmonth{Last month entered} other{__}}'**
  String typecalcul(String calcul);

  /// No description provided for @searchBarManageUser.
  ///
  /// In en, this message translates to:
  /// **'Search by email, name or first name'**
  String get searchBarManageUser;

  /// No description provided for @validatorEditAccesTooltip.
  ///
  /// In en, this message translates to:
  /// **'Validator capable of collecting'**
  String get validatorEditAccesTooltip;

  /// No description provided for @validatorNoEditAccesTooltip.
  ///
  /// In en, this message translates to:
  /// **'Validator unable to collect'**
  String get validatorNoEditAccesTooltip;

  /// No description provided for @alert.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get alert;

  /// No description provided for @checkboxListAlertMessage.
  ///
  /// In en, this message translates to:
  /// **'Please select at least one item.'**
  String get checkboxListAlertMessage;

  /// No description provided for @excelFileTitle.
  ///
  /// In en, this message translates to:
  /// **'CSR Performance Indicators'**
  String get excelFileTitle;

  /// No description provided for @company.
  ///
  /// In en, this message translates to:
  /// **'Company'**
  String get company;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'fr': return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
