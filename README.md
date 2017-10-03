# DevsDNAStarterPack

A starter package to get all you need when you start a new project for Xamarin Forms
You can include starter files to build your project, you can use this nugets packages:

[**Core**](https://www.nuget.org/packages/DevsDNAStarterPack.Core/)

[**Android Platform**](https://www.nuget.org/packages/DevsDNAStarterPack.Droid/)

[**iOS Platform**](https://www.nuget.org/packages/DevsDNAStarterPack.Touch/)


# Project Structure

## Structure

In DevsDNA propose this way to structure your Xamarin Forms projects.

## Base

  There are inside Base files for ViewModels and Views
  
## Common

  Include KeyValue files for all Settings 
  
## CommonServices

  In this folder include all Services. There are several services that include with nuget package
  
    - ConnectionService. Interface for check internet connection
    
    - CustomDependencyService. Envelop DependencyService
    
    - DialogService. Dialog service for include your messages inside ViewModel
    
    - LocalizationService. Service for all translation service.
    
    - NavigationService. Allow abstract all navigation service.
    
    - SettingsService. Settings keys value
    
## Features

   For this folder include all views and viewsmodels. The best way to all it's in order it's create a every folder for view and viewmodel. 
    
## Strings

   Include files for localization.
    
## XamlExtensions

   Inside this folder you can include all XamlExtensions. Inside there TranslateExtensions for localization.
