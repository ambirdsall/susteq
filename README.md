Susteq
======

[![Build Status](https://travis-ci.org/ambirdsall/susteq.svg?branch=master)](https://travis-ci.org/ambirdsall/susteq)

End-to-End Water Hub Data Management Platform for [Susteq](http://susteq.nl) in Kenya

This repo is a fork of the [original](https://github.com/DBC-Susteq/susteq), a final project from the 2014 Mule Deer cohort at [Dev Bootcamp](http://www.devbootcamp.com). It was written in one week, and I'm proud of that work: but I have more time and more experience now than I did then, and I intend to whip this into a cleaner, more professional, and more efficient code base. :scissors: :pencil2: :triangular_ruler: :paperclip: :thumbsup:

###An Overview
####The Dashboard
The first page you will see upon logging in, the dashboard contains a useful overview of graphs for all hubs in your system. If you'd like to minimize the map, just click on the minus sign on its upper-right corner.

####Operations
The bottom link in the sidebar contains tables of information for all kiosks and water points, including sales, liters of water dispensed, and error codes. Each table is searchable, should you want to find information for a subset of your data.

####Providers, Kiosks, and Water Points
Each of these links on the sidebar takes you to a page containing summary graphs and a table of all items of that type. Each entry in the table is a link to an individual summary page, with more detailed information about that particular Provider, Kiosk, or Water Point.

###Getting Started
####Creating Accounts
Once we remove the fake seed data, there will be one premade Admin account for our app. To log in initially, please use the email `team@susteq.nl` and the password `welcome`. Once logged in, you can click the button reading "+ new" on the right side of the black header bar to create individual accounts. You can also create new accounts by clicking on the person icon in the header to find a "Manage Admins" link. This will be useful for deleting the `team@susteq.nl` account, or modifying its password from the one displayed here.

An small, but important, note: only one computer can be logged in under each account at any time. If a second computer logs in as `team@susteq.nl`, for example, the server will assign a new token to it, and the first user will find himself logged out. This should not be a concern once each of you has an individual account.

####Entering Your Providers Into the System
The app is designed with the idea that water points and kiosks are affiliated with certain water providers. The easiest way to set this relationship up for your existing partners is to first create a new provider in the system and then create the water points and kiosks it operates.

To do this, first click on "+ New" in the header, then "Provider". Once the filled out form is submitted, you will be redirected to the Providers index. This is the same page you will find by following the "Providers" link in the sidebar. Clicking on the link to your new provider will take you to its summary page, where you will find buttons to create new water points, kiosks, or employees for that particular provider. Once you've created a single employee for that provider, they can create others for their coworkers or new hires.

###Team Members
- Whitney O'Banner
- Eric Kennedy
- Igor Gaelzer
- Ori Pleban
- Alex Birdsall
- Melissa McCoy

###Project Status

[Kanban Board](https://trello.com/b/9fDMEedR/flowteq-tbd)
